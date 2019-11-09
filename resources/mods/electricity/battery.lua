local battery_box_formspec =
    "size[8,6.5]" ..
    "label[0,0.75;Battery box]" ..
    "list[context;box;1.5,0.5;6,1;]" ..
    "list[current_player;main;0,2;8,1;]" ..
    "list[current_player;main;0,3.5;8,3;8]"

minetest.register_node("electricity:battery_box", {
    description = "Battery box",
    tiles = {
        "electricity_battery_top.png",
        "electricity_battery_bottom.png",
        "electricity_battery_side.png",
        "electricity_battery_side.png",
        "electricity_battery_connect_side.png",
        "electricity_battery_connect_side.png"
    },
    drop = 'electricity:battery_box',
    paramtype2 = "facedir",

    groups = { crumbly = 3, source = 1 },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("box", 6)
        meta:set_float("resis", 0.4)

        meta:set_string("formspec", battery_box_formspec)
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if minetest.get_item_group(stack:get_name(), "item_source") > 0 then
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
            if minetest.get_item_group(stack:get_name(), "item_source") > 0 then
                return stack:get_count()
            else
                return 0
            end
        else
            return stack:get_count()
        end
    end,

    on_destruct = andthen(reset_current, drop_everything),
})

local k = 5
on_circuit_tick["electricity:battery_box"] = function(meta, elapsed)
    local inv = meta:get_inventory()

    local I = math.abs(meta:get_float("I"))
    local U = math.abs(meta:get_float("U"))

    local emf = 0
    local wear = k * I * U * elapsed

    for idx, stack in ipairs(inv:get_list("box")) do
        local stack_emf = minetest.get_item_group(stack:get_name(), "item_source")
        if stack_emf > 0 then
            emf = emf + (65536 - stack:get_wear()) * (stack_emf / 65536)

            if stack:get_wear() + wear >= 65535 then
                stack:set_wear(65535)
            else
                stack:add_wear(wear)
            end
            inv:set_stack("box", idx, stack)
        end
    end

    meta:set_float("emf", emf)
end
model["electricity:battery_box"] = dc_source