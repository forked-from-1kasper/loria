minetest.register_alias("mapgen_stone", "default:cinnabar")
minetest.register_alias("mapgen_dirt", "default:mercury_oxide")
minetest.register_alias("mapgen_dirt_with_grass", "default:red_mercury_oxide")
minetest.register_alias("mapgen_sand", "default:lead_sulfate")
minetest.register_alias("mapgen_water_source", "default:mercury_source")
minetest.register_alias("mapgen_river_water_source", "default:mercury_source")
minetest.register_alias("mapgen_lava_source", "default:mercury_source")
minetest.register_alias("mapgen_gravel", "default:uranium_tetrachloride_cinnabar")

minetest.register_alias("mapgen_tree", "default:viridi_petasum_stem")
minetest.register_alias("mapgen_leaves", "default:viridi_petasum_body")
minetest.register_alias("mapgen_apple", "default:cinnabar")
minetest.register_alias("mapgen_junglegrass", "default:cinnabar")

minetest.register_alias("mapgen_cobble", "default:cinnabar")
minetest.register_alias("mapgen_stair_cobble", "default:cinnabar")
minetest.register_alias("mapgen_mossycobble", "default:cinnabar")

minetest.clear_registered_biomes()
minetest.clear_registered_decorations()

minetest.register_biome({
    name = "default:redland",
    node_top = "default:red_mercury_oxide",
    depth_top = 1,
    node_filler = "default:mercury_oxide",
    depth_filler = 1,
    y_min = 5,
    y_max = 31000,
    heat_point = 50,
    humidity_point = 50,
})

minetest.register_biome({
    name = "default:azure",
    node_top = "default:copper_sulfate",
    depth_top = 2,
    node_stone = "default:cobalt_blue",
    y_min = -31000,
    y_max = 31000,
    heat_point = 30,
    humidity_point = 50,
})

minetest.register_biome({
    name = "default:purple_swamp",
    node_stone = "default:ammonium_manganese_pyrophosphate",

    y_min = -15,
    y_max = 31000,
    heat_point = 40,
    humidity_point = 50,
})

minetest.register_biome({
    name = "default:swamp_connector",
    node_stone = "air",
    y_min = -20,
    y_max = -15,
    heat_point = 40,
    humidity_point = 50,
})

minetest.register_biome({
    name = "default:swamp_bottom",
    node_stone = "default:potassium_permanganate_source",
    y_min = -25,
    y_max = -20,
    heat_point = 40,
    humidity_point = 50,
})

minetest.register_biome({
    name = "default:mercury_ocean",
    node_top = "default:lead_sulfate",
    depth_top = 1,
    node_filler = "default:lead_sulfate",
    depth_filler = 2,
    y_min = -31000,
    y_max = 4,
    heat_point = 50,
    humidity_point = 50,
})