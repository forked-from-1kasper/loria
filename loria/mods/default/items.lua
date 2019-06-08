minetest.register_item(":", {
    type = "none",
    wield_image = "wieldhand.png",
    wield_scale = { x = 1, y = 1, z = 3.5 },
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            fleshy = { times = { [2] = 2.00, [3] = 1.00 }, uses = 0, maxlevel = 1},
            crumbly = { times = { [2] = 3.00, [3] = 0.70 }, uses = 0, maxlevel = 1},
            snappy = { times = { [3] = 0.40 }, uses = 0, maxlevel = 1},
            cracky = { times = { [1] = 9.00, [2] = 7.00, [3] = 5.00 } },
            oddly_breakable_by_hand = {times = { [1] = 7.00, [2] = 4.00, [3] = 1.40}, uses = 0, maxlevel = 5},
        },
        damage_groups = { fleshy = 1 },
    }
})

minetest.register_craftitem("default:broken_drill", {
    description = "Broken drill",
    inventory_image = "default_broken_drill.png",
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
                uses = 80
            },
            choppy = {
                times = { [1] = 1.00, [2] = 0.50, [3] = 0.20 },
                uses = 360
            },
            crumbly = {
                times = { [1] = 0.50, [2] = 0.30, [3] = 0.10 },
                uses = 200
            },
            oddly_breakable_by_hand = {
                times = { [1] = 0.50, [2] = 0.30, [3] = 0.10 }
            }
        },
        damage_groups = { fleshy = 2 }
    },
    after_use = function(itemstack, user, node, digparams)
        if itemstack:get_wear() + digparams.wear >= 65535 then
            return { name = "default:broken_drill", count = 1 }
        else
            itemstack:add_wear(digparams.wear)
            return itemstack
        end
    end
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

minetest.register_craftitem("default:battery", {
    inventory_image = "default_battery.png",
    description = "Battery",
    stack_max = 16,
})

minetest.register_craftitem("default:aluminium_case", {
    inventory_image = "default_aluminium_case.png",
    description = "Aluminium case",
    stack_max = 16,
})

minetest.register_craftitem("default:empty_balloon", {
    inventory_image = "default_empty_balloon.png",
    description = "Empty balloon",
    stack_max = 1
})

function get_gas(pos)
    return detect_gas(minetest.get_node(pos).name)
end

balloon_use = 100
balloon_coeff = 64
broken_spacesuit_coeff = 3

oxygen_decrease_time = 5
local oxygen_timer = 0
minetest.register_globalstep(function(dtime)
    oxygen_timer = oxygen_timer + dtime
    for _, player in ipairs(minetest.get_connected_players()) do
        -- disables breath
        if player:get_breath() ~= 11 then
            player:set_breath(11)
        end

        local oxygen = 0
        local oxygen_max = 0

        local meta = player:get_meta("oxygen")
        if oxygen_timer > oxygen_decrease_time then
            oxygen_timer = 0

            local inv = player:get_inventory()
            local oxygen_stack = inv:get_list("oxygen")[1]

            if inv:contains_item("oxygen", { name = "default:oxygen_balloon" }) then
                local delta
                if meta:get_int("space_suit") > 0 then
                    delta = balloon_coeff
                else
                    delta = broken_spacesuit_coeff * balloon_coeff
                end

                local wear = oxygen_stack:get_wear()

                oxygen = (65536 - wear) / balloon_coeff
                oxygen_stack:set_wear(wear + delta)

                if wear + delta >= 65535 then
                    inv:set_stack("oxygen", 1, { name = "default:empty_balloon" })
                else
                    inv:set_stack("oxygen", 1, oxygen_stack)
                end

                oxygen_max = 65536 / balloon_coeff
            else
                oxygen = 0
            end
            
            local pos = player:get_pos()
            if get_gas(vector.add(vector.new(0, 1, 0), pos)) ~= "oxygen" and
               get_gas(pos) ~= "oxygen" and oxygen <= 0 then
                player:set_hp(player:get_hp() - 1)
            end

            meta:set_int("oxygen_max", oxygen_max)
            meta:set_int("oxygen", oxygen)
        end
    end
end)

bucket = {}
bucket.is_bucket = {}
bucket.liquids = {}

function bucket.register_liquid(source, flowing, itemname, inventory_image, description)
    bucket.liquids[source] = {
        source = source,
        flowing = flowing,
        itemname = itemname
    }
    bucket.liquids[flowing] = bucket.liquids[source]
    bucket.is_bucket[itemname] = true

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
                local n = minetest.get_node(pointed_thing.under)
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
        local liquiddef = bucket.liquids[n.name]
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

bucket.register_liquid(
    "default:potassium_hydroxide_source",
    "default:potassium_hydroxide_flowing",
    "default:bucket_potassium_hydroxide",
    "bucket_potassium_hydroxide.png",
    "Bucket with potassium hydroxide"
)

bucket.register_liquid(
    "default:trisilane_source",
    "default:trisilane_flowing",
    "default:bucket_trisilane",
    "bucket_trisilane.png",
    "Bucket with trisilane"
)

for _, name in ipairs(ores) do
    minetest.register_craftitem("default:" .. name .."_ingot", {
        description = name:gsub("^%l", string.upper) .. " ingot",
        inventory_image = "default_" .. name .. "_ingot.png",
    })
end