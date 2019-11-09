local inf_emf = 220
minetest.register_node("electricity:infinite_electricity", {
    description = "Infinite electricity",
    tiles = {
        "default_test.png",
        "default_test.png",
        "default_test.png",
        "default_test.png",
        "electricity_minus.png",
        "electricity_plus.png",
    },
    paramtype2 = "facedir",
    drop = 'electricity:infinite_electricity',
    groups = { crumbly = 3, source = 1 },
    on_construct = set_resis(0.1),
    on_destruct = reset_current,
})
model["electricity:infinite_electricity"] = function(pos, id)
    local device_name = "v" .. id

    return two_pole(
        device_name, pos, string.format("DC SIN(0 %f 1Hz)", inf_emf)
    ), device_name
end

minetest.register_node("electricity:infinite_consumer", {
    description = "Infinite consumer",
    tiles = {
        "default_test.png^[colorize:#ff000050",
        "default_test.png^[colorize:#ff000050",
        "default_test.png^[colorize:#ff000050",
        "default_test.png^[colorize:#ff000050",
        "electricity_minus.png^[colorize:#ff000050",
        "electricity_plus.png^[colorize:#ff000050",
    },
    paramtype2 = "facedir",
    drop = 'electricity:infinite_consumer',
    groups = { crumbly = 3, conductor = 1, },

    on_construct = set_resis(5),
    on_destruct = reset_current,
})
model["electricity:infinite_consumer"] = resistor

minetest.register_node("electricity:heavy_infinite_consumer", {
    description = "Infinite consumer",
    tiles = {
        "default_test.png^[colorize:#00ff0050",
        "default_test.png^[colorize:#00ff0050",
        "default_test.png^[colorize:#00ff0050",
        "default_test.png^[colorize:#00ff0050",
        "electricity_minus.png^[colorize:#00ff0050",
        "electricity_plus.png^[colorize:#00ff0050",
    },
    paramtype2 = "facedir",
    drop = 'electricity:heavy_infinite_consumer',
    groups = { crumbly = 3, conductor = 1 },

    on_construct = set_resis(50),
    on_destruct = reset_current,
})
model["electricity:heavy_infinite_consumer"] = resistor