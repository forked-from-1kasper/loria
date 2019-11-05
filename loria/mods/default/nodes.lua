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

minetest.register_node("default:silicon", {
    description = "Silicon (Si)",
    tiles = { "default_silicon.png" },
    groups = { crumbly = 2 },
})

minetest.register_node("default:magnesium_silicide", {
    description = "Magnesium silicide (Mg2Si)",
    tiles = { "default_magnesium_silicide.png" },
    groups = { crumbly = 2 },
})

minetest.register_node("default:magnesium_oxide", {
    description = "Magnesium oxide (MgO)",
    tiles = { "default_magnesium_oxide.png" },
    groups = { crumbly = 2 },
})

minetest.register_node("default:potassium_manganate", {
    description = "Potassium manganate (K2MnO4)",
    tiles = { "default_potassium_manganate.png" },
    groups = { crumbly = 3 },
    drop = 'default:potassium_manganate'
})

minetest.register_node("default:aluminium_oxide", {
    description = "Aluminium (III) oxide (Al2O3)",
    tiles = { "default_aluminium_oxide.png" },
    groups = { crumbly = 3 },
    drop = 'default:aluminium_oxide'
})

minetest.register_node("default:manganese_dioxide", {
    description = "Manganese dioxide (MnO2)",
    tiles = { "default_manganese_dioxide.png" },
    groups = { crumbly = 3 },
    drop = 'default:manganese_dioxide'
})

minetest.register_node("default:manganese_oxide", {
    description = "Manganese oxide (MnO)",
    tiles = { "default_manganese_oxide.png" },
    groups = { crumbly = 3 },
    drop = 'default:manganese_oxide'
})

minetest.register_node("default:ammonium_manganese_pyrophosphate", {
    description = "Ammonium manganese (III) pyrophosphate",
    tiles = { "default_ammonium_manganese_pyrophosphate.png" },
    groups = { crumbly = 2 },
    drop = 'default:ammonium_manganese_pyrophosphate'
})

minetest.register_node("default:cinnabar", {
    description = "Cinnabar (HgS)",
    tiles = { "default_cinnabar.png" },
    groups = { cracky = 2 },
    drop = 'default:cinnabar'
})

minetest.register_node("default:copper_oxide", {
    description = "Copper (II) oxide (CuO)",
    tiles = { "default_copper_oxide.png" },
    groups = { crumbly = 2 },
    drop = 'default:copper_oxide'
})

minetest.register_node("default:copper_sulfate_pure", {
    description = "Copper (II) sulfate (CuSO4)",
    tiles = { "default_copper_sulfate_pure.png" },
    groups = { crumbly = 2 },
    drop = 'default:copper_sulfate_pure'
})

minetest.register_node("default:copper_sulfate", {
    description = "Copper (II) sulfate pentahydrate (CuSO4 * 5H2O)",
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

minetest.register_node("default:uranium", {
    description = "Uranium (U)",
    tiles = { "default_uranium.png" },
    groups = { cracky = 1 },
    drop = 'default:uranium'
})

minetest.register_node("default:lead", {
    description = "Lead (Pb)",
    tiles = { "default_lead.png" },
    groups = { cracky = 1 },
    drop = 'default:lead'
})

minetest.register_node("default:brick", {
    description = "Brick",
    tiles = { "default_brick.png" },
    groups = { cracky = 2 },
    drop = 'default:brick'
})

minetest.register_node("default:lead_case", {
    description = "Lead case",
    tiles = { "default_lead_case.png" },
    groups = { cracky = 2 },
    drop = 'default:lead_case'
})

minetest.register_node("default:mercury_chloride", {
    description = "Mercury (II) chloride (HgCl2)",
    tiles = { "default_mercury_chloride.png" },
    groups = { crumbly = 3 },
    drop = 'default:mercury_chloride'
})

minetest.register_node("default:zinc_chloride", {
    description = "Zinc chloride (ZnCl2)",
    tiles = { "default_zinc_chloride.png" },
    groups = { crumbly = 3 },
    drop = 'default:zinc_chloride'
})

minetest.register_node("default:aluminium_chloride", {
    description = "Aluminium chloride (AlCl3)",
    tiles = { "default_aluminium_chloride.png" },
    groups = { crumbly = 3 },
    drop = 'default:aluminium_chloride'
})

minetest.register_node("default:potassium_chloride", {
    description = "Potassium chloride (KCl)",
    tiles = { "default_potassium_chloride.png" },
    groups = { crumbly = 3 },
    drop = 'default:potassium_chloride'
})

minetest.register_node("default:mercury_fluoride", {
    description = "Mercury (II) fluoride (HgF2)",
    tiles = { "default_mercury_fluoride.png" },
    groups = { crumbly = 2 },
    drop = 'default:mercury_fluoride'
})

minetest.register_node("default:lead_sulfate", {
    description = "Lead (II) sulfate (PbSO4)",
    tiles = { "default_lead_sulfate.png" },
    groups = { crumbly = 1 },
    drop = 'default:lead_sulfate'
})

minetest.register_node("default:sodium_peroxide", {
    description = "Sodium peroxide (Na2O2)",
    tiles = { "default_sodium_peroxide.png" },
    groups = { crumbly = 2 },
    drop = 'default:sodium_peroxide'
})

minetest.register_node("default:cobalt_sulfate", {
    description = "Cobalt sulfate (CoSO4)",
    tiles = { "default_cobalt_sulfate.png" },
    groups = { crumbly = 2 },
    drop = 'default:cobalt_sulfate'
})

minetest.register_node("default:chromia", {
    description = "Chromium (III) oxide (Cr2O3)",
    tiles = { "default_chromia.png" },
    groups = { crumbly = 1 },
    drop = 'default:chromia'
})

minetest.register_node("default:chromium_trioxide", {
    description = "Chromium trioxide (CrO3)",
    tiles = { "default_chromium_trioxide.png" },
    groups = { cracky = 2 },
    drop = 'default:chromium_trioxide'
})

minetest.register_node("default:nickel_nitrate", {
    description = "Nickel (II) nitrate (Ni(NO3)2)",
    tiles = { "default_nickel_nitrate.png" },
    groups = { crumbly = 1 },
    drop = 'default:nickel_nitrate'
})

minetest.register_node("default:chromium_fluoride", {
    description = "Chromium (III) fluoride (CrF3)",
    tiles = { "default_chromium_fluoride.png" },
    groups = { cracky = 2 },
    drop = 'default:chromium_fluoride'
})

minetest.register_node("default:chromium_fluoride_capital", {
    description = "Machined chromium fluoride (I)",
    tiles = { "default_chromium_fluoride.png^default_capital.png" },
    groups = { cracky = 1 },
})

minetest.register_node("default:chromium_fluoride_shaft", {
    description = "Machined chromium fluoride (II)",
    tiles = map(function(postfix)
                    return "default_chromium_fluoride.png^" .. postfix
                end,
                { "default_shaft_top_bottom.png",
                  "default_shaft_top_bottom.png",
                  "default_shaft.png",
                  "default_shaft.png",
                  "default_shaft.png",
                  "default_shaft.png" }),
    groups = { cracky = 1 },
    paramtype2 = "wallmounted",
})

minetest.register_node("default:chromium_fluoride_base", {
    description = "Machined chromium fluoride (III)",
    tiles = map(function(postfix)
                    return "default_chromium_fluoride.png^" .. postfix
                end,
                { "default_base_top.png",
                  "default_base_bottom.png",
                  "default_base.png",
                  "default_base.png",
                  "default_base.png",
                  "default_base.png" }),
    groups = { cracky = 1 },
    paramtype2 = "wallmounted",
})

minetest.register_node("default:chromium_fluoride_volutes", {
    description = "Machined chromium fluoride (IV)",
    tiles = map(function(postfix)
                    return "default_chromium_fluoride.png^" .. postfix
                end,
                { "default_volutes_top.png",
                  "default_volutes_bottom.png",
                  "default_volutes.png",
                  "default_volutes.png",
                  "default_volutes.png",
                  "default_volutes.png" }),
    groups = { cracky = 1 },
    paramtype2 = "wallmounted",
})

minetest.register_node("default:chromium_fluoride_floor", {
    description = "Machined chromium fluoride (V)",
    tiles = { "default_chromium_fluoride.png^default_floor.png" },
    groups = { cracky = 1 },
})

minetest.register_node("default:chromium_fluoride_cross", {
    description = "Machined chromium fluoride (VI)",
    tiles = { "default_chromium_fluoride.png^default_cross.png" },
    groups = { cracky = 1 },
})

minetest.register_node("default:chromium_fluoride_hooked_cross", {
    description = "Machined chromium fluoride (VII)",
    tiles = { "default_chromium_fluoride.png^default_hooked_cross.png" },
    groups = { cracky = 1 },
})

minetest.register_node("default:chromium_fluoride_block", {
    description = "Machined chromium fluoride (VIII)",
    tiles = { "default_chromium_fluoride.png^default_block.png" },
    groups = { cracky = 1 },
})

minetest.register_node("default:chromium_fluoride_filled_floor", {
    description = "Machined chromium fluoride (IX)",
    tiles = { "default_chromium_fluoride.png^default_filled_floor.png" },
    groups = { cracky = 1 },
})

minetest.register_node("default:lead_oxide", {
    description = "Lead (II) oxide (PbO)",
    tiles = { "default_lead_oxide.png" },
    groups = { crumbly = 2 },
    drop = 'default:lead_oxide'
})

minetest.register_node("default:silicon_dioxide", {
    description = "Silicon dioxide (SiO2)",
    tiles = { "default_silicon_dioxide.png" },
    groups = { crumbly = 3 },
    drop = 'default:silicon_dioxide'
})

minetest.register_node("default:fused_quartz", {
    description = "Fused quartz (glass)",
    drawtype = "glasslike",
    tiles ={ "default_fused_quartz.png" },
    paramtype = "light",
    is_ground_content = false,
    sunlight_propagates = true,
    groups = { snappy = 2, cracky = 3, oddly_breakable_by_hand = 3 },
})

minetest.register_node("default:cobalt_blue", {
    description = "Cobalt blue (CoAl2O4)",
    tiles = { "default_cobalt_blue.png" },
    groups = { crumbly = 2 },
    drop = 'default:cobalt_blue'
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

minetest.register_node("default:sulfur", {
    description = "Sulfur (S)",
    tiles = { "default_sulfur.png" },
    groups = { crumbly = 2 },
    drop = 'default:sulfur'
})

minetest.register_node("default:blowed_out_glow_stick", {
    description = "Blowed out glow stick",
    drawtype = "torchlike",
    tiles = {
        "default_blowed_out_glow_stick_on_floor.png",
        "default_blowed_out_glow_stick_on_ceiling.png",
        "default_blowed_out_glow_stick.png"
    },
    inventory_image = "default_blowed_out_glow_stick_on_floor.png",
    wield_image = "default_blowed_out_glow_stick_on_floor.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    is_ground_content = false,
    walkable = false,
    selection_box = {
        type = "wallmounted",
        wall_top = { -0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1 },
        wall_bottom = { -0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1 },
        wall_side = { -0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1 },
    },
    groups = { choppy = 2, dig_immediate = 3, attached_node = 1 },
    legacy_wallmounted = true,
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
    light_source = 10,
    selection_box = {
        type = "wallmounted",
        wall_top = { -0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1 },
        wall_bottom = { -0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1 },
        wall_side = { -0.5, -0.3, -0.1, -0.5+0.3, 0.3, 0.1 },
    },
    groups = { choppy = 2, dig_immediate = 3, attached_node = 1 },
    legacy_wallmounted = true,
})

function drop_everything(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    for _, list in pairs(inv:get_lists()) do
        for _, item_stack in ipairs(list) do
            minetest.add_item(pos, item_stack)
        end
    end
end

function setup_formspec(inv_size, formspec)
    return function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", formspec)
        meta:get_inventory():set_size('main', inv_size)
    end
end

lead_box_formspec =
    "size[8,10.5]"..
    "list[context;main;0,0;8,5;]"..
    "list[current_player;main;0,6;8,1;]"..
    "list[current_player;main;0,7.5;8,3;8]"

minetest.register_node("default:lead_box", {
    description = "Lead box",
    tiles = {
        "default_lead_box_top.png", "default_lead_box_bottom.png",
        "default_lead_box_side.png", "default_lead_box_side.png",
        "default_lead_box_side.png", "default_lead_box_front.png"
    },

    on_destruct = drop_everything,
    on_construct = setup_formspec(40, lead_box_formspec),
    paramtype2 = "facedir",
    groups = { cracky = 2 },
})

silicon_box_formspec =
    "size[8,8.5]"..
    "list[context;main;0,0;8,3;]"..
    "list[current_player;main;0,4;8,1;]"..
    "list[current_player;main;0,5.5;8,3;8]"

minetest.register_node("default:silicon_box", {
    description = "Silicon box",
    tiles = {
        "default_silicon_box_top.png", "default_silicon_box_bottom.png",
        "default_silicon_box_side.png", "default_silicon_box_side.png",
        "default_silicon_box_side.png", "default_silicon_box_front.png"
    },

    on_destruct = drop_everything,
    on_construct = setup_formspec(24, silicon_box_formspec),
    paramtype2 = "facedir",
    groups = { cracky = 2 },
})

for name, _ in pairs(brickable) do
    local source = minetest.registered_nodes[name]
    minetest.register_node(name .. "_brick", {
        description = source.description .. " brick",
        tiles = map(function(tile)
            return tile .. "^default_brick_mask.png"
        end, source.tiles),
        groups = { cracky = 3 },
        drop = name .. "_brick",
    })
end