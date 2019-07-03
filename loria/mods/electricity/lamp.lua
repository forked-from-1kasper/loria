minetest.register_node("electricity:lamp_off", {
    description = "Lamp",
    tiles = { "electricity_lamp.png" },
    drop = 'electricity:lamp_off',
    groups = { cracky = 3, consumer = 1 },

    on_construct = set_resis(10),
    on_destruct = reset_current,
})

minetest.register_node("electricity:lamp_on", {
    description = "Lamp (active)",
    tiles = { "electricity_lamp.png" },
    drop = 'electricity:lamp_off',
    groups = { cracky = 3, consumer = 1 },
    light_source = 14,

    on_destruct = reset_current,
    on_timer = reset_consumer("electricity:lamp_on"),
})

current = {
    I = { min = 0.5, max = 5 },
    U = { min = 4, max = 15 },
}

consumer["electricity:lamp_off"] = {
    on_activate = function(pos)
        minetest.swap_node(pos, { name = "electricity:lamp_on" })
    end,
    current = current,
}

consumer["electricity:lamp_on"] = {
    on_deactivate = function(pos)
        minetest.swap_node(pos, { name = "electricity:lamp_off" })
    end,
    current = current,
}