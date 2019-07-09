function serialize_pos(pos)
    return string.format("%f,%f,%f", pos.x, pos.y, pos.z)
end

function deserialize_pos(str)
    local x, y, z = str:match("([^,]+),([^,]+),([^,]+)")
    return vector.new(tonumber(x), tonumber(y), tonumber(z))
end

local function drop_current(pos)
    local meta = minetest.get_meta(pos)
    meta:set_float("I", 0)
    meta:set_float("U", 0)
end

function reset_circuits(current, already_processed)
    for _, vect in ipairs(neighbors) do
        local pos = vector.add(current, vect)
        local name = minetest.get_node(pos).name

        if (minetest.get_item_group(name, "conductor") > 0 or
            minetest.get_item_group(name, "cable") > 0) and
           not already_processed[serialize_pos(pos)] then
            local meta = minetest.get_meta(pos)

            meta:set_float("I", 0)
            meta:set_float("U", 0)

            already_processed[serialize_pos(pos)] = true

            if consumer[name] then
                minetest.get_node_timer(pos):start(0.5)
            end
            reset_circuits(pos, already_processed)
        end
    end
end

local function measurement_delta(X)
    if X == 0 then
        return 0
    else
        return X + math.random() / 2
    end
end

function check_current(meta, consumer)
    local I = math.abs(meta:get_float("I"))
    local U = math.abs(meta:get_float("U"))
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

local function get_emf(pos)
    return minetest.get_meta(pos):get_float("emf")
end

local function get_resis(pos)
    return minetest.get_meta(pos):get_float("resis")
end

local idx = 0
local function get_name()
    idx = idx + 1
    return idx
end

local function is_conductor(name)
    return minetest.get_item_group(name, "conductor") ~= 0
end

local function is_source(name)
    return minetest.get_item_group(name, "source") ~= 0
end

function find_circuits(pos, descriptions, processed_sources)
    local res = { }
    local queue = { pos }

    for _, current in ipairs(queue) do
        for _, vect in ipairs(neighbors) do
            local pos = vector.add(current, vect)
            local name = minetest.get_node(pos).name
            local str = serialize_pos(pos)

            if (not descriptions[str]) and (not processed_sources[str]) and
               (is_conductor(name) or is_source(name)) then
                local desc, device_name = model[name](pos, get_name())
                descriptions[str] = desc
                if device_name then
                    device_info[device_name] = { pos = pos }
                end

                if is_source(name) then
                    processed_sources[str] = true
                end

                if consumer[name] then
                    minetest.get_node_timer(pos):start(0.5)
                end

                drop_current(pos)
                table.insert(queue, pos)
            end
        end
    end
end

local function calculate_device(device, info, elapsed)
    local meta = minetest.get_meta(info.pos)

    local U = (info.u or 0) + (info.delta or 0)
    local I = info.i or 0

    meta:set_float("I", I)
    meta:set_float("U", U)

    local name = minetest.get_node(info.pos).name

    local consumer = consumer[name]
    if consumer then
        local actions = check_consumer(meta, consumer)
        if actions.activate then
            consumer.on_activate(info.pos)
            meta:set_int("active", 1)
        elseif actions.deactivate then
            consumer.on_deactivate(info.pos)
            meta:set_int("active", 0)
        end
    end

    local source = source[name]
    if source then
        source(meta, elapsed)
    end
end

local function process_source(pos, processed_sources, elapsed)
    local descriptions = { }
    local str = serialize_pos(pos)

    local desc, device_name = model[minetest.get_node(pos).name](pos, get_name())
    descriptions[str] = desc
    device_info[device_name] = { pos = pos }
    drop_current(pos)

    processed_sources[str] = true

    find_circuits(pos, descriptions, processed_sources)

    local circ = { ".title electricity" }
    for _, lines in pairs(descriptions) do
        append(circ, lines)
    end
    table.insert(circ, ".end")

    ngspice_circ(circ)
    ngspice_command("tran 1 1")

    for device, info in pairs(device_info) do
        calculate_device(device, info, elapsed)
    end

    ngspice_command("destroy all")
    ngspice_command("remcirc")

    device_info = { }
end

local function globalstep(dtime)
    local processed_sources = { }
    for str, time in pairs(sources) do
        if dtime >= time then
            sources[str] = nil
        else
            sources[str] = time - dtime

            if not processed_sources[str] then
                local pos = deserialize_pos(str)
                process_source(pos, processed_sources, dtime)
            end
        end
    end
    idx = 0
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
    if timer >= 0.5 then
        globalstep(timer)
        timer = 0
    end
end)