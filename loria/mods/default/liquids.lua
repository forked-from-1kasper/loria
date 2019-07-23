liquids = {
    ["potassium_hydroxide"] = {
        liquid_viscosity = 1,
        damage = 3,
        post_effect_color = { a = 30, r = 255, g = 255, b = 255 },
        alpha = 50,
        texture = "default_liquid.png",
        animated_texture = "default_liquid_source_animated.png",
        animated_flowing_texture = "default_liquid_flowing_animated.png",
        bucket_image = "bucket_potassium_hydroxide.png",
        bucket_description = "Potassium hydroxide (KOH)",
    },
    ["trisilane"] = {
        liquid_viscosity = 1,
        post_effect_color = { a = 70, r = 255, g = 255, b = 255 },
        alpha = 70,
        texture = "default_liquid.png",
        animated_texture = "default_liquid_source_animated.png",
        animated_flowing_texture = "default_liquid_flowing_animated.png",
        is_fuel = true,
        bucket_image = "bucket_trisilane.png",
        bucket_description = "Trisilane (Si3H8)",
    },
    ["hydrochloric_acid"] = {
        liquid_viscosity = 1,
        post_effect_color = { a = 30, r = 255, g = 255, b = 255 },
        damage = 10,
        alpha = 30,
        texture = "default_liquid.png",
        animated_texture = "default_liquid_source_animated.png",
        animated_flowing_texture = "default_liquid_flowing_animated.png",
        bucket_image = "bucket_hydrochloric_acid.png",
        bucket_description = "Hydrochloric acid (HCl)",
    },
    ["sulfur_trioxide"] = {
        liquid_viscosity = 1,
        post_effect_color = { a = 30, r = 255, g = 255, b = 255 },
        alpha = 100,
        damage = 5,
        texture = "default_liquid.png",
        animated_texture = "default_liquid_source_animated.png",
        animated_flowing_texture = "default_liquid_flowing_animated.png",
        bucket_image = "bucket_sulfur_trioxide.png",
        bucket_description = "Sulfur trioxide (SO3)",
    },
    ["water"] = {
        liquid_viscosity = 2,
        post_effect_color = { a = 103, r = 30, g = 60, b = 90 },
        alpha = 160,
        texture = "default_water.png",
        animated_texture = "default_water_source_animated.png",
        animated_flowing_texture = "default_water_flowing_animated.png",
        bucket_image = "bucket_water.png",
        bucket_description = "Water (H2O)",
    },
    ["mercury"] = {
        damage_per_second = 2,
        liquid_viscosity = 7,
        post_effect_color = { a = 252, r = 150, g = 150, b = 150 },
        alpha = 255,
        texture = "default_mercury.png",
        animated_texture = "default_mercury_animated.png",
        animated_flowing_texture = "default_mercury_animated.png",
        bucket_image = "bucket_mercury.png",
        bucket_description = "Polluted (U, Th) mercury",
    },
    ["potassium_permanganate"] = {
        liquid_viscosity = 1,
        post_effect_color = { a = 100, r = 160, g = 0, b = 130 },
        alpha = 160,
        texture = "default_potassium_permanganate.png",
        animated_texture = "default_potassium_permanganate_animated.png",
        animated_flowing_texture = "default_potassium_permanganate_animated.png",
        bucket_image = "bucket_potassium_permanganate.png",
        bucket_description = "Potassium permanganate (KMnO4)",
    },
    ["lucidum"] = {
        liquid_viscosity = 3,
        post_effect_color = { a = 150, r = 0, g = 128, b = 255 },
        alpha = 150,
        light_source = 13,
        texture = "default_liquid.png^[colorize:#0080ff",
        animated_texture = "default_liquid_source_animated.png^[colorize:#0080ff",
        animated_flowing_texture = "default_liquid_flowing_animated.png^[colorize:#0080ff",
        bucket_image = "bucket_lucidum.png",
        bucket_description = "Lucidum",
    },
}

bucket = {}
bucket.is_bucket = {}
bucket.liquids = {}

minetest.register_craftitem("default:bucket_empty", {
    inventory_image = "bucket.png",
    description = "Empty bucket",
    stack_max = 1,
    liquids_pointable = true,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        n = minetest.get_node(pointed_thing.under)
        local liquiddef = bucket.liquids[n.name]
        if liquiddef ~= nil and liquiddef.source == n.name and liquiddef.itemname ~= nil then
            minetest.add_node(pointed_thing.under, { name = "air" })
            return { name = liquiddef.itemname, wear = itemstack:get_wear() }
        end
    end
})

for name, params in pairs(liquids) do
    local source = "default:" .. name .. "_source"
    local flowing = "default:" .. name .. "_flowing"
    local itemname = "default:bucket_" .. name

    minetest.register_node(source, {
        description = capitalization(name) .. " source",
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
        light_source = params.light_source or 0,
        liquidtype = "source",
        liquid_renewable = false,
        liquid_alternative_flowing = flowing,
        liquid_alternative_source = source,
        liquid_viscosity = params.liquid_viscosity,
        post_effect_color = params.post_effect_color,
        damage_per_second = params.damage_per_second or 0,
        groups = { liquid = 3, not_in_creative_inventory = 1 },
    })

    minetest.register_node(flowing, {
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
        light_source = params.light_source or 0,
        liquidtype = "flowing",
        liquid_renewable = false,
        liquid_alternative_flowing = flowing,
        liquid_alternative_source = source,
        liquid_viscosity = params.liquid_viscosity,
        post_effect_color = params.post_effect_color,
        damage_per_second = params.damage_per_second or 0,
        groups = { liquid = 3, not_in_creative_inventory = 1 },
    })

    bucket.liquids[source] = {
        source = source,
        flowing = flowing,
        itemname = itemname
    }
    bucket.liquids[flowing] = bucket.liquids[source]
    bucket.is_bucket[itemname] = true

    (params.is_fuel and minetest.register_tool or minetest.register_craftitem)(itemname, {
        description = params.bucket_description,
        inventory_image = params.bucket_image,
        stack_max = 1,
        liquids_pointable = true,
        on_use = function(itemstack, user, pointed_thing)
            if pointed_thing.type ~= "node" then
                return
            end
            local n = minetest.get_node(pointed_thing.under)
            if bucket.liquids[n.name] == nil then
                minetest.add_node(pointed_thing.above, { name = source })
            elseif n.name ~= source then
                minetest.add_node(pointed_thing.under, { name = source })
            end
            return { name = "default:bucket_empty", wear = itemstack:get_wear() }
        end
    })
end