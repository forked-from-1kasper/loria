liquids = {
    ["potassium_hydroxide"] = {
        liquid_viscosity = 1,
        post_effect_color = { a = 30, r = 255, g = 255, b = 255 },
        alpha = 50,
        texture = "default_liquid.png",
        animated_texture = "default_liquid_source_animated.png",
        animated_flowing_texture = "default_liquid_flowing_animated.png",
    },
    ["water"] = {
        liquid_viscosity = 2,
        post_effect_color = { a = 103, r = 30, g = 60, b = 90 },
        alpha = 160,
        texture = "default_water.png",
        animated_texture = "default_water_source_animated.png",
        animated_flowing_texture = "default_water_flowing_animated.png",
    },
    ["mercury"] = {
        damage_per_second = 2,
        liquid_viscosity = 7,
        post_effect_color = { a = 200, r = 150, g = 150, b = 150 },
        alpha = 255,
        texture = "default_mercury.png",
        animated_texture = "default_mercury_animated.png",
        animated_flowing_texture = "default_mercury_animated.png",
    },
    ["potassium_permanganate"] = {
        liquid_viscosity = 1,
        post_effect_color = { a = 100, r = 160, g = 0, b = 130 },
        alpha = 160,
        texture = "default_potassium_permanganate.png",
        animated_texture = "default_potassium_permanganate_animated.png",
        animated_flowing_texture = "default_potassium_permanganate_animated.png",
    }
}

for name, params in pairs(liquids) do
    minetest.register_node("default:" .. name .. "_source", {
        description = name:gsub("^%l", string.upper) .. " source",
        drawtype = "liquid",
        tiles = {
            {
                name = params.animated_texture,
                backface_culling = false,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 2.0,
                },
            },
            {
                name = params.animated_texture,
                backface_culling = true,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 2.0,
                },
            },
        },
        alpha = params.alpha,
        paramtype = "light",
        walkable = false,
        pointable = false,
        diggable = false,
        buildable_to = true,
        is_ground_content = false,
        drop = "",
        drowning = 1,
        liquidtype = "source",
        liquid_alternative_flowing = "default:" .. name .. "_flowing",
        liquid_alternative_source = "default:" .. name .. "_source",
        liquid_viscosity = params.liquid_viscosity,
        post_effect_color = params.post_effect_color,
        damage_per_second = params.damage_per_second or 0,
        groups = { liquid = 3 },
    })

    minetest.register_node("default:" .. name .. "_flowing", {
        description = "Flowing " .. name,
        drawtype = "flowingliquid",
        tiles = { params.texture },
        special_tiles = {
            {
                name = params.animated_flowing_texture,
                backface_culling = false,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 0.8,
                },
            },
            {
                name = params.animated_flowing_texture,
                backface_culling = true,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 0.8,
                },
            },
        },
        alpha = params.alpha,
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
        liquid_alternative_flowing = "default:" .. name .. "_flowing",
        liquid_alternative_source = "default:" .. name .. "_source",
        liquid_viscosity = params.liquid_viscosity,
        post_effect_color = params.post_effect_color,
        damage_per_second = params.damage_per_second or 0,
        groups = { liquid = 3 },
    })
end