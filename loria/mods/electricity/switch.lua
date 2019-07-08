switch_box = {
    type = "fixed",
    fixed = { -1/2, -1/2, -1/2, 1/2, -1/2+3/16, 1/2 },
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
    paramtype2 = "facedir",

    drawtype = "nodebox",
    node_box = switch_box,
    selection_box = switch_box,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        meta:set_float("resis", 0.05)

        swap_node(pos, "electricity:switch_on")
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
    paramtype2 = "facedir",

    drawtype = "nodebox",
    node_box = switch_box,
    selection_box = switch_box,

    on_destruct = reset_current,
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        meta:set_float("I", 0)
        meta:set_float("U", 0)
        reset_current(pos)

        swap_node(pos, "electricity:switch_off")
    end,
})
model["electricity:switch_on"] = resistor