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
    name = "default:purple_swamp",
    node_top = "default:ammonium_manganese_pyrophosphate",
    depth_top = 30,
    node_stone = "air",

    y_min = -23,
    y_max = 31000,
    heat_point = 40,
    humidity_point = 50,
})

minetest.register_biome({
    name = "default:swamp_bottom",

    node_top = "default:potassium_permanganate_source",
    depth_top = 5,
    node_stone = "default:potassium_permanganate_source",

    y_min = -25,
    y_max = -23,
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

for i = 1, #pars_names do
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

for _, name in ipairs({ "pusilli", "caput", "quercu" }) do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = {
            "default:cinnabar",
            "default:red_mercury_oxide",
            "default:mercury_oxide"
        },
        sidelen = 16,
        fill_ratio = 0.01,
        biomes = "default:redland",
        decoration = "default:" .. name,
        height = 1
    })
end

for _, name in ipairs({ "rosea", "picea", "purpura" }) do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = "default:copper_sulfate",
        sidelen = 16,
        fill_ratio = 0.05,
        biomes = "default:azure",
        decoration = "default:" .. name,
        height = 1
    })
end

for _, name in ipairs({ "rami", "spears" }) do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = "default:ammonium_manganese_pyrophosphate",
        sidelen = 16,
        fill_ratio = 0.05,
        biomes = "default:purple_swamp",
        decoration = "default:" .. name,
        height = 1,
        height_max = 4
    })
end

for _, name in ipairs({ "periculum", "grebe", "secreta" }) do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = "default:ammonium_manganese_pyrophosphate",
        sidelen = 16,
        fill_ratio = 0.01,
        biomes = "default:purple_swamp",
        decoration = "default:" .. name,
        height = 1
    })
end

max_truncus_height = 7
for i = 1, #truncus_names do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = "default:copper_sulfate",
        sidelen = 16,
        fill_ratio = 0.05,
        biomes = "default:azure",
        decoration = "default:truncus_" .. i,
        height = 1,
        height_max = max_truncus_height
    })
end

for _, name in ipairs({ "uranyl_acetate", "plutonium_fluoride", "aluminium" }) do
    minetest.register_ore({
        ore_type       = "blob",
        ore            = "default:" .. name,
        wherein        = "default:cinnabar",
        clust_scarcity = 32 * 32 * 32,
        clust_num_ores = 10,
        clust_size     = 4,
        y_min          = -60,
        y_max          = 60,
        noise_threshold = 0.0,
        noise_params    = {
            offset = 0.5,
            scale = 0.2,
            spread = { x = 4, y = 4, z = 4 },
            seed = 17676,
            octaves = 1,
            persist = 0.0
        }
    })
end

minetest.register_decoration({
    deco_type = "simple",
    place_on = { "default:lead_sulfate" },
    sidelen = 16,
    fill_ratio = 0.01,
    biomes = "default:mercury_ocean",
    decoration = "default:viriditas",
    height = 1
})