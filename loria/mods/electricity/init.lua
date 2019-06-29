source = {
    ["electricity:infinite_electricity"] = {
        emf = 50, resis = 0.5
    },
}

conductor = {
    ["electricity:aluminium_cable"] = {
        resis = 0.01
    },
}

consumer = {
    ["electricity:infinite_consumer"] = {
        resis = 1
    },
    ["electricity:heavy_infinite_consumer"] = {
        resis = 0.05
    }
}

cable_tick = 0.1

local function neighbors(height)
    return {
        vector.new( 1, height,  0),
        vector.new(-1, height,  0),
        vector.new( 0, height,  1),
        vector.new( 0, height, -1)
    }
end

local cable_neighbors = {
    vector.new( 1,  0,  0),
    vector.new(-1,  0,  0),
    vector.new( 0,  0,  1),
    vector.new( 0,  0, -1),
    vector.new( 0,  1,  0),
    vector.new( 0, -1,  0)
}

local function fix_processed(already_processed, pos)
    if not already_processed[pos.x] then
        already_processed[pos.x] = { }
    end

    if not already_processed[pos.x][pos.y] then
        already_processed[pos.x][pos.y] = { }
    end
end

local function set_processed(already_processed, pos)
    fix_processed(already_processed, pos)
    already_processed[pos.x][pos.y][pos.z] = true
end

local function get_processed(already_processed, pos)
    fix_processed(already_processed, pos)
    return already_processed[pos.x][pos.y][pos.z]
end

local function find_circuits(circuit, already_processed)
    local res = { }

    local current = circuit[#circuit]
    local current_name = minetest.get_node(current).name
    if not (consumer[current_name] or conductor[current_name]) then
        return res
    end

    for _, vect in ipairs(cable_neighbors) do
        local pos = vector.add(current, vect)
        local name = minetest.get_node(pos).name

        if (consumer[name] or conductor[name]) and
           not get_processed(already_processed, pos) then

            local circuit_tail = { }
            for idx, v in ipairs(circuit) do
                circuit_tail[idx] = v
            end
            table.insert(circuit_tail, pos)

            set_processed(already_processed, pos)

            if consumer[name] then
                table.insert(res, circuit_tail)
            elseif conductor[name] then
                if minetest.get_meta(pos):get_float("user_resis") > 0 then
                    table.insert(res, circuit_tail)
                end

                for _, v in ipairs(find_circuits(circuit_tail, already_processed)) do
                    table.insert(res, v)
                end
            end
        end
    end

    return res
end

minetest.register_node("electricity:infinite_electricity", {
    description = "Infinite electricity",
    tiles = { "default_test.png" },
    drop = 'electricity:infinite_electricity',
    groups = { crumbly = 3, source = 1, },

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        minetest.get_node_timer(pos):start(cable_tick)
    end,

    on_timer = function(pos, elapsed)
        local circuits = { }
        for _, vect in ipairs(neighbors(0)) do
            for _, circuit in ipairs(find_circuits({ vector.add(vect, pos) }, { })) do
                table.insert(circuits, circuit)
            end
        end

        local circuit_resists = { }
        local elem_resists = { }

        local R = 0
        for circuit_idx, circuit in ipairs(circuits) do
            local R0 = 0
            elem_resists[circuit_idx] = { }

            for idx, pos in ipairs(circuit) do
                local name = minetest.get_node(pos).name
                local conf = consumer[name] or conductor[name]
                if conf then
                    local user_resis = minetest.get_meta(pos):get_float("user_resis")
                    local elem_resis = conf.resis + user_resis
                    R0 = R0 + elem_resis
                    elem_resists[circuit_idx][idx] = elem_resis
                end
            end

            circuit_resists[circuit_idx] = R0
            R = R + (1.0 / R0)
        end

        local conf = source["electricity:infinite_electricity"]

        local meta = minetest.get_meta(pos)
        local user_resis = meta:get_float("user_resis")
        if user_resis ~= 0 then
            R = R + (1.0 / user_resis)
        end

        local R = 1.0 / R
        local I = conf.emf / (R + conf.resis)
        local U = I * R

        local P = 0
        for circuit_idx, circuit in ipairs(circuits) do
            for idx, pos in ipairs(circuit) do
                local R = circuit_resists[circuit_idx]
                local I = U / R -- I = I0

                local R0 = elem_resists[circuit_idx][idx]
                if R0 then
                    local U0 = I * R0

                    P = P + I * U0

                    local meta = minetest.get_meta(pos)
                    meta:set_float("I", meta:get_float("I") + I)
                    meta:set_float("U", meta:get_float("U") + U0)
                end
            end
        end

        meta:set_float("I", I)
        meta:set_float("U", conf.emf - I * conf.resis)
        meta:set_string("formspec", string.format(
            "size[2,1]label[0,0;Infinite electricity]label[0,0.5;P = %f]", P
        ))

        return true
    end,
})

local multimeter_resis = 0.1
local multimeter_timeout = 0.5
minetest.register_tool("electricity:multimeter", {
    inventory_image = "electricity_multimeter.png",
    description = "Multimeter",
    stack_max = 1,
    liquids_pointable = true,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        local name = minetest.get_node(pointed_thing.under).name
        local meta = minetest.get_meta(pointed_thing.under)

        meta:set_float("user_resis", multimeter_resis)
        minetest.after(multimeter_timeout, function(meta, name)
            minetest.chat_send_player(name, string.format(
                "I = %f, U = %f", meta:get_float("I"), meta:get_float("U")
            ))

            meta:set_float("user_resis", 0)
        end, meta, user:get_player_name())
        return
    end,
})

local function run_timer(pos)
    minetest.get_node_timer(pos):start(cable_tick)
end

local function reset_current(pos, elapsed)
    meta = minetest.get_meta(pos)
    meta:set_float("I", meta:get_float("I") / 2)
    meta:set_float("U", meta:get_float("U") / 2)
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
    tiles = { "electricity_aluminium_cable.png",
              "electricity_aluminium_cable.png",
              "electricity_aluminium_cable_side.png",
              "electricity_aluminium_cable_side.png",
              "electricity_aluminium_cable_side.png",
              "electricity_aluminium_cable_side.png" },

    inventory_image = "electricity_aluminium_cable_item.png",
    wield_image = "electricity_aluminium_cable_item.png",
    is_ground_content = false,
    sunlight_propagates = true,
    paramtype = "light",
    drop = 'electricity:aluminium_cable',
    groups = { crumbly = 3, dig_immediate = 3, conductor = 1 },

    selection_box = cable_box,
    node_box = cable_box,

    connects_to = { "group:consumer", "group:source", "group:conductor" },

    on_construct = run_timer,
    on_timer = reset_current,
})

minetest.register_node("electricity:infinite_consumer", {
    description = "Infinite consumer",
    tiles = { "default_test.png^[colorize:#ff000050" },
    drop = 'electricity:infinite_consumer',
    groups = { crumbly = 3, consumer = 1, },

    on_construct = run_timer,
    on_timer = reset_current,
})

minetest.register_node("electricity:heavy_infinite_consumer", {
    description = "Infinite consumer",
    tiles = { "default_test.png^[colorize:#00ff0050" },
    drop = 'electricity:heavy_infinite_consumer',
    groups = { crumbly = 3, consumer = 1 },

    on_construct = run_timer,
    on_timer = reset_current,
})