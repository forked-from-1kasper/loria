local multimeter_resis = 0.04

local multimeter_box = {
    type = "fixed",
    fixed = {
        { -1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2 },
        { -4/16, -1/2+1/16, -1/2+2/16, 4/16, 1/2-2/16, 1/2-2/16 },
    },
}

minetest.register_node("electricity:multimeter", {
    description = "Multimeter",
    tiles = {
        "electricity_multimeter_top.png",
        "electricity_multimeter_bottom.png",
        "electricity_multimeter_front.png",
        "electricity_multimeter_back.png",
        "electricity_multimeter_side.png",
        "electricity_multimeter_side.png",
    },
    paramtype = "light",
    paramtype2 = "facedir",

    drop = 'electricity:multimeter',
    groups = { dig_immediate = 3, conductor = 1, },

    on_construct = set_resis(multimeter_resis),
    on_destruct = reset_current,

    drawtype = "nodebox",
    node_box = multimeter_box,
    selection_box = multimeter_box,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        local I, U = meta:get_float("I"), meta:get_float("U")

        minetest.chat_send_player(clicker:get_player_name(),
            string.format("I = %f, U = %f", I, U)
        )
    end,
})
model["electricity:multimeter"] = resistor