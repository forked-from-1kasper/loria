minetest.register_node("default:cinnabar", {
    description = "Cinnabar (HgS)",
    tiles = { "default_cinnabar.png" },
    groups = { cracky = 1 },
    drop = 'default:cinnabar'
})

minetest.register_node("default:copper_sulfate", {
    description = "Copper (II) sulfate (CuSO₄)",
    tiles = { "default_copper_sulfate.png" },
    groups = { oddly_breakable_by_hand = 1 },
    drop = 'default:copper_sulfate'
})

minetest.register_node("default:lead_sulfate", {
    description = "Lead (II) sulfate (PbSO₄)",
    tiles = { "default_lead_sulfate.png" },
    groups = { oddly_breakable_by_hand = 1 },
    drop = 'default:lead_sulfate'
})

minetest.register_node("default:cobalt_blue", {
    description = "Cobalt blue (CoAl₂O₄)",
    tiles = { "default_cobalt_blue.png" },
    groups = { oddly_breakable_by_hand = 1 },
    drop = 'default:cobalt_blue'
})

minetest.register_node("default:uranyl_acetate", {
    description = "Uranyl acetate (UO₂(CH₃COO)₂·2H₂O)",
    tiles = { "default_uranyl_acetate.png" },
    groups = { cracky = 1 },
    drop = 'default:uranyl_acetate'
})

minetest.register_node("default:mercury_oxide", {
    description = "Mercury (II) oxide (HgO)",
    tiles = { "default_mercury_oxide.png" },
    groups = { oddly_breakable_by_hand = 1 },
    drop = 'default:mercury_oxide'
})

minetest.register_node("default:red_mercury_oxide", {
    description = "Mercury (II) oxide (HgO, red)",
    tiles = { "default_red_mercury_oxide.png" },
    groups = { oddly_breakable_by_hand = 1 },
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
    groups = { oddly_breakable_by_hand = 1, choppy = 2, leaves = 1 },
    drop = 'default:viridi_petasum_body'
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
    groups = { oddly_breakable_by_hand = 1, choppy = 2, leaves = 1 },
    drop = 'default:rete_body'
})

truncus_names = {
    "hyacinthum",
    "viridi",
    "purpura"
}

truncus_types = 3
for i = 1, truncus_types do
    minetest.register_node("default:truncus_" .. i, {
        description = "Truncus " .. truncus_names[i],
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

pars_types = 5
for i = 1, pars_types do
    minetest.register_node("default:pars_" .. i, {
        description = "Pars " .. pars_names[i],
        drawtype = "plantlike",
        tiles = { "default_pars_" .. i .. ".png" },
        wield_image = "default_pars_" .. i .. ".png",
        inventory_image = "default_pars_" .. i .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 }
    })
end

minetest.register_node("default:pusilli", {
    description = "Pusilli mushroom",
    drawtype = "plantlike",
    tiles = { "default_pusilli.png" },
    wield_image = "default_pusilli.png",
    inventory_image = "default_pusilli.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, attached_node = 1 }
})

minetest.register_node("default:rosea", {
    description = "Rosea mushroom",
    drawtype = "plantlike",
    tiles = { "default_rosea.png" },
    wield_image = "default_rosea.png",
    inventory_image = "default_rosea.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, attached_node = 1 }
})

minetest.register_node("default:purpura", {
    description = "Purpura mushroom",
    light_source = 5,
    drawtype = "plantlike",
    tiles = { "default_purpura.png" },
    wield_image = "default_purpura.png",
    inventory_image = "default_purpura.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, attached_node = 1 }
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
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:mercury_flowing",
    liquid_alternative_source = "default:mercury_source",
    liquid_viscosity = 7,
    post_effect_color = { a = 200, r = 150, g = 150, b = 150 },
    groups = {water = 3, liquid = 3},
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
    groups = {water = 3, liquid = 3},
})