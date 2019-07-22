for name, params in pairs(ores) do
    minetest.register_node("default:" .. name .. "_cinnabar", {
        description = capitalization(name) .. " (in cinnabar)",
        tiles = { "default_cinnabar.png^default_" .. name .. "_ore.png" },
        groups = { cracky = 2 },
        drop = "default:" .. name .. "_cinnabar"
    })

    minetest.register_node("default:" .. name .. "_azure", {
        description = capitalization(name) .. " (in cobalt blue)",
        tiles = { "default_cobalt_blue.png^default_" .. name .. "_ore.png" },
        groups = { cracky = 2 },
        drop = "default:" .. name .. "_azure"
    })

    minetest.register_node("default:" .. name, {
        description = capitalization(name) .. " (" .. params.formula .. ")",
        tiles = { "default_" .. name .. ".png" },
        groups = { cracky = 1 },
        drop = "default:" .. name
    })

    if params.has_ingot then
        minetest.register_craftitem("default:" .. name .."_ingot", {
            description = capitalization(name) .. " ingot",
            inventory_image = "default_" .. name .. "_ingot.png",
        })
    end
end

minetest.register_node("default:plutonium_dioxide", {
    description = "Plutonium (IV) oxide (PuO2)",
    tiles = { "default_plutonium_dioxide.png" },
    groups = { cracky = 2 },
    drop = 'default:plutonium_dioxide'
})

minetest.register_node("default:plutonium_tetrafluoride", {
    description = "Plutonium (IV) tetrafluoride (PuF4)",
    tiles = { "default_plutonium_tetrafluoride.png" },
    groups = { cracky = 2 },
    drop = 'default:plutonium_tetrafluoride'
})

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
    liquid_renewable = false,
    liquid_alternative_flowing = "default:trisilane_flowing",
    liquid_alternative_source = "default:trisilane_source",
    liquid_viscosity = 1,
    post_effect_color = { a = 70, r = 255, g = 255, b = 255 },
    groups = { water = 3, liquid = 3, not_in_creative_inventory = 1 },
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
    liquid_renewable = false,
    liquid_alternative_flowing = "default:trisilane_flowing",
    liquid_alternative_source = "default:trisilane_source",
    liquid_viscosity = 1,
    post_effect_color = { a = 70, r = 255, g = 255, b = 255 },
    groups = { water = 3, liquid = 3, not_in_creative_inventory = 1 },
})

minetest.register_node("default:trisilane_cinnabar", {
    description = "Trisilane (in cinnabar)",
    tiles = { "default_cinnabar.png^default_trisilane_ore.png" },
    groups = { cracky = 1 },
    drop = {},
    after_destruct = function(pos, oldnode)
        minetest.set_node(pos, { name = "default:trisilane_source" })
    end
})

minetest.register_node("default:trisilane_cobalt_blue", {
    description = "Trisilane (in cobalt blue)",
    tiles = { "default_cobalt_blue.png^default_trisilane_ore.png" },
    groups = { cracky = 1 },
    drop = {},
    after_destruct = function(pos, oldnode)
        minetest.set_node(pos, { name = "default:trisilane_source" })
    end
})