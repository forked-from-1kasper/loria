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