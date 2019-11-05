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

for i, _ in ipairs(odorantur_names) do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = "default:sodium_peroxide",
        sidelen = 16,
        fill_ratio = 0.1,
        biomes = "default:acidic_landscapes",
        decoration = "default:odorantur_" .. i,
        height = 1,
        y_min = -20,
    })
end

for i, _ in ipairs(qui_lucem_names) do
    minetest.register_decoration({
        deco_type = "simple",
        place_on = "default:nickel_nitrate",
        sidelen = 16,
        fill_ratio = 0.05,
        biomes = "default:reptile_house",
        decoration = "default:qui_lucem_" .. i,
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

max_lectica_height = 5
minetest.register_decoration({
    deco_type = "simple",
    place_on = "default:sodium_peroxide",
    sidelen = 16,
    fill_ratio = 0.05,
    biomes = "default:acidic_landscapes",
    decoration = "default:lectica",
    height = 1,
    height_max = max_lectica_height,
    y_min = -20,
})

max_veteris_height = 8
minetest.register_decoration({
    deco_type = "simple",
    place_on = "default:sodium_peroxide",
    sidelen = 16,
    fill_ratio = 0.05,
    biomes = "default:acidic_landscapes",
    decoration = "default:veteris",
    height = 1,
    height_max = max_veteris_height,
    y_min = -20,
})

for name, params in pairs(ores) do
    for _, place in ipairs(params.wherein) do
        minetest.register_ore({
            ore_type       = "blob",
            ore            = "default:" .. name .. "_" .. place,
            wherein        = "default:" .. place,
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

minetest.register_decoration({
    deco_type = "simple",
    place_on = "default:sodium_peroxide",
    sidelen = 16,
    fill_ratio = 0.1,
    biomes = "default:acidic_landscapes",
    decoration = "default:imitationis",
    height = 1,
    y_min = -20,
})

minetest.register_decoration({
    deco_type = "simple",
    place_on = "default:sodium_peroxide",
    sidelen = 16,
    fill_ratio = 0.1,
    biomes = "default:acidic_landscapes",
    decoration = "default:nihil",
    height = 1,
    y_min = -20,
})
