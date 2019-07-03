minetest.register_tool("electricity:accumulator", {
    inventory_image = "electricity_accumulator.png",
    description = "Accumulator",
    groups = { item_source = 4, rechargeable = 1 },
})

local charger_box_resis = 0.1
local charge_speed = 500
local voltage_delta = 4
local charger_formspec =
    "size[8,6.5]" ..
    "label[3.5,0;Charger box]" ..
    "list[context;place;3.5,0.5;1,1;]" ..
    "list[current_player;main;0,2;8,1;]"..
    "list[current_player;main;0,3.5;8,3;8]"

minetest.register_node("electricity:charger_box", {
    description = "Charger box",
    tiles = {
        "electricity_charger_box.png",
        "electricity_charger_box.png",
        "electricity_charger_box_side.png",
        "electricity_charger_box_side.png",
        "electricity_charger_box_side.png",
        "electricity_charger_box_side.png",
    },
    drop = 'electricity:charger_box',
    groups = { cracky = 3, consumer = 1 },

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("place", 1)
        meta:set_string("formspec", charger_formspec)
        meta:set_float("resis", charger_box_resis)

        minetest.get_node_timer(pos):start(0.5)
    end,
    on_destruct = and_then(reset_current, drop_everything),
    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        local stack = inv:get_stack("place", 1)

        local name = stack:get_name()
        local emf = minetest.get_item_group(name, "item_source")

        if minetest.get_item_group(name, "rechargeable") > 0 and emf > 0 then
            local I = meta:get_float("I")
            local U = meta:get_float("U")

            local wear = stack:get_wear()
            local wear_delta = charge_speed * I * (U / emf) * elapsed
            
            if U >= (emf - voltage_delta) and
               U <= (emf + voltage_delta) then
                if wear > wear_delta then
                    stack:set_wear(wear - wear_delta)
                elseif wear >= 65536 then
                    stack:set_wear(65536)
                elseif wear <= wear_delta then
                    stack:set_wear(0)
                end
                inv:set_stack("place", 1, stack)
            end
        end

        return true
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local inv = minetest.get_meta(pos):get_inventory()
        if inv:get_stack(listname, index):get_count() == 1 then
            return 0
        else
            return 1
        end
    end,
})