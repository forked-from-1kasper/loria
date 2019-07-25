for i, _ in ipairs(pars_names) do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = "default:copper_sulfate",
        sidelen = 16,
        fill_ratio = 0.1,
        biomes = "default:azure",
        decoration = "default:pars_" .. i,
        height = 1,
        y_min = -20,
    })
end

for i, _ in ipairs(petite_names) do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = "default:ammonium_manganese_pyrophosphate",
        sidelen = 16,
        fill_ratio = 0.05,
        biomes = "default:purple_swamp",
        decoration = "default:petite_" .. i,
        height = 1,
        y_min = -20,
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
        height_max = 4,
        y_min = -20,
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
        height_max = max_truncus_height,
        y_min = -20,
    })
end

for name, params in pairs(ores) do
    if params.azure then
        minetest.register_ore({
            ore_type       = "blob",
            ore            = "default:" .. name .. "_azure",
            wherein        = "default:cobalt_blue",
            clust_scarcity = 16 * 16 * 16,
            clust_num_ores = 5,
            clust_size     = 3,
            y_min          = params.y_min or -60,
            y_max          = params.y_max or 60,
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

    if params.cinnabar then
        minetest.register_ore({
            ore_type       = "blob",
            ore            = "default:" .. name .. "_cinnabar",
            wherein        = "default:cinnabar",
            clust_scarcity = 16 * 16 * 16,
            clust_num_ores = 5,
            clust_size     = 3,
            y_min          = params.y_min or -60,
            y_max          = params.y_max or 60,
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
end

minetest.register_decoration({
    deco_type = "simple",
    place_on = { "default:lead_sulfate" },
    sidelen = 16,
    fill_ratio = 0.01,
    biomes = "default:mercury_ocean",
    decoration = "default:viriditas",
    height = 1,
    y_min = -20,
})

minetest.register_ore({
    ore_type       = "blob",
    ore            = "default:cuprous_oxide",
    wherein        = "default:cobalt_blue",
    clust_scarcity = 16 * 16 * 16,
    clust_num_ores = 3,
    clust_size     = 3,
    y_min          = -200,
    y_max          = 10,
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