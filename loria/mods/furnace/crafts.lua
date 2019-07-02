furnace_crafts = {
    {
        input = {
            { name = "default:mercury_oxide", count = 2 },
            { name = "default:empty_balloon", count = 1 },
            { name = "default:bucket_empty", count = 2 }
        },
        output = {
            { name = "default:oxygen_balloon", count = 1 },
            { name = "default:bucket_mercury", count = 2 }
        },
        time = 3
    },
    {
        input = {
            { name = "default:red_mercury_oxide", count = 2 },
            { name = "default:empty_balloon", count = 1 },
            { name = "default:bucket_empty", count = 2 }
        },
        output = {
            { name = "default:oxygen_balloon", count = 1 },
            { name = "default:bucket_mercury", count = 2 }
        },
        time = 3
    },
    {
        input = {
            { name = "default:copper_sulfate", count = 1 },
            { name = "default:bucket_empty", count = 5 }
        },
        output = {
            { name = "default:copper_sulfate_pure", count = 1 },
            { name = "default:bucket_water", count = 5 }
        },
        time = 5
    },
    {
        input = {
            { name = "default:aluminium", count = 1 }
        },
        output = {
            { name = "default:aluminium_ingot", count = 1 },
            { name = "default:cinnabar", count = 1 }
        },
        time = 3
    },
    {
        input = {
            { name = "default:aluminium_azure", count = 1 }
        },
        output = {
            { name = "default:aluminium_ingot", count = 1 },
            { name = "default:cobalt_blue", count = 1 }
        },
        time = 3
    },
    {
        input = {
            { name = "default:aluminium_ingot", count = 5 }
        },
        output = {
            { name = "default:bucket_empty", count = 1 }
        },
        time = 8
    },
    {
        input = {
            { name = "default:zinc_ingot", count = 4 }
        },
        output = {
            { name = "default:bucket_empty", count = 1 }
        },
        time = 10
    },
    {
        input = {
            { name = "default:aluminium_ingot", count = 3 }
        },
        output = {
            { name = "default:empty_balloon", count = 1 }
        },
        time = 3
    },
    {
        input = {
            { name = "default:aluminium_ingot", count = 1 }
        },
        output = {
            { name = "default:aluminium_case", count = 1 }
        },
        time = 3
    },
    {
        input = {
            { name = "default:mercury_oxide", count = 1 },
            { name = "default:bucket_potassium_hydroxide", count = 1 },
            { name = "default:zinc_ingot", count = 1 },
            { name = "default:aluminium_case", count = 1 }
        },
        output = {
            { name = "default:battery", count = 1 },
            { name = "default:bucket_empty", count = 1 }
        },
        time = 2,
    },
    {
        input = {
            { name = "default:red_mercury_oxide", count = 1 },
            { name = "default:bucket_potassium_hydroxide", count = 1 },
            { name = "default:zinc_ingot", count = 1 },
            { name = "default:aluminium_case", count = 1 }
        },
        output = {
            { name = "default:battery", count = 1 },
            { name = "default:bucket_empty", count = 1 }
        },
        time = 2,
    },
    {
        input = {
            { name = "default:bucket_empty", count = 1 },
            { name = "default:mercury", count = 1 }
        },
        output = {
            { name = "default:bucket_mercury" }
        },
        time = 5,
    },
    {
        input = {
            { name = "default:silicon_dioxide", count = 9 }
        },
        output = {
            { name = "default:fused_quartz" }
        },
        time = 3,
    },
    {
        input = {
            { name = "default:uranium_tetrachloride_ore", count = 1 }
        },
        output = {
            { name = "default:uranium_tetrachloride", count = 1 },
            { name = "default:cinnabar", count = 1 },
        },
        time = 5,
    },
    {
        input = {
            { name = "default:plutonium_fluoride_ore", count = 1 }
        },
        output = {
            { name = "default:plutonium_trifluoride", count = 1 },
            { name = "default:cinnabar", count = 1 },
        },
        time = 6,
    },
    {
        input = {
            { name = "default:plutonium_trifluoride", count = 4 },
            { name = "default:oxygen_balloon", count = 1 },
        },
        output = {
            { name = "default:plutonium_tetrafluoride", count = 3 },
            { name = "default:plutonium_dioxide", count = 1 },
        },
        time = 3,
    },
    {
        input = {
            { name = "default:lead_sulfate", count = 1 },
            { name = "default:bucket_empty", count = 1 }
        },
        output = {
            { name = "default:lead_oxide", count = 1 },
            { name = "default:bucket_sulfur_trioxide", count = 1 }
        },
        time = 4,
    },
    {
        input = {
            { name = "default:lead_oxide", count = 1 },
            { name = "default:hydrogen_balloon", count = 1 },
            { name = "default:bucket_empty", count = 1 }
        },
        output = {
            { name = "default:lead", count = 1 },
            { name = "default:empty_balloon", count = 1 },
            { name = "default:bucket_water", count = 1 }
        },
        time = 2,
    },
    {
        input = {
            { name = "default:bucket_potassium_permanganate", count = 2 },
            { name = "default:empty_balloon", count = 1 },
        },
        output = {
            { name = "default:potassium_manganate", count = 1 },
            { name = "default:manganese_dioxide", count = 1 },
            { name = "default:oxygen_balloon", count = 1 },
        },
        time = 2,
    },
    {
        input = {
            { name = "default:manganese_dioxide", count = 1 },
            { name = "default:bucket_empty", count = 1 },
            { name = "default:hydrogen_balloon", count = 1 },
        },
        output = {
            { name = "default:manganese_oxide", count = 1 },
            { name = "default:bucket_water", count = 1 },
            { name = "default:empty_balloon", count = 1 },
        },
        time = 3,
    },
}

for _, name in ipairs(ores) do
    table.insert(furnace_crafts, {
        input = {
            { name = "default:" .. name, count = 1 }
        },
        output = {
            { name = "default:" .. name .. "_ingot", count = 1 },
            { name = "default:cinnabar", count = 1 }
        },
        time = 3
    })
    table.insert(furnace_crafts, {
        input = {
            { name = "default:" .. name .. "_azure", count = 1 }
        },
        output = {
            { name = "default:" .. name .. "_ingot", count = 1 },
            { name = "default:cobalt_blue", count = 1 }
        },
        time = 3
    })
end

for _, mushroom in ipairs(giant_mushrooms) do
    table.insert(furnace_crafts, {
        input = {
            { name = "default:" .. mushroom .. "_body", count = 3 }
        },
        output = {
            { name = "default:silicon_dioxide" }
        },
        time = 5
    })

    table.insert(furnace_crafts, {
        input = {
            { name = "default:" .. mushroom .. "_stem", count = 5 }
        },
        output = {
            { name = "default:silicon_dioxide" }
        },
        time = 8
    })
end