for i, _ in ipairs(pars_names) do
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

max_truncus_height = 7
for i, _ in ipairs(truncus_names) do
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

for _, name in ipairs(ores) do
    minetest.register_ore({
        ore_type       = "blob",
        ore            = "default:" .. name .. "_azure",
        wherein        = "default:cobalt_blue",
        clust_scarcity = 16 * 16 * 16,
        clust_num_ores = 5,
        clust_size     = 3,
        y_min          = -60,
        y_max          = 60,
        noise_threshold = 0.0,
        noise_params    = {
            offset = 0.5,
            scale = 0.2,
            spread = { x = 3, y = 3, z = 3 },
            seed = 17676,
            octaves = 1,
            persist = 0.0
        }
    })

    minetest.register_ore({
        ore_type       = "blob",
        ore            = "default:" .. name,
        wherein        = "default:cinnabar",
        clust_scarcity = 16 * 16 * 16,
        clust_num_ores = 5,
        clust_size     = 3,
        y_min          = -60,
        y_max          = 60,
        noise_threshold = 0.0,
        noise_params    = {
            offset = 0.5,
            scale = 0.2,
            spread = { x = 3, y = 3, z = 3 },
            seed = 17676,
            octaves = 1,
            persist = 0.0
        }
    })
end

for _, name in ipairs({ "uranium_tetrachloride_ore", "plutonium_fluoride" }) do
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

minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:trisilane_cinnabar",
    wherein        = "default:cinnabar",
    clust_scarcity = 8 * 8 * 8,
    clust_num_ores = 8,
    clust_size     = 3,
    y_min     = -10,
    y_max     = 80,
})

minetest.register_ore({
    ore_type       = "scatter",
    ore            = "default:trisilane_cobalt_blue",
    wherein        = "default:cobalt_blue",
    clust_scarcity = 8 * 8 * 8,
    clust_num_ores = 8,
    clust_size     = 3,
    y_min     = -10,
    y_max     = 80,
})

minetest.register_decoration({
    deco_type = "simple",
    place_on = { "default:lead_sulfate" },
    sidelen = 16,
    fill_ratio = 0.01,
    biomes = "default:mercury_ocean",
    decoration = "default:viriditas",
    height = 1
})