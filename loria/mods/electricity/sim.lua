local neighbors = {
    vector.new( 1,  0,  0),
    vector.new(-1,  0,  0),
    vector.new( 0,  0,  1),
    vector.new( 0,  0, -1),
    vector.new( 0,  1,  0),
    vector.new( 0, -1,  0)
}

function serialize_pos(pos)
    return string.format("%f,%f,%f", pos.x, pos.y, pos.z)
end

function deserialize_pos(str)
    local x, y, z = str:match("([^,]+),([^,]+),([^,]+)")
    return vector.new(tonumber(x), tonumber(y), tonumber(z))
end

function find_circuits(current, circuit, already_processed)
    local res = { }

    for _, vect in ipairs(neighbors) do
        local pos = vector.add(current, vect)
        local name = minetest.get_node(pos).name
        
        if (minetest.get_item_group(name, "consumer") > 0 or
            minetest.get_item_group(name, "conductor") > 0) and
           not already_processed[serialize_pos(pos)] then
            local meta = minetest.get_meta(pos)

            meta:set_float("I", 0)
            meta:set_float("U", 0)

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

function reset_circuits(current, already_processed)
    for _, vect in ipairs(neighbors) do
        local pos = vector.add(current, vect)
        local name = minetest.get_node(pos).name

        if (minetest.get_item_group(name, "consumer") > 0 or
            minetest.get_item_group(name, "conductor") > 0) and
           not already_processed[serialize_pos(pos)] then
            local meta = minetest.get_meta(pos)

            meta:set_float("I", 0)
            meta:set_float("U", 0)

            already_processed[serialize_pos(pos)] = true

            if minetest.get_item_group(name, "conductor") > 0 then
                reset_circuits(pos, already_processed)
            elseif consumer[name] then
                minetest.get_node_timer(pos):start(0.5)
            end
        end
    end
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

function check_current(meta, consumer)
    local I = meta:get_float("I")
    local U = meta:get_float("U")
    local is_active = meta:get_int("active") == 1

    return
        (I >= consumer.current.I.min) and
        (I <= consumer.current.I.max) and
        (U >= consumer.current.U.min) and
        (U <= consumer.current.U.max)
end

local function check_consumer(meta, consumer)
    local is_active = meta:get_int("active") == 1
    local is_current_normal = check_current(meta, consumer)

    return {
        activate = (not is_active) and is_current_normal and consumer.on_activate,
        deactivate = is_active and (not is_current_normal) and consumer.on_deactivate,
    }
end

local function calculate_circuits(resists, circuits, I, U)
    local P = 0
    local consumers = { }

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

            local name = minetest.get_node(pos).name

            local trans = quadripole[name]
            if trans then
                table.insert(transformations, trans(meta))
            end

            if consumer[name] then
                table.insert(consumers, pos)
            end
        end
    end

    return { P = P, consumers = consumers }
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

    return values.consumers
end

function globalstep(dtime)
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

    local consumers = { }
    for str, _ in pairs(sources) do
        local pos = deserialize_pos(str)
        for _, pos in ipairs(process_source(pos, circuits[str], dtime)) do
            table.insert(consumers, pos)
        end
    end

    for _, pos in ipairs(consumers) do
        local meta = minetest.get_meta(pos)

        local consumer = consumer[minetest.get_node(pos).name]
        local actions = check_consumer(meta, consumer)

        if actions.activate then
            consumer.on_activate(pos)
            meta:set_int("active", 1)
        elseif actions.deactivate then
            consumer.on_deactivate(pos)
            meta:set_int("active", 0)
        end
    end
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

local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer >= cable_tick then
        timer = 0
        globalstep(dtime)
    end
end)