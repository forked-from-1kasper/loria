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
}

function get_craft(crafts, inv)
    for _, craft in ipairs(crafts) do
        local checked = true
        for _, reagent in ipairs(craft.input) do
            checked = checked and inv:contains_item("input", reagent)
        end

        if checked then
            return craft
        end
    end
end

function update_preview(player)
    local inv = player:get_inventory()
    local recipe = get_craft(inv_crafts, inv)

    -- clear first
    for i = 1, #inv:get_list("output") do
        inv:set_stack("output", i, {})
    end

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
    return true
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
        end

        if inventory_info.to_list == "oxygen" then
            if stack:get_name() == "default:oxygen_balloon" then
                return stack:get_count()
            else
                return 0
            end
        elseif inventory_info.to_list == "output" then
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
        elseif inventory_info.listname == "output" then
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