minetest.register_node("electricity:lamp_off", {
    description = "Lamp",
    tiles = {
        "electricity_lamp.png",
        "electricity_lamp.png",
        "electricity_lamp.png",
        "electricity_lamp.png",
        "electricity_lamp_connect_side.png",
        "electricity_lamp_connect_side.png",
    },
    drop = 'electricity:lamp_off',
    groups = { cracky = 3, conductor = 1 },
    paramtype2 = "facedir",

    on_construct = set_resis(10),
    on_destruct = reset_current,
})

minetest.register_node("electricity:lamp_on", {
    description = "Lamp (active)",
    tiles = {
        "electricity_lamp.png",
        "electricity_lamp.png",
        "electricity_lamp.png",
        "electricity_lamp.png",
        "electricity_lamp_connect_side.png",
        "electricity_lamp_connect_side.png",
    },
    drop = 'electricity:lamp_off',
    groups = { cracky = 3, conductor = 1 },
    paramtype2 = "facedir",
    light_source = 14,

    on_destruct = reset_current,
    on_timer = reset_consumer("electricity:lamp_on"),
})

current = {
    I = { min = 1, max = 50 },
    U = { min = 5, max = 500 },
}

consumer["electricity:lamp_off"] = {
    on_activate = function(pos)
        swap_node(pos, "electricity:lamp_on")
    end,
    current = current,
}

consumer["electricity:lamp_on"] = {
    on_deactivate = function(pos)
        swap_node(pos, "electricity:lamp_off")
    end,
    current = current,
}

model["electricity:lamp_off"] = resistor
model["electricity:lamp_on"] = resistor