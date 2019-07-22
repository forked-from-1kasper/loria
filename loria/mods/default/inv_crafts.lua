ores = {
    ["aluminium"] = { formula = "Al", has_ingot = true },
    ["potassium"] = { formula = "K", has_ingot = true },
    ["zinc"] = { formula = "Zn", has_ingot = true },
    ["copper"] = { formula = "Cu", has_ingot = true },
    ["uranium_tetrachloride"] = { formula = "UCl4", has_ingot = false },
    ["plutonium_trifluoride"] = { formula = "PuF3", has_ingot = false },
}

giant_mushrooms = { "viridi_petasum", "colossus", "turris", "rete" }

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
            { name = "default:lead_case", count = 1 },
            { name = "default:lead", count = 3 }
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
            { name = "default:stick", count = 1 },
            { name = "default:copper_hammer_head", count = 1 },
        },
        output = {
            { name = "default:copper_hammer", count = 1 },
        }
    },
}

table.insert(inv_crafts, {
    input = {
        { name = "default:aluminium_ingot", count = 1 },
    },
    output = {
        { name = "electricity:aluminium_cable", count = 15 }
    }
})

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

for name, params in pairs(brickable) do
    if params.crumbly then
        table.insert(inv_crafts, {
            input = {
                { name = "default:aluminium_brick_mold", count = 5 },
                { name = "default:copper_hammer", count = 1 },
                { name = name, count = 1 },
            },
            output = {
                { name = "default:aluminium_brick_mold", count = 5 },
                { name = "default:copper_hammer", count = 1 },
                { name = name .. "_brick", count = 1 },
            }
        })
    end
end