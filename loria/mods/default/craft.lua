inv_crafts = {
    {
        input = {
            { name = "default:purpura", count = 3 },
            { name = "default:bucket_mercury", count = 1 },
        },
        output = {
            { name = "default:glow_stick", count = 1 },
            { name = "default:bucket_empty", count = 1 }
        }
    },
    {
        input = {
            { name = "default:naga", count = 2 },
            { name = "default:bucket_mercury", count = 1 },
        },
        output = {
            { name = "default:glow_stick", count = 1 },
            { name = "default:bucket_empty", count = 1 }
        }
    },
    {
        input = {
            { name = "default:potassium_ingot", count = 2 },
            { name = "default:bucket_water", count = 2 },
            { name = "default:empty_balloon", count = 1 }
        },
        output = {
            { name = "default:bucket_potassium_hydroxide", count = 2 },
            { name = "default:hydrogen_balloon", count = 2 },
        }
    },
    {
        input = {
            { name = "default:broken_drill", count = 1 },
            { name = "default:battery", count = 1 }
        },
        output = {
            { name = "default:drill", count = 1 }
        }
    },
    {
        input = {
            { name = "default:uranium_tetrachloride", count = 1 },
            { name = "default:potassium_ingot", count = 1 },
        },
        output = {
            { name = "default:uranium", count = 1 },
            { name = "default:potassium_chloride", count = 4 },
        }
    },
    {
        input = {
            { name = "default:lead", count = 4 },
        },
        output = {
            { name = "default:lead_case", count = 1 },
        }
    },
    {
        input = {
            { name = "default:lead_case", count = 1 },
            { name = "default:lead", count = 3 }
        },
        output = {
            { name = "furnace:gas", count = 1 },
        }
    },
    {
        input = {
            { name = "default:lead_case", count = 1 },
            { name = "default:lead", count = 1 }
        },
        output = {
            { name = "default:lead_box", count = 1 },
        }
    },
}

function check_craft(craft, inv)
    for _, reagent in ipairs(craft.input) do
        if not inv:contains_item("input", reagent) then
            return false
        end
    end
    return true
end

function get_craft(crafts, inv)
    for _, craft in ipairs(crafts) do
        if check_craft(craft, inv) then
            return craft
        end
    end
end

function update_preview(player)
    local inv = player:get_inventory()
    local recipe = get_craft(inv_crafts, inv)

    -- clear first
    inv:set_list("output", {})

    if recipe ~= nil then
        for _, result in ipairs(recipe.output) do
            inv:add_item("output", result)
        end
    end
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if fields.craft_it == "Craft" then
        local inv = player:get_inventory()
        local recipe = get_craft(inv_crafts, inv)
        local pos = player:get_pos()

        if recipe ~= nil then
            for _, reagent in ipairs(recipe.input) do
                inv:remove_item("input", reagent)
            end

            for _, result in ipairs(recipe.output) do
                if inv:room_for_item("main", result) then
                    inv:add_item("main", result)
                else
                    minetest.add_item(pos, result)
                end
            end
        end
    end

    update_preview(player)
end)

minetest.register_on_player_inventory_action(function(player, action, inventory, inventory_info)
    update_preview(player)
end)

minetest.register_allow_player_inventory_action(function(player, action, inventory, inventory_info)
    if action == 'move' then
        local inv = player:get_inventory()
        local stack = inv:get_stack(
            inventory_info.from_list,
            inventory_info.from_index
        )

        if inventory_info.from_list == "output" then
            return 0
        elseif inventory_info.from_list == "creative_inv" then
            stack:set_count(stack:get_count() + inventory_info.count)
            inv:set_stack("creative_inv", inventory_info.from_index, stack)
        end

        if inventory_info.to_list == "oxygen" then
            if stack:get_name() == "default:oxygen_balloon" then
                return stack:get_count()
            else
                return 0
            end
        elseif inventory_info.to_list == "output" or
               inventory_info.to_list == "creative_inv" then
            return 0
        else
            return stack:get_count()
        end
    elseif action == 'put' then
        if inventory_info.listname == "oxygen" then
            if inventory_info.stack:get_name() == "default:oxygen_balloon" then
                return inventory_info.stack:get_count()
            else
                return 0
            end
        elseif inventory_info.listname == "output" or
               inventory_info.listname == "creative_inv" then
            return 0
        else
            return inventory_info.stack:get_count()
        end
    else
        -- take
        if inventory_info.listname == "output" then
            return 0
        else
            return inventory_info.stack:get_count()
        end
    end
end)