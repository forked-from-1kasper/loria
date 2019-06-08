minetest.register_node("default:test", {
    description = "For tests only",
    tiles = { "default_test.png" },
    drop = 'default:test',
    groups = { crumbly = 3 }
})

minetest.register_node("default:ammonium_manganese_pyrophosphate", {
    description = "Ammonium manganese (III) pyrophosphate",
    tiles = { "default_ammonium_manganese_pyrophosphate.png" },
    groups = { crumbly = 3 },
    drop = 'default:ammonium_manganese_pyrophosphate'
})

minetest.register_node("default:cinnabar", {
    description = "Cinnabar (HgS)",
    tiles = { "default_cinnabar.png" },
    groups = { cracky = 1 },
    drop = 'default:cinnabar'
})

minetest.register_node("default:copper_sulfate_pure", {
    description = "Copper (II) sulfate (CuSO₄)",
    tiles = { "default_copper_sulfate_pure.png" },
    groups = { crumbly = 2 },
    drop = 'default:copper_sulfate_pure'
})

minetest.register_node("default:copper_sulfate", {
    description = "Copper (II) sulfate pentahydrate (CuSO₄·5H₂O)",
    tiles = { "default_copper_sulfate.png" },
    groups = { crumbly = 2 },
    drop = 'default:copper_sulfate'
})

minetest.register_node("default:mercury", {
    description = "Mercury (Hg)",
    tiles = { "default_mercury.png" },
    groups = { cracky = 2 },
    drop = 'default:mercury'
})

minetest.register_node("default:mercury_chloride", {
    description = "Mercury (II) chloride (HgCl₂)",
    tiles = { "default_mercury_chloride.png" },
    groups = { crumbly = 3 },
    drop = 'default:mercury_chloride'
})

minetest.register_node("default:mercury_fluoride", {
    description = "Mercury (II) fluoride (HgF₂)",
    tiles = { "default_mercury_fluoride.png" },
    groups = { crumbly = 2 },
    drop = 'default:mercury_fluoride'
})

minetest.register_node("default:lead_sulfate", {
    description = "Lead (II) sulfate (PbSO₄)",
    tiles = { "default_lead_sulfate.png" },
    groups = { crumbly = 2 },
    drop = 'default:lead_sulfate'
})

minetest.register_node("default:cobalt_blue", {
    description = "Cobalt blue (CoAl₂O₄)",
    tiles = { "default_cobalt_blue.png" },
    groups = { crumbly = 2 },
    drop = 'default:cobalt_blue'
})

minetest.register_node("default:plutonium_fluoride", {
    description = "Plutonium (III) fluoride (PuF₃)",
    tiles = { "default_cinnabar.png" },
    overlay_tiles = { "default_plutonium_fluoride.png" },
    groups = { cracky = 1 },
    drop = 'default:plutonium_fluoride'
})

ores = { "aluminium", "potassium", "zinc" }

for _, name in ipairs(ores) do
    minetest.register_node("default:" .. name, {
        description = name:gsub("^%l", string.upper) .. " (in cinnabar)",
        tiles = { "default_cinnabar.png" },
        overlay_tiles = { "default_" .. name .. ".png" },
        groups = { cracky = 1 },
        drop = "default:" .. name
    })

    minetest.register_node("default:" .. name .. "_azure", {
        description = name:gsub("^%l", string.upper) .. " (in cobalt blue)",
        tiles = { "default_cobalt_blue.png" },
        overlay_tiles = { "default_" .. name .. ".png" },
        groups = { cracky = 1 },
        drop = "default:" .. name .. "_azure"
    })
end

minetest.register_node("default:uranyl_acetate", {
    description = "Uranyl acetate (UO₂(CH₃COO)₂·2H₂O)",
    tiles = { "default_cinnabar.png" },
    overlay_tiles = { "default_uranyl_acetate.png" },
    groups = { cracky = 1 },
    drop = 'default:uranyl_acetate'
})

minetest.register_node("default:mercury_oxide", {
    description = "Mercury (II) oxide (HgO)",
    tiles = { "default_mercury_oxide.png" },
    groups = { crumbly = 2 },
    drop = 'default:mercury_oxide'
})

minetest.register_node("default:red_mercury_oxide", {
    description = "Mercury (II) oxide (HgO, red)",
    tiles = { "default_red_mercury_oxide.png" },
    groups = { crumbly = 2 },
    drop = 'default:red_mercury_oxide'
})

minetest.register_node("default:viridi_petasum_stem", {
    description = "Viridi petasum stem",
    tiles = { "default_viridi_petasum_stem.png" },
    groups = { choppy = 2 },
    drop = 'default:viridi_petasum_stem'
})

minetest.register_node("default:viridi_petasum_body", {
    description = "Viridi petasum body",
    light_source = 3,
    tiles = { "default_viridi_petasum_body.png" },
    groups = { crumbly = 1, choppy = 2, leaves = 1 },
    drop = 'default:viridi_petasum_body'
})

minetest.register_node("default:colossus_stem", {
    description = "Colossus stem",
    tiles = { "default_colossus_stem.png" },
    groups = { cracky = 2 },
    drop = 'default:colossus_stem'
})

minetest.register_node("default:colossus_body", {
    description = "Colossus body",
    tiles = { "default_colossus_body.png" },
    groups = { cracky = 2 },
    drop = 'default:colossus_body'
})

minetest.register_node("default:turris_stem", {
    description = "Turris stem",
    tiles = { "default_turris_stem.png" },
    groups = { choppy = 2 },
    drop = 'default:turris_stem'
})

minetest.register_node("default:turris_body", {
    description = "Turris body",
    tiles = { "default_turris_body.png" },
    groups = { choppy = 2 },
    drop = 'default:turris_body'
})

minetest.register_node("default:rete_stem", {
    description = "Rete stem",
    tiles = { "default_rete_stem.png" },
    groups = { choppy = 2 },
    drop = 'default:rete_stem'
})

minetest.register_node("default:rete_body", {
    description = "Rete body",
    tiles = { "default_rete_body.png" },
    groups = { crumbly = 1, choppy = 2, leaves = 1 },
    drop = 'default:rete_body'
})

truncus_names = {
    "hyacinthum",
    "viridi",
    "purpura"
}

for i, name in ipairs(truncus_names) do
    minetest.register_node("default:truncus_" .. i, {
        description = "Truncus " .. name,
        drawtype = "plantlike",
        tiles = { "default_truncus_" .. i .. ".png" },
        wield_image = "default_truncus_" .. i .. ".png",
        inventory_image = "default_truncus_" .. i .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 }
    })
end

pars_names = {
    "ordinarius",
    "insignis",
    "comantem",
    "longus",
    "lenis"
}

for i, name in ipairs(pars_names) do
    minetest.register_node("default:pars_" .. i, {
        description = "Pars " .. name,
        drawtype = "plantlike",
        tiles = { "default_pars_" .. i .. ".png" },
        wield_image = "default_pars_" .. i .. ".png",
        inventory_image = "default_pars_" .. i .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 }
    })
end

for _, name in ipairs({ "rami", "spears", "viriditas" }) do
    minetest.register_node("default:" .. name, {
        description = name:gsub("^%l", string.upper),
        drawtype = "plantlike",
        tiles = { "default_" .. name .. ".png" },
        wield_image = "default_" .. name .. ".png",
        inventory_image = "default_" .. name .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 }
    })
end

minetest.register_node("default:naga", {
    description = "Naga",
    drawtype = "plantlike",
    tiles = { "default_naga.png" },
    wield_image = "default_naga.png",
    inventory_image = "default_naga.png",
    paramtype = "light",
    walkable = false,
    light_source = 5,
    groups = { snappy = 3, attached_node = 1 }
})

small_mushrooms = {
    ["pusilli"] = {},
    ["rosea"] = {},
    ["purpura"] = { light_source = 5 },
    ["picea"] = {},
    ["caput"] = {},
    ["periculum"] = { light_source = 3 },
    ["vastatorem"] = { light_source = 8 },
    ["quercu"] = {},
    ["grebe"] = {},
    ["secreta"] = {},
    ["pulchram"] = {},
    ["conc"] = {}
}

for name, features in pairs(small_mushrooms) do
    local info = {
        description = name:gsub("^%l", string.upper),
        drawtype = "plantlike",
        tiles = { "default_" .. name .. ".png" },
        wield_image = "default_" .. name .. ".png",
        inventory_image = "default_" .. name .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 }
    }

    for key, value in pairs(features) do
        info[key] = value
    end

    minetest.register_node("default:" .. name, info)
end

minetest.register_node("default:trisilane_source", {
    description = "Trisilane source",
    drawtype = "liquid",
    tiles = {
        {
            name = "default_liquid_source_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
        },
        {
            name = "default_liquid_source_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
        },
    },
    alpha = 70,
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "default:trisilane_flowing",
    liquid_alternative_source = "default:trisilane_source",
    liquid_viscosity = 1,
    post_effect_color = { a = 70, r = 255, g = 255, b = 255 },
    groups = { water = 3, liquid = 3 },
})

minetest.register_node("default:trisilane_flowing", {
    description = "Flowing trisilane",
    drawtype = "flowingliquid",
    tiles = {"default_liquid.png"},
    special_tiles = {
        {
            name = "default_liquid_flowing_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
        {
            name = "default_liquid_flowing_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
    },
    alpha = 70,
    paramtype = "light",
    paramtype2 = "flowingliquid",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:trisilane_flowing",
    liquid_alternative_source = "default:trisilane_source",
    liquid_viscosity = 1,
    post_effect_color = { a = 70, r = 255, g = 255, b = 255 },
    groups = { water = 3, liquid = 3 },
})

minetest.register_node("default:potassium_hydroxide_source", {
    description = "Potassium hydroxide source",
    drawtype = "liquid",
    tiles = {
        {
            name = "default_liquid_source_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
        },
        {
            name = "default_liquid_source_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
        },
    },
    alpha = 50,
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "default:potassium_hydroxide_flowing",
    liquid_alternative_source = "default:potassium_hydroxide_source",
    liquid_viscosity = 1,
    post_effect_color = { a = 30, r = 255, g = 255, b = 255 },
    groups = { water = 3, liquid = 3 },
})

minetest.register_node("default:potassium_hydroxide_flowing", {
    description = "Flowing potassium hydroxide",
    drawtype = "flowingliquid",
    tiles = {"default_liquid.png"},
    special_tiles = {
        {
            name = "default_liquid_flowing_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
        {
            name = "default_liquid_flowing_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
    },
    alpha = 50,
    paramtype = "light",
    paramtype2 = "flowingliquid",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:potassium_hydroxide_flowing",
    liquid_alternative_source = "default:potassium_hydroxide_source",
    liquid_viscosity = 1,
    post_effect_color = { a = 30, r = 255, g = 255, b = 255 },
    groups = { water = 3, liquid = 3 },
})

minetest.register_node("default:water_source", {
    description = "Water Source",
    drawtype = "liquid",
    tiles = {
        {
            name = "default_water_source_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
        },
        {
            name = "default_water_source_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
        },
    },
    alpha = 160,
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "default:water_flowing",
    liquid_alternative_source = "default:water_source",
    liquid_viscosity = 1,
    post_effect_color = {a = 103, r = 30, g = 60, b = 90},
    groups = {water = 3, liquid = 3, cools_lava = 1},
})

minetest.register_node("default:water_flowing", {
    description = "Flowing Water",
    drawtype = "flowingliquid",
    tiles = {"default_water.png"},
    special_tiles = {
        {
            name = "default_water_flowing_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
        {
            name = "default_water_flowing_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
    },
    alpha = 160,
    paramtype = "light",
    paramtype2 = "flowingliquid",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:water_flowing",
    liquid_alternative_source = "default:water_source",
    liquid_viscosity = 1,
    post_effect_color = { a = 103, r = 30, g = 60, b = 90 },
    groups = { water = 3, liquid = 3, not_in_creative_inventory = 1,
               cools_lava = 1 },
})

minetest.register_node("default:mercury_flowing", {
    description = "Mercury (flowing)",
    drawtype = "flowingliquid",
    damage_per_second = 2,
    tiles = { "default_mercury.png" },
    special_tiles = {
        {
            name = "default_mercury_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
            backface_culling = false
        },
        {
            name = "default_mercury_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
            backface_culling = true
        },
    },
    paramtype = "light",
    paramtype2 = "flowingliquid",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    sunlight_propagates = true,
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:mercury_flowing",
    liquid_alternative_source = "default:mercury_source",
    liquid_viscosity = 7,   
    post_effect_color = { a = 200, r = 150, g = 150, b = 150 },
    groups = { water = 3, liquid = 3 },
})

minetest.register_node("default:mercury_source", {
    description = "Mercury",
    drawtype = "liquid",
    damage_per_second = 1,
    tiles = {
        {
            name = "default_mercury_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            }
        }
    },
    special_tiles = {
        {
            name = "default_mercury_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
            backface_culling = false
        },
    },
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "default:mercury_flowing",
    liquid_alternative_source = "default:mercury_source",
    liquid_viscosity = 7,
    post_effect_color = {a = 250, r = 150, g = 150, b = 150},
    groups = { water = 3, liquid = 3 },
})

minetest.register_node("default:potassium_permanganate_flowing", {
    description = "Potassium permanganate (flowing)",
    drawtype = "flowingliquid",
    tiles = { "default_potassium_permanganate.png" },
    special_tiles = {
        {
            name = "default_potassium_permanganate_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
            backface_culling = false
        },
        {
            name = "default_potassium_permanganate_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
            backface_culling = true
        },
    },
    alpha = 160,
    paramtype = "light",
    paramtype2 = "flowingliquid",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:potassium_permanganate_flowing",
    liquid_alternative_source = "default:potassium_permanganate_source",
    liquid_viscosity = 1,
    post_effect_color = { a = 100, r = 160, g = 0, b = 130 },
    groups = { water = 3, liquid = 3 },
})

minetest.register_node("default:potassium_permanganate_source", {
    description = "Potassium permanganate",
    drawtype = "liquid",
    tiles = {
        {
            name = "default_potassium_permanganate_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            }
        }
    },
    special_tiles = {
        {
            name = "default_potassium_permanganate_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
            backface_culling = false
        },
    },
    alpha = 160,
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "default:potassium_permanganate_flowing",
    liquid_alternative_source = "default:potassium_permanganate_source",
    liquid_viscosity = 1,
    post_effect_color = { a = 100, r = 160, g = 0, b = 130 },
    groups = { water = 3, liquid = 3 },
})

minetest.register_node("default:glow_stick", {
    description = "Glow stick",
    drawtype = "torchlike",
    tiles = { "default_glow_stick_on_floor.png", "default_glow_stick_on_ceiling.png", "default_glow_stick.png" },
    inventory_image = "default_glow_stick_on_floor.png",
    wield_image = "default_glow_stick_on_floor.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    is_ground_content = false,
    walkable = false,
    light_source = 14,
    selection_box = {
        type = "wallmounted",
        wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
        wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
        wall_side = {-0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1},
    },
    groups = { choppy=2, dig_immediate=3, attached_node=1 },
    legacy_wallmounted = true,
})