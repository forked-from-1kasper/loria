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