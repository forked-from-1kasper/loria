local function battery_box_formspec(P, emf)
    return string.format(
        "size[8,6.5]" ..
        "label[0,0;Battery box]" ..
        "label[0,0.5;P = %f]" ..
        "label[0,1;ε = %f]" ..
        "list[context;box;1.5,0.5;6,1;]" ..
        "list[current_player;main;0,2;8,1;]"..
        "list[current_player;main;0,3.5;8,3;8]",
        P, emf
    )
end

minetest.register_node("electricity:battery", {
    description = "Battery box",
    tiles = {
        "electricity_battery_top.png",
        "electricity_battery_bottom.png",
        "electricity_battery_side.png",
        "electricity_battery_side.png",
        "electricity_battery_side.png",
        "electricity_battery_side.png"
    },
    drop = 'electricity:battery',
    groups = { crumbly = 3, source = 1 },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("box", 6)
        meta:set_float("resis", 0.4)
        meta:set_float("emf", 25)

        meta:set_string("formspec", battery_box_formspec(0, 0))
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if stack:get_name() == "default:battery" then
            return stack:get_count()
        else
            return 0
        end
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack(from_list, from_index)

        if to_list == "box" then
            if stack:get_name() == "default:battery" then
                return stack:get_count()
            else
                return 0
            end
        else
            return stack:get_count()
        end
    end,

    on_destruct = drop_everything,
})
source["electricity:battery"] = function(meta, P, R, emf, elapsed)
    local inv = meta:get_inventory()

    meta:set_string("formspec", battery_box_formspec(P, emf))

    local emf = 0
    local wear = 5 * P * elapsed
    for idx, stack in ipairs(inv:get_list("box")) do
        if stack:get_name() == "default:battery" then
            emf = emf + (65536 - stack:get_wear()) * 5 / 65536

            if stack:get_wear() + wear >= 65535 then
                stack:set_name("default:aluminium_case")
                stack:set_wear(0)
            else
                stack:add_wear(wear)
            end
            inv:set_stack("box", idx, stack)
        end
    end

    return emf
end