minetest.register_item(":", {
    type = "none",
    wield_image = "wieldhand.png",
    wield_scale = { x = 1, y = 1, z = 2.5 },
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            fleshy = { times = { [2] = 2.00, [3] = 1.00 }, uses = 0, maxlevel = 1},
            crumbly = { times = { [2] = 3.00, [3] = 0.70 }, uses = 0, maxlevel = 1},
            snappy = { times = { [3] = 0.40 }, uses = 0, maxlevel = 1},
            oddly_breakable_by_hand = {times = { [1] = 7.00, [2] = 4.00, [3] = 1.40}, uses = 0, maxlevel = 5},
        },
        damage_groups = { fleshy = 1 },
    }
})

minetest.register_craftitem("default:drill", {
    description = "Drill",
    stack_max = 1,
    liquids_pointable = false,
    range = 5.0,
    inventory_image = "default_drill.png",
    wield_image = "default_drill.png",
    tool_capabilities = {
        max_drop_level = 1,
        groupcaps = {
            cracky = {
                times = { [1] = 2.00, [2] = 1.20, [3] = 0.80 },
                uses = 50,
                maxlevel = 1
            },
            oddly_breakable_by_hand = {
                times = { [1] = 0.50, [2] = 0.30, [3] = 0.10 }
            }
        },
        damage_groups = { fleshy = 2 }
    }
})

minetest.register_craftitem("default:empty_balloon", {
    inventory_image = "default_empty_balloon.png",
    description = "Empty balloon",
    stack_max = 1
})

minetest.register_craftitem("default:oxygen_balloon", {
    inventory_image = "default_oxygen_balloon.png",
    description = "Oxygen balloon",
    stack_max = 1,
    on_use = function(itemstack, player, pointed_thing)
        player:set_attribute("oxygen", tonumber(player:get_attribute("oxygen")) + 100)
        return { name = "default:empty_balloon" }
    end
})

bucket = {}
bucket.liquids = {}

function bucket.register_liquid(source, flowing, itemname, inventory_image, description)
    bucket.liquids[source] = {
        source = source,
        flowing = flowing,
        itemname = itemname
    }
    bucket.liquids[flowing] = bucket.liquids[source]

    if itemname ~= nil then
        minetest.register_craftitem(itemname, {
            description = description,
            inventory_image = inventory_image,
            stack_max = 1,
            liquids_pointable = true,
            on_use = function(itemstack, user, pointed_thing)
                if pointed_thing.type ~= "node" then
                    return
                end
                n = minetest.get_node(pointed_thing.under)
                if bucket.liquids[n.name] == nil then
                    minetest.add_node(pointed_thing.above, { name = source })
                elseif n.name ~= source then
                    minetest.add_node(pointed_thing.under, { name = source })
                end
                return { name = "default:bucket_empty" }
            end
        })
    end
end

minetest.register_craftitem("default:bucket_empty", {
    inventory_image = "bucket.png",
    description = "Empty bucket",
    stack_max = 5,
    liquids_pointable = true,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        n = minetest.get_node(pointed_thing.under)
        liquiddef = bucket.liquids[n.name]
        if liquiddef ~= nil and liquiddef.source == n.name and liquiddef.itemname ~= nil then
            minetest.add_node(pointed_thing.under, { name = "air" })
            return { name = liquiddef.itemname }
        end
    end
})

bucket.register_liquid(
    "default:mercury_source",
    "default:mercury_flowing",
    "default:bucket_mercury",
    "bucket_mercury.png",
    "Bucket with mercury"
)