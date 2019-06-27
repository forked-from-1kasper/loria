source = {
    ["electricity:infinite_electricity"] = {
        emf = 50, resis = 0.5
    },
}

conductor = {
    ["electricity:aluminum_cable"] = {
        resis = 0.1
    },
}

consumer = {
    ["electricity:infinite_consumer"] = {
        resis = 5
    },
}

value_minimal = 0.001
cable_tick = 0.1

local function neighbors(height)
    return {
        vector.new( 1, height,  0),
        vector.new(-1, height,  0),
        vector.new( 0, height,  1),
        vector.new( 0, height, -1)
    }
end

minetest.register_node("electricity:aluminum_cable", {
    description = "Aluminium cable",
    drawtype = "raillike",
    tiles = { "electricity_aluminum_cable_normal.png",
              "electricity_aluminum_cable_curved.png",
              "electricity_aluminum_cable_t_junction.png",
              "electricity_aluminum_cable_crossing.png" },
    inventory_image = "electricity_aluminum_cable_normal.png",
    wield_image = "electricity_aluminum_cable_normal.png",
    is_ground_content = false,
    walkable = false,
    sunlight_propagates = true,
    paramtype = "light",
    drop = 'electricity:aluminum_cable',
    groups = { crumbly = 3 },

    on_construct = function(pos)
        minetest.get_node_timer(pos):start(cable_tick)
    end,

    selection_box = {
        type = "fixed",
        fixed = { -1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2 },
    },

    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)

        local update_time = meta:get_float("update_time")
        if elapsed >= update_time then
            meta:set_float("I", 0)
            meta:set_float("U", 0)
            meta:set_float("update_time", 0)
        else
            meta:set_float("update_time", update_time - elapsed)
        end

        return true
    end,
})

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

    for height = -1, 1 do
        for _, vect in ipairs(neighbors(height)) do
            local pos = vector.add(circuit[#circuit], vect)
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
                    for _, v in ipairs(find_circuits(circuit_tail, already_processed)) do
                        table.insert(res, v)
                    end
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
    groups = { crumbly = 3 },

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        minetest.get_node_timer(pos):start(cable_tick)
    end,

    on_timer = function(pos, elapsed)
        local circuits = find_circuits({ vector.add(vector.new(1, 0, 0), pos) }, { })
        local resists = { }

        local R = 0
        for idx, circuit in ipairs(circuits) do
            local R0 = 0
            for _, pos in ipairs(circuit) do
                local name = minetest.get_node(pos).name
                local conf = consumer[name] or conductor[name]
                R0 = R0 + conf.resis
            end
            resists[idx] = R0
            R = R + 1.0 / R0
        end

        local conf = source["electricity:infinite_electricity"]

        local R = 1.0 / R
        local I = conf.emf / (R + conf.resis)
        local U = I * R

        for idx, circuit in ipairs(circuits) do
            local R0 = resists[idx]
            local I0 = U / R0

            local R = 0
            for _, pos in ipairs(circuit) do
                local name = minetest.get_node(pos).name
                local conf = consumer[name] or conductor[name]
                R = R + conf.resis

                local meta = minetest.get_meta(pos)
                meta:set_float("I", I0)
                meta:set_float("U", I0 * R)
                meta:set_float("update_time", 0.5)
            end
        end

        return true
    end,
})

minetest.register_craftitem("electricity:multimeter", {
    inventory_image = "electricity_multimeter.png",
    description = "Multimeter",
    stack_max = 1,
    liquids_pointable = true,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        local meta = minetest.get_meta(pointed_thing.under)
        minetest.chat_send_player(user:get_player_name(), string.format(
            "I = %f, U = %f", meta:get_float("I"), meta:get_float("U")
        ))

        return
    end
})

minetest.register_node("electricity:infinite_consumer", {
    description = "Infinite consumer",
    tiles = { "default_test.png^[colorize:#ff000050" },
    drop = 'electricity:infinite_consumer',
    groups = { crumbly = 3 }
})