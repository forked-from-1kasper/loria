switch_box = {
    type = "fixed",
    fixed = { -1/2, -1/2, -1/2, 1/2, -1/2+4/16, 1/2 },
}

local ground_connect_resis = 0.1
minetest.register_node("electricity:ground", {
    description = "Ground",
    tiles = {
        "electricity_ground_top.png",
        "electricity_ground_bottom.png",
        "electricity_ground_side.png",
        "electricity_ground_side.png",
        "electricity_ground_side.png",
        "electricity_ground_connect_side.png",
    },

    drop = 'electricity:ground',
    groups = { crumbly = 3, conductor = 1 },

    paramtype = "light",
    paramtype2 = "facedir",

    drawtype = "nodebox",
    node_box = switch_box,
    selection_box = switch_box,

    on_destruct = reset_current,
})
model["electricity:ground"] = function(pos, id)
    local dir = minetest.facedir_to_dir(minetest.get_node(pos).param2)
    return { table.concat({
        "r" .. id,
        hash_node_connect(pos, vector.subtract(pos, dir)),
        "gnd", ground_connect_resis
    }, " ") }, nil
end