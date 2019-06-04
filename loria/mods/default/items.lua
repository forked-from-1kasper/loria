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

minetest.register_tool("default:drill", {
    description = "Drill",
    stack_max = 1,
    liquids_pointable = false,
    range = 5.0,
    inventory_image = "default_drill.png",
    wield_image = "default_drill.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            cracky = {
                times = { [1] = 2.00, [2] = 1.20, [3] = 0.80 },
                uses = 10
            },
            crumbly = {
                times = { [1] = 0.50, [2] = 0.30, [3] = 0.10 },
                uses = 20
            },
            oddly_breakable_by_hand = {
                times = { [1] = 0.50, [2] = 0.30, [3] = 0.10 }
            }
        },
        damage_groups = { fleshy = 2 }
    }
})

minetest.register_craftitem("default:super_drill", {
    description = "Super drill",
    stack_max = 1,
    liquids_pointable = false,
    range = 5.0,
    inventory_image = "default_super_drill.png",
    wield_image = "default_super_drill.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            cracky = {
                times = { [1] = 0.05, [2] = 0.05, [3] = 0.05 }
            },
            crumbly = {
                times = { [1] = 0.05, [2] = 0.05, [3] = 0.05 }
            },
            oddly_breakable_by_hand = {
                times = { [1] = 0.05, [2] = 0.05, [3] = 0.05 }
            }
        },
        damage_groups = { fleshy = 2 }
    }
})

minetest.register_tool("default:empty_balloon", {
    inventory_image = "default_empty_balloon.png",
    description = "Empty balloon",
    stack_max = 1
})

balloon_use = 100
balloon_coeff = 128
minetest.register_tool("default:oxygen_balloon", {
    inventory_image = "default_oxygen_balloon.png",
    description = "Oxygen balloon",
    stack_max = 1,
    on_use = function(itemstack, player, pointed_thing)
        local meta = player:get_meta()

        local current_wear = itemstack:get_wear()
        local oxygen = math.floor((65535 - current_wear) / balloon_coeff)

        local current_oxygen = meta:get_int("oxygen")

        if oxygen <= balloon_use then
            meta:set_int("oxygen", current_oxygen + oxygen)
            return { name = "default:empty_balloon", wear = 0 }
        else
            local wear = current_wear + balloon_use * balloon_coeff
            meta:set_int("oxygen", current_oxygen + balloon_use)
            return { name = "default:oxygen_balloon", wear = wear }
        end
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

bucket.register_liquid(
    "default:potassium_permanganate_source",
    "default:potassium_permanganate_flowing",
    "default:bucket_potassium_permanganate",
    "bucket_potassium_permanganate.png",
    "Bucket with potassium permanganate"
)

bucket.register_liquid(
    "default:water_source",
    "default:water_flowing",
    "default:bucket_water",
    "bucket_water.png",
    "Bucket with water"
)

minetest.register_craftitem("default:aluminium_ingot", {
    description = "Aluminium ingot",
    inventory_image = "default_aluminium_ingot.png",
})
