ores = {
    ["aluminium"] = {
        formula = "Al", has_ingot = true,
        wherein = { "cobalt_blue", "cinnabar", "chromia" },
    },
    ["potassium"] = {
        formula = "K", has_ingot = true,
        wherein = { "cobalt_blue", "cinnabar" },
    },
    ["zinc"] = {
        formula = "Zn", has_ingot = true,
        wherein = { "cobalt_blue", "cinnabar" },
    },
    ["calcium"] = {
        formula = "Ca", has_ingot = true,
        y_max = -700, y_min = -1200,
        wherein = { "chromium_fluoride" },
    },
    ["copper"] = {
        formula = "Cu", has_ingot = true,
        wherein = { "cobalt_blue", "cinnabar" },
    },
    ["wolfram"] = {
        formula = "W", has_ingot = true,
        y_max = -300, y_min = -1500,
        wherein = { "cobalt_blue", "cinnabar" },
    },
    ["magnesium"] = {
        formula = "Mg", has_ingot = true,
        y_max = -600, y_min = -900,
        wherein = { "cobalt_blue", "cinnabar", "chromia" },
    },
    ["molybdenum"] = {
        formula = "Mo", has_ingot = true,
        y_max = -500, y_min = -800,
        wherein = { "cobalt_blue", "cinnabar" },
    },
    ["cuprous_oxide"] = {
        formula = "Cu2O", has_ingot = false,
        wherein = { "cobalt_blue", "chromia" },
        y_min = -70, y_max = 0,
    },
    ["platinum"] = {
        formula = "Pt", has_ingot = true,
        wherein = { "cobalt_blue", "cinnabar" },
        y_min = -300, y_max = -150,
    },
    ["uranium_tetrachloride"] = { -- 234
        formula = "UCl4", has_ingot = false,
        wherein = { "cobalt_blue", "cinnabar", "chromium_fluoride", "chromia" },
        radioactive = true,
    },
    ["thorium_iodide"] = { -- 232
        formula = "ThI4", has_ingot = false,
        wherein = { "cobalt_blue", "cinnabar", "chromium_fluoride", "chromia" },
        radioactive = true,
    },
    ["plutonium_trifluoride"] = { -- 238
        formula = "PuF3", has_ingot = false,
        wherein = { "cobalt_blue", "cinnabar", "chromium_fluoride" },
        radioactive = true,
    },
    ["americium_trifluoride"] = { -- 243
        formula = "AmF3", has_ingot = false,
        y_min = -243, light_source = 10,
        wherein = { "cobalt_blue", "cinnabar", "chromium_fluoride" },
        radioactive = true,
    },
    ["magnetite"] = {
        formula = "FeO * Fe2O3", has_ingot = false,
        y_max = -200, y_min = -500,
        wherein = { "cobalt_blue", "cinnabar", "chromium_fluoride" },
    },
}

pressable = {
    "rami", "spears", "veteris", "lectica",
    "truncus_1", "truncus_2", "truncus_3"
}

giant_mushrooms = { "viridi_petasum", "colossus", "turris", "rete" }

cables = {
    { name = "copper", resis = 0.0225 },
    { name = "aluminium", resis = 0.036 },
    { name = "wolfram", resis = 0.055 },
    { name = "platinum", resis = 0.098 },
    { name = "calcium", resis = 0.046 },
    { name = "uranium", resis = 0.295 },
    { name = "thorium", resis = 0.1862 },
    { name = "plutonium", resis = 150 },
}

brickable = {
    ["default:cinnabar"] = { crumbly = true },
    ["default:plutonium_dioxide"] = { crumbly = false },
    ["default:uranium_tetrachloride"] = { crumbly = true },
    ["default:ammonium_manganese_pyrophosphate"] = { crumbly = true },
    ["default:mercury_oxide"] = { crumbly = true },
    ["default:red_mercury_oxide"] = { crumbly = true },
    ["default:lead_sulfate"] = { crumbly = true },
}

inv_crafts = {
    {
        input = {
            { name = "default:lead", count = 1 },
            { name = "default:copper_sulfate", count = 1 }
        },
        output = {
            { name = "default:copper", count = 1 },
            { name = "default:lead_sulfate", count = 1 },
        }
    },
    {
        input = {
            { name = "default:purpura", count = 15 },
            { name = "default:bucket_empty", count = 1 },
        },
        output = {
            { name = "default:bucket_lucidum", count = 1 }
        }
    },
    {
        input = {
            { name = "default:naga", count = 20 },
            { name = "default:bucket_empty", count = 1 },
        },
        output = {
            { name = "default:bucket_lucidum", count = 1 }
        }
    },
    {
        input = {
            { name = "default:potassium_ingot", count = 2 },
            { name = "default:bucket_water", count = 2 },
            { name = "default:empty_balloon", count = 1 }
        },
        output = {
            { name = "default:bucket_potassium_hydroxide", count = 2 },
            { name = "default:hydrogen_balloon", count = 2 },
        }
    },
    {
        input = {
            { name = "default:broken_drill", count = 1 },
            { name = "default:battery", count = 1 }
        },
        output = {
            { name = "default:drill", count = 1 }
        }
    },
    {
        input = {
            { name = "electricity:aluminium_cable", count = 10 },
            { name = "default:lead_case", count = 1 }
        },
        output = {
            { name = "electricity:battery_box", count = 1 }
        }
    },
    {
        input = {
            { name = "default:uranium_tetrachloride", count = 1 },
            { name = "default:potassium_ingot", count = 1 },
        },
        output = {
            { name = "default:uranium", count = 1 },
            { name = "default:potassium_chloride", count = 4 },
        }
    },
    {
        input = {
            { name = "default:lead", count = 4 },
        },
        output = {
            { name = "default:lead_case", count = 1 },
        }
    },
    {
        input = {
            { name = "default:lead", count = 3 },
        },
        output = {
            { name = "furnace:gas", count = 1 },
        }
    },
    {
        input = {
            { name = "default:lead_case", count = 1 },
            { name = "default:lead", count = 1 }
        },
        output = {
            { name = "default:lead_box", count = 1 },
        }
    },
    {
        input = {
            { name = "default:silicon", count = 3 },
        },
        output = {
            { name = "default:silicon_box", count = 1 },
        }
    },
    {
        input = {
            { name = "default:stick", count = 1 },
            { name = "default:copper_hammer_head", count = 1 },
        },
        output = {
            { name = "default:copper_hammer", count = 1 },
        }
    },
    {
        input = {
            { name = "default:zinc_ingot", count = 1 },
            { name = "default:bucket_hydrochloric_acid", count = 2 },
            { name = "default:empty_balloon", count = 1 },
        },
        output = {
            { name = "default:zinc_chloride", count = 1 },
            { name = "default:bucket_empty", count = 2 },
            { name = "default:hydrogen_balloon", count = 1 },
        }
    },
    {
        input = {
            { name = "default:aluminium_ingot", count = 1 },
            { name = "default:bucket_hydrochloric_acid", count = 3 },
            { name = "default:empty_balloon", count = 1 },
        },
        output = {
            { name = "default:aluminium_chloride", count = 1 },
            { name = "default:bucket_empty", count = 3 },
            { name = "default:hydrogen_balloon", count = 1 },
        }
    },
    {
        input = {
            { name = "default:potassium_ingot", count = 2 },
            { name = "default:bucket_hydrochloric_acid", count = 2 },
            { name = "default:empty_balloon", count = 1 },
        },
        output = {
            { name = "default:potassium_chloride", count = 2 },
            { name = "default:bucket_empty", count = 2 },
            { name = "default:hydrogen_balloon", count = 1 },
        }
    },
    {
        input = {
            { name = "default:lead_case", count = 1 },
            { name = "default:wolfram_filament", count = 1 },
            { name = "default:fused_quartz", count = 1 },
            { name = "electricity:aluminium_cable", count = 1 },
        },
        output = {
            { name = "electricity:lamp_off", count = 1 },
        }
    },
}

small_mushrooms = {
    ["pusilli"] = {
        damage = 5,
        place_on = {
            "default:cinnabar",
            "default:red_mercury_oxide",
            "default:mercury_oxide"
        },
        optimal_light = 11,
        fill_ratio = 0.01,
        biomes = "default:redland",
        optimal_radiation = 5,
        max_radiation = 10,
    },
    ["rosea"] = {
        damage = 4,
        place_on = "default:copper_sulfate",
        fill_ratio = 0.05,
        biomes = "default:azure",
    },
    ["purpura"] = {
        features = { light_source = 5 },
        place_on = "default:copper_sulfate",
        fill_ratio = 0.05,
        biomes = "default:azure",
    },
    ["picea"] = {
        damage = 9,
        place_on = "default:copper_sulfate",
        fill_ratio = 0.05,
        biomes = "default:azure",
    },
    ["caput"] = {
        damage = 15,
        place_on = {
            "default:cinnabar",
            "default:red_mercury_oxide",
            "default:mercury_oxide"
        },
        optimal_light = 11,
        fill_ratio = 0.01,
        biomes = "default:redland",
        optimal_radiation = 5,
        max_radiation = 10,
    },
    ["periculum"] = {
        features = { light_source = 3 },
        damage = 18,
        place_on = "default:ammonium_manganese_pyrophosphate",
        fill_ratio = 0.01,
        biomes = "default:purple_swamp",
    },
    ["vastatorem"] = {
        features = { light_source = 8 },
        place_on = "default:nickel_nitrate",
        fill_ratio = 0.005,
        biomes = "default:reptile_house",
    },
    ["quercu"] = {
        damage = 7,
        place_on = {
            "default:cinnabar",
            "default:red_mercury_oxide",
            "default:mercury_oxide"
        },
        optimal_light = 11,
        biomes = "default:redland",
    },
    ["grebe"] = {
        damage = 11,
        place_on = "default:ammonium_manganese_pyrophosphate",
        fill_ratio = 0.01,
        biomes = "default:purple_swamp",
    },
    ["secreta"] = {
        damage = 12,
        place_on = "default:ammonium_manganese_pyrophosphate",
        fill_ratio = 0.01,
        biomes = "default:purple_swamp",
    },
    ["pulchram"] = { damage = 3 },
    ["conc"] = {
        damage = 16,
        place_on = "default:sodium_peroxide",
        fill_ratio = 0.01,
        biomes = "default:acidic_landscapes",
    }
}

for name, params in pairs(small_mushrooms) do
    table.insert(inv_crafts, {
        input = {
            { name = "default:" .. name, count = 20 },
        },
        output = {
            { name = "default:mushroom_mass", count = 1 },
        }
    })
end

for _, conf in ipairs(cables) do
    table.insert(inv_crafts, {
        input = {
            { name = "default:" .. conf.name .. "_ingot", count = 1 },
        },
        output = {
            { name = "electricity:" .. conf.name .. "_cable", count = 15 }
        }
    })
end

for _, mushroom in ipairs(giant_mushrooms) do
    table.insert(inv_crafts, {
        input = {
            { name = "default:" .. mushroom .. "_stem", count = 1 }
        },
        output = {
            { name = "default:stick", count = 6 }
        },
    })
end

for _, grass in ipairs(pressable) do
    table.insert(inv_crafts, {
        input = {
            { name = "default:" .. grass, count = 20 }
        },
        output = {
            { name = "default:" .. grass .. "_pressed", count = 1 }
        },
    })
end
