minetest.register_alias("mapgen_stone", "default:cinnabar")
minetest.register_alias("mapgen_dirt", "default:mercury_oxide")
minetest.register_alias("mapgen_dirt_with_grass", "default:red_mercury_oxide")
minetest.register_alias("mapgen_sand", "default:lead_sulfate")
minetest.register_alias("mapgen_water_source", "default:mercury_source")
minetest.register_alias("mapgen_river_water_source", "default:mercury_source")
minetest.register_alias("mapgen_lava_source", "default:mercury_source")
minetest.register_alias("mapgen_gravel", "default:uranyl_acetate")

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

for i = 1, pars_types do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = "default:copper_sulfate",
        sidelen = 16,
        fill_ratio = 0.1,
        biomes = "default:azure",
        decoration = "default:pars_" .. i,
        height = 1
    })
end

max_truncus_height = 9
for i = 1, truncus_types do
    for h = 1, max_truncus_height do
        minetest.register_decoration({
            deco_type = "simple",
            place_on = "default:copper_sulfate",
            sidelen = 16,
            fill_ratio = 0.0005 * max_truncus_height,
            biomes = "default:azure",
            decoration = "default:truncus_" .. i,
            height = h
        })
    end
end

minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:uranyl_acetate",
    wherein        = { "default:cobalt_blue", "default:cinnabar" },
    clust_scarcity = 8 * 8 * 8,
    clust_num_ores = 8,
    clust_size     = 3,
    y_min          = -30,
    y_max          = 45,
})