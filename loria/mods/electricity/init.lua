dofile(minetest.get_modpath("electricity").."/multimeter.lua")

source = {}
quadripole = {}

cable_tick = 0.1

local source_neighbors = {
    vector.new( 1, 0,  0),
    vector.new(-1, 0,  0),
    vector.new( 0, 0,  1),
    vector.new( 0, 0, -1)
}

local cable_neighbors = {
    vector.new( 1,  0,  0),
    vector.new(-1,  0,  0),
    vector.new( 0,  0,  1),
    vector.new( 0,  0, -1),
    vector.new( 0,  1,  0),
    vector.new( 0, -1,  0)
}

local function serialize_pos(pos)
    return string.format("%f,%f,%f", pos.x, pos.y, pos.z)
end

local function deserialize_pos(str)
    local x, y, z = str:match("([^,]+),([^,]+),([^,]+)")
    return vector.new(tonumber(x), tonumber(y), tonumber(z))
end

minetest.register_node("electricity:infinite_electricity", {
    description = "Infinite electricity",
    tiles = { "default_test.png" },
    drop = 'electricity:infinite_electricity',
    groups = { crumbly = 3, source = 1 },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)

        meta:set_float("resis", 0.5)
        meta:set_float("emf", 230)
    end,
})
source["electricity:infinite_electricity"] = function(meta, P, R, emf, elapsed)
    meta:set_string("formspec", string.format(
        "size[2,1.5]" ..
        "label[0,0;Infinite electricity]" ..
        "label[0,0.5;P = %f]" ..
        "label[0,1;ε = %f]",
        P, emf
    ))
    return 230
end

local function battery_box_formspec(P, emf)
    return string.format(
        "size[8,6.5]" ..
        "label[0,0;Battery box]" ..
        "label[0,0.5;P = %f]" ..
        "label[0,1;ε = %f]" ..
        "list[context;box;1.5,0.5;6,1;]" ..
        "list[current_player;main;0,2;8,1;]"..
        "list[current_player;main;0,3.5;8,3;8]",
        P, emf
    )
end

minetest.register_node("electricity:battery", {
    description = "Battery box",
    tiles = {
        "electricity_battery_top.png",
        "electricity_battery_bottom.png",
        "electricity_battery_side.png",
        "electricity_battery_side.png",
        "electricity_battery_side.png",
        "electricity_battery_side.png"
    },
    drop = 'electricity:battery',
    groups = { crumbly = 3, source = 1 },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("box", 6)
        meta:set_float("resis", 0.4)
        meta:set_float("emf", 25)

        meta:set_string("formspec", battery_box_formspec(0, 0))
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if stack:get_name() == "default:battery" then
            return stack:get_count()
        else
            return 0
        end
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack(from_list, from_index)

        if to_list == "box" then
            if stack:get_name() == "default:battery" then
                return stack:get_count()
            else
                return 0
            end
        else
            return stack:get_count()
        end
    end,

    on_destruct = drop_everything,
})
source["electricity:battery"] = function(meta, P, R, emf, elapsed)
    local inv = meta:get_inventory()

    meta:set_string("formspec", battery_box_formspec(P, emf))

    local emf = 0
    local wear = 5 * P * elapsed
    for idx, stack in ipairs(inv:get_list("box")) do
        if stack:get_name() == "default:battery" then
            emf = emf + (65536 - stack:get_wear()) * 5 / 65536

            if stack:get_wear() + wear >= 65535 then
                stack:set_name("default:aluminium_case")
                stack:set_wear(0)
            else
                stack:add_wear(wear)
            end
            inv:set_stack("box", idx, stack)
        end
    end

    return emf
end

function run_timer(resis)
    return (function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_float("resis", resis)

        minetest.get_node_timer(pos):start(cable_tick)
    end)
end

function reset_current(pos, elapsed)
    local meta = minetest.get_meta(pos)
    local timeout = meta:get_float("electricity_timeout")

    if timeout <= elapsed then
        meta:set_float("I", 0)
        meta:set_float("U", 0)
        meta:set_float("electricity_timeout", 0)
    else
        meta:set_float("electricity_timeout", timeout - elapsed)
    end

    return true
end

cable_box = {
    type = "connected",
    fixed = { -1/16, -1/2, -1/16, 1/16, -1/2+1/16, 1/16 },
    connect_top = { -1/16, -1/2, -1/16, 1/16, 1/2, 1/16 },
    connect_bottom = { -1/16, -1/2, -1/16, 1/16, -1/2+1/16, 1/16 },
    connect_front = { -1/16, -1/2, -1/2, 1/16, -1/2+1/16, 1/16 },
    connect_left = { -1/2, -1/2, -1/16, 1/16, -1/2+1/16, 1/16 },
    connect_back = { -1/16, -1/2, -1/16, 1/16, -1/2+1/16, 1/2 },
    connect_right = { -1/16, -1/2, -1/16, 1/2, -1/2+1/16, 1/16 },
}

minetest.register_node("electricity:aluminium_cable", {
    description = "Aluminium cable",
    drawtype = "nodebox",
    tiles = {
        "electricity_aluminium_cable.png",
        "electricity_aluminium_cable.png",
        "electricity_aluminium_cable_side.png",
        "electricity_aluminium_cable_side.png",
        "electricity_aluminium_cable_side.png",
        "electricity_aluminium_cable_side.png"
    },

    inventory_image = "electricity_aluminium_cable_item.png",
    wield_image = "electricity_aluminium_cable_item.png",
    is_ground_content = false,
    sunlight_propagates = true,
    paramtype = "light",
    drop = 'electricity:aluminium_cable',
    groups = { crumbly = 3, dig_immediate = 3, conductor = 1, cable = 1 },

    selection_box = cable_box,
    node_box = cable_box,

    connects_to = {
        "group:consumer",
        "group:source",
        "group:conductor",
        "group:disabled_electric_tool",
    },

    on_construct = run_timer(0.01),
    on_timer = reset_current,
})

transformer_box = {
    type = "fixed",
    fixed = {
        { -1/2, -1/2, -1/2, 1/2, -1/2+2/16, 1/2 },
        { -1/2+2/16, -1/2+2/16, -1/2+2/16, 1/2-2/16, 1/2-2/16, 1/2-2/16 },
        { -1/2, 1/2-2/16, -1/2, 1/2, 1/2, 1/2 },
    },
}

transformer_restrictions = { min = 1/10, max = 10 }
transformer_resis = 0.1

local function nullator(I, U)
    return { I = 0, U = 0 }
end

minetest.register_node("electricity:transformer", {
    description = "Transformer",
    tiles = {
        "electricity_transformer.png",
        "electricity_transformer.png",
        "electricity_transformer_side.png",
        "electricity_transformer_side.png",
        "electricity_transformer_side.png",
        "electricity_transformer_side.png",
    },
    drop = 'electricity:transformer',
    groups = { crumbly = 3, conductor = 1 },

    paramtype = "light",
    drawtype = "nodebox",
    node_box = transformer_box,
    selection_box = transformer_box,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("primary", 1)
        inv:set_size("secondary", 1)

        meta:set_string("formspec",
            "size[8,6.5]" ..
            "label[2,0;Primary winding]" ..
            "list[context;primary;2,0.5;1,1;]" ..
            "label[5,0;Secondary winding]" ..
            "list[context;secondary;5,0.5;1,1;]" ..
            "list[current_player;main;0,2;8,1;]" ..
            "list[current_player;main;0,3.5;8,3;8]"
        )

        run_timer(transformer_resis)(pos)
    end,
    on_destruct = drop_everything,
    on_timer = reset_current,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if minetest.get_item_group(stack:get_name(), "cable") > 0 then
            return stack:get_count()
        else
            return 0
        end
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack(from_list, from_index)

        if to_list == "primary" or to_list == "secondary" then
            if minetest.get_item_group(stack:get_name(), "cable") > 0 then
                return stack:get_count()
            else
                return 0
            end
        else
            return stack:get_count()
        end
    end,
})
quadripole["electricity:transformer"] = function(meta)
    local inv = meta:get_inventory()
    local prim_winding = inv:get_stack("primary", 1)
    local sec_winding = inv:get_stack("secondary", 1)

    local N1 = prim_winding:get_count()
    local N2 = sec_winding:get_count()

    if N1 == 0 or N2 == 0 or
       minetest.get_item_group(prim_winding:get_name(), "cable") == 0 or
       minetest.get_item_group(sec_winding:get_name(), "cable") == 0 then
        return nullator
    else
        local n = N2 / N1

        if n >= transformer_restrictions.min and n <= transformer_restrictions.max then
            return (function(I, U) return { I = I / n, U = U * n } end)
        else
            return nullator
        end
    end
    meta:set_float("resis", (N1 + N2 + 1) * transformer_resis)
end

switch_box = {
    type = "fixed",
    fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+3/16, 1/2},
}

minetest.register_node("electricity:switch_off", {
    description = "Switch",
    tiles = {
        "electricity_switch_top_off.png",
        "electricity_switch_bottom.png",
        "electricity_switch_side.png",
        "electricity_switch_side.png",
        "electricity_switch_side.png",
        "electricity_switch_side.png"
    },

    drop = 'electricity:switch_off',
    groups = { crumbly = 3, disabled_electric_tool = 1 },

    paramtype = "light",
    drawtype = "nodebox",
    node_box = switch_box,
    selection_box = switch_box,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        meta:set_float("resis", 0.05)

        minetest.get_node_timer(pos):start(cable_tick)
        minetest.swap_node(pos, { name = "electricity:switch_on" })
    end,
})

minetest.register_node("electricity:switch_on", {
    description = "Switch (active)",
    tiles = {
        "electricity_switch_top_on.png",
        "electricity_switch_bottom.png",
        "electricity_switch_side.png",
        "electricity_switch_side.png",
        "electricity_switch_side.png",
        "electricity_switch_side.png"
    },

    drop = 'electricity:switch_off',
    groups = { crumbly = 3, conductor = 1, not_in_creative_inventory = 1 },

    paramtype = "light",
    drawtype = "nodebox",
    node_box = switch_box,
    selection_box = switch_box,

    on_timer = reset_current,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        meta:set_float("I", 0)
        meta:set_float("U", 0)
        meta:set_float("electricity_timeout", 0)

        minetest.get_node_timer(pos):stop()
        minetest.swap_node(pos, { name = "electricity:switch_off" })
    end,
})

minetest.register_node("electricity:infinite_consumer", {
    description = "Infinite consumer",
    tiles = { "default_test.png^[colorize:#ff000050" },
    drop = 'electricity:infinite_consumer',
    groups = { crumbly = 3, consumer = 1, },

    on_construct = run_timer(5),
    on_timer = reset_current,
})

minetest.register_node("electricity:heavy_infinite_consumer", {
    description = "Infinite consumer",
    tiles = { "default_test.png^[colorize:#00ff0050" },
    drop = 'electricity:heavy_infinite_consumer',
    groups = { crumbly = 3, consumer = 1 },

    on_construct = run_timer(50),
    on_timer = reset_current,
})

local function find_circuits(current, circuit, already_processed)
    local res = { }
    local neighbors

    for _, vect in ipairs(cable_neighbors) do
        local pos = vector.add(current, vect)
        local name = minetest.get_node(pos).name
        
        if (minetest.get_item_group(name, "consumer") > 0 or
            minetest.get_item_group(name, "conductor") > 0) and
           not already_processed[serialize_pos(pos)] then
            local meta = minetest.get_meta(pos)

            meta:set_float("I", 0)
            meta:set_float("U", 0)

            meta:set_float("electricity_timeout", 1)

            local circuit_tail = { }
            for idx, v in ipairs(circuit) do
                circuit_tail[idx] = v
            end
            table.insert(circuit_tail, pos)

            already_processed[serialize_pos(pos)] = true

            if minetest.get_item_group(name, "consumer") > 0 then
                table.insert(res, circuit_tail)
            elseif minetest.get_item_group(name, "conductor") > 0 then
                local next_circuits = find_circuits(pos, circuit_tail, already_processed)

                if meta:get_float("user_resis") > 0 and #next_circuits == 0 then
                    table.insert(res, circuit_tail)
                end

                for _, v in ipairs(next_circuits) do
                    table.insert(res, v)
                end
            end
        end
    end

    return res
end

local function calculate_resis(circuits)
    local circuit_resists = { }

    local R = 0
    for circuit_idx, circuit in ipairs(circuits) do
        local R0 = 0

        for idx, pos in ipairs(circuit) do
            local name = minetest.get_node(pos).name

            if minetest.get_item_group(name, "consumer") > 0 or
               minetest.get_item_group(name, "conductor") > 0 then
                local meta = minetest.get_meta(pos)
                R0 = R0 + meta:get_float("resis") + meta:get_float("user_resis")
            end
        end

        circuit_resists[circuit_idx] = R0
        R = R + (1 / R0)
    end

    if R ~= 0 then
        R = 1 / R
    end

    return { circuit_resists = circuit_resists, R = R }
end

local function measurement_delta(X)
    if X == 0 then
        return 0
    else
        return X + math.random() / 2
    end
end

local function calculate_circuits(resists, circuits, I, U)
    local P = 0
    for circuit_idx, circuit in ipairs(circuits) do
        transformations = { }
        for idx, pos in ipairs(circuit) do
            local R = resists.circuit_resists[circuit_idx]
            local I = U / R -- I = I0

            local meta = minetest.get_meta(pos)
            local R0 = meta:get_float("resis") + meta:get_float("user_resis")
            local U0 = I * R0
            P = P + I * U0

            local I = measurement_delta(I)
            local U = measurement_delta(U0)

            for _, trans in ipairs(transformations) do
                local transformed = trans(I, U)
                I = transformed.I
                U = transformed.U
            end

            meta:set_float("I", meta:get_float("I") + I)
            meta:set_float("U", meta:get_float("U") + U)

            trans = quadripole[minetest.get_node(pos).name]
            if trans then
                table.insert(transformations, trans(meta))
            end
        end
    end

    return { P = P }
end

local function process_source(pos, circuits, elapsed)
    local name = minetest.get_node(pos).name
    if minetest.get_item_group(name, "source") == 0 then
        return
    end

    local resists = calculate_resis(circuits)

    local meta = minetest.get_meta(pos)
    local emf = meta:get_float("emf")
    local r = meta:get_float("resis")

    local R = resists.R + meta:get_float("user_resis")

    local I = emf / (R + r)
    local U = I * R

    local values = calculate_circuits(resists, circuits, I, U)

    meta:set_float("I", I)
    meta:set_float("U", emf - I * r)

    meta:set_float("emf", source[name](meta, values.P, R, emf, elapsed))
end

sources = { }

minetest.register_abm{
    label = "Enable electrcity sources",
    nodenames = { "group:source" },
    interval = 1,
    chance = 1,
    action = function(pos)
        sources[serialize_pos(pos)] = 1
    end,
}

minetest.register_globalstep(function(dtime)
    local circuits = { }

    for str, time in pairs(sources) do
        if dtime >= time then
            sources[str] = nil
        else
            sources[str] = time - dtime

            local pos = deserialize_pos(str)
            local already_processed = {}
            already_processed[serialize_pos(pos)] = true

            circuits[str] = find_circuits(pos, { }, already_processed)
        end
    end

    for str, _ in pairs(sources) do
        local pos = deserialize_pos(str)
        process_source(pos, circuits[str], dtime)
    end
end)