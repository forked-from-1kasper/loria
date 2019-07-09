function hash_node_pos(pos)
    return string.format("%d#%d#%d", pos.x, pos.y, pos.z)
end

function hash_node_connect(pos1, pos2)
    if pos2.x < pos1.x or pos2.y < pos1.y or pos2.z < pos1.z then
        pos1, pos2 = pos2, pos1
    end

    return string.format("%s&%s", hash_node_pos(pos1), hash_node_pos(pos2))
end

function two_pole(device, pos, value)
    local dir = minetest.facedir_to_dir(minetest.get_node(pos).param2)

    local input = hash_node_connect(pos, vector.subtract(pos, dir))
    local output = hash_node_connect(pos, vector.add(pos, dir))

    return {
        table.concat({ device, input, "hole-" .. device, value }, " "),
        table.concat({ "v" .. device, "hole-" .. device, output, 0 }, " "),
        string.format(
            ".measure tran %s-u RMS v(%s)", device, input
        ),
        string.format(
            ".measure tran %s-delta RMS v(%s)", device, output
        ),
        string.format(
            ".measure tran %s-i MAX I(v%s)", device, device
        ),
    }
end

function resistor(pos, id)
    local meta = minetest.get_meta(pos)
    local device_name = "r" .. id

    return two_pole(device_name, pos, meta:get_float("resis")), device_name
end

function dc_source(pos, id)
    local meta = minetest.get_meta(pos)

    local emf = meta:get_float("emf")
    local resis = meta:get_float("resis")

    local dir = minetest.facedir_to_dir(minetest.get_node(pos).param2)

    local input = hash_node_connect(pos, vector.subtract(pos, dir))
    local output = hash_node_connect(pos, vector.add(pos, dir))

    return {
        table.concat({ "v" .. id, input, "hole-" .. id, emf }, " "),
        table.concat({ "r" .. id, "hole-" .. id, output, resis }, " "),
        string.format(
            ".measure tran v%s-u RMS v(%s)", id, input
        ),
        string.format(
            ".measure tran v%s-delta RMS v(%s)", id, output
        ),
        string.format(
            ".measure tran v%s-i MAX I(v%s)", id, id
        ),
    }, "v" .. id
end