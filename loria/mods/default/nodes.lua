minetest.register_node("default:test", {
    description = "For tests only",
    tiles = { "default_test.png" },
    drop = 'default:test',
    groups = { crumbly = 3 }
})

minetest.register_node("default:infinite_oxygen", {
    description = "Infinite oxygen",
    tiles = { "default_test.png^[colorize:#0000ff50" },
    drop = 'default:infinite_oxygen',
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
    groups = { choppy = 2, dig_immediate = 3, attached_node=1 },
    legacy_wallmounted = true,
})