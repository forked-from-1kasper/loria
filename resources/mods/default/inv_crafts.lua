function on_grasses(func)
    for grass, params in pairs(grasses) do
        if params.variants then
            for id, var in ipairs(params.variants) do
                func(
                    grass .. "_" .. id,
                    grass .. " " .. var,
                    params
                )
            end
        else
            func(grass, grass, params)
        end
    end
end

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

for name, params in opairs(small_mushrooms) do
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

for grass, params in opairs(grasses) do
    if params.variants then
        for id, _ in ipairs(params.variants) do
            table.insert(inv_crafts, {
                input = { { name = "default:" .. grass .. "_" .. id, count = 20 } },
                output = { {
                    name = "default:" .. grass .. "_" .. id .. "_pressed",
                    count = 1
                } },
            })
        end
    else
        table.insert(inv_crafts, {
            input = { { name = "default:" .. grass, count = 20 } },
            output = { { name = "default:" .. grass .. "_pressed", count = 1 } },
        })
    end
end
