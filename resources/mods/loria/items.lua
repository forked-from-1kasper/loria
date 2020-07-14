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

minetest.register_craftitem("loria:broken_drill", {
    description = "Broken drill",
    inventory_image = "loria_broken_drill.png",
})

minetest.register_tool("loria:drill", {
    description = "Drill",
    stack_max = 1,
    liquids_pointable = false,
    range = 5.0,
    inventory_image = "loria_drill.png",
    wield_image = "loria_drill.png",
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            cracky = {
                times = { [1] = 2.00, [2] = 0.50, [3] = 0.30 },
                uses = 500
            },
            choppy = {
                times = { [1] = 1.00, [2] = 0.50, [3] = 0.20 },
                uses = 560
            },
            crumbly = {
                times = { [1] = 0.50, [2] = 0.30, [3] = 0.10 },
                uses = 600
            },
            oddly_breakable_by_hand = {
                times = { [1] = 0.50, [2] = 0.30, [3] = 0.10 }
            }
        },
        damage_groups = { fleshy = 2 }
    },
    after_use = function(itemstack, user, node, digparams)
        if itemstack:get_wear() + digparams.wear >= 65535 then
            return { name = "loria:broken_drill", count = 1 }
        else
            itemstack:add_wear(digparams.wear)
            return itemstack
        end
    end
})

minetest.register_craftitem("loria:super_drill", {
    description = "Super drill",
    stack_max = 1,
    liquids_pointable = false,
    range = 5.0,
    inventory_image = "loria_super_drill.png",
    wield_image = "loria_super_drill.png",
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

minetest.register_tool("loria:copper_hammer", {
    inventory_image = "loria_copper_hammer.png",
    description = "Copper hammer",
    stack_max = 1,
    liquids_pointable = false,
    range = 2.0,
    damage_groups = { fleshy = 1 },
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            cracky = {
                times = { [1] = 5, [2] = 0.9, [3] = 0.3 },
                uses = 10
            },
            crumbly = {
                times = { [1] = 7, [2] = 5, [3] = 2 },
                uses = 100
            }
        },
        damage_groups = { fleshy = 2 }
    },

    after_use = function(itemstack, user, node, digparams)
        if brickable[node.name] ~= nil then
            local inv = user:get_inventory()
            add_or_drop(
                inv, "main", { name = node.name .. "_brick", count = 1 },
                vector.add(user:get_pos(), vector.new(0, 1, 0))
            )
            inv:remove_item("main", { name = node.name, count = 1 })
        end

        if itemstack:get_wear() + digparams.wear >= 65535 then
            return { name = "loria:stick", count = 1 }
        else
            itemstack:add_wear(digparams.wear)
            return itemstack
        end
    end
})

minetest.register_tool("loria:copper_hammer_head", {
    inventory_image = "loria_copper_hammer_head.png",
    description = "Copper hammer head",
    stack_max = 1,
    liquids_pointable = false,
    range = 1.0,
    damage_groups = { fleshy = 2 },
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 1,
        groupcaps = {
            cracky = {
                times = { [1] = 6, [2] = 1.2, [3] = 0.5 },
                uses = 9
            },
            crumbly = {
                times = { [1] = 15, [2] = 10, [3] = 4 },
                uses = 90
            }
        },
        damage_groups = { fleshy = 2 }
    },
    after_use = function(itemstack, user, node, digparams)
        if itemstack:get_wear() + digparams.wear >= 65535 then
            return
        else
            itemstack:add_wear(digparams.wear)
            return itemstack
        end
    end
})

minetest.register_tool("loria:nail_file", {
    inventory_image = "loria_nail_file.png",
    description = "Nail file",
    stack_max = 1,
    on_use = function(itemstack, user, pointed_thing)
        itemstack:set_name("loria:broken_nail_file")
        return itemstack
    end
})

minetest.register_tool("loria:broken_nail_file", {
    inventory_image = "loria_broken_nail_file.png",
    description = "Broken nail file",
    stack_max = 1,
    range = 0,
    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            snappy = { times = {100, 60, 30}, uses = 5 },
        }
    },
})

minetest.register_tool("loria:battery", {
    inventory_image = "loria_battery.png",
    description = "Battery",
    groups = { item_source = 5 },
})

minetest.register_craftitem("loria:stick", {
    inventory_image = "loria_stick.png",
    description = "Stick",
    stack_max = 120,
})

minetest.register_craftitem("loria:aluminium_brick_mold", {
    inventory_image = "loria_aluminium_brick_mold.png",
    description = "Aluminium brick mold",
    stack_max = 9,
})

minetest.register_craftitem("loria:aluminium_case", {
    inventory_image = "loria_aluminium_case.png",
    description = "Aluminium case",
    stack_max = 16,
})

minetest.register_craftitem("loria:wolfram_filament", {
    inventory_image = "loria_wolfram_filament.png",
    description = "Wolfram filament",
    stack_max = 30,
})

minetest.register_craftitem("loria:empty_balloon", {
    inventory_image = "loria_empty_balloon.png",
    description = "Empty balloon",
    stack_max = 1
})

minetest.register_craftitem("loria:thorium_ingot", {
    description = "Thorium ingot",
    inventory_image = "loria_thorium_ingot.png",
})

minetest.register_craftitem("loria:uranium_ingot", {
    description = "Uranium ingot",
    inventory_image = "loria_uranium_ingot.png",
})

minetest.register_craftitem("loria:plutonium_ingot", {
    description = "Plutonium ingot",
    inventory_image = "loria_plutonium_ingot.png",
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

        if oxygen_timer > oxygen_decrease_time then
            local meta = player:get_meta("oxygen")
            oxygen_timer = 0

            local inv = player:get_inventory()
            local oxygen_stack = inv:get_list("oxygen")[1]

            if inv:contains_item("oxygen", { name = "loria:oxygen_balloon" }) then
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
                    inv:set_stack("oxygen", 1, { name = "loria:empty_balloon" })
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