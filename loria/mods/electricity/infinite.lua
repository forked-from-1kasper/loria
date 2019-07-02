minetest.register_node("electricity:infinite_electricity", {
    description = "Infinite electricity",
    tiles = { "default_test.png" },
    drop = 'electricity:infinite_electricity',
    groups = { crumbly = 3, source = 1 },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)

        meta:set_float("resis", 0.5)
        meta:set_float("emf", 230)
    end,
})
source["electricity:infinite_electricity"] = function(meta, P, R, emf, elapsed)
    meta:set_string("formspec", string.format(
        "size[2,1.5]" ..
        "label[0,0;Infinite electricity]" ..
        "label[0,0.5;P = %f]" ..
        "label[0,1;ε = %f]",
        P, emf
    ))
    return 230
end

minetest.register_node("electricity:infinite_consumer", {
    description = "Infinite consumer",
    tiles = { "default_test.png^[colorize:#ff000050" },
    drop = 'electricity:infinite_consumer',
    groups = { crumbly = 3, consumer = 1, },

    on_construct = run_timer(5),
    on_timer = reset_current,
})

minetest.register_node("electricity:heavy_infinite_consumer", {
    description = "Infinite consumer",
    tiles = { "default_test.png^[colorize:#00ff0050" },
    drop = 'electricity:heavy_infinite_consumer',
    groups = { crumbly = 3, consumer = 1 },

    on_construct = run_timer(50),
    on_timer = reset_current,
})