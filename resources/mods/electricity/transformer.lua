local transformer_resis = 1

local transformer_box = {
    type = "fixed",
    fixed = {
        { -1/2, -1/2, -1/2, 1/2, -1/2+2/16, 1/2 },
        { -1/2+5/16, -1/2+2/16, -1/2+2/16, 1/2-5/16, -1/2+4/16, 1/2-2/16 },
        { -1/2+5/16, 1/2-4/16, -1/2+2/16, 1/2-5/16, 1/2-2/16, 1/2-2/16 },
        { -1/2+5/16, -1/2+4/16, -1/2+2/16, 1/2-5/16, 1/2-4/16, -1/2+4/16 },
        { -1/2+5/16, -1/2+4/16, 1/2-4/16, 1/2-5/16, 1/2-4/16, 1/2-2/16 },
        { -1/2+4/16, -1/2+5/16, -1/2+1/16, 1/2-4/16, 1/2-5/16, -1/2+5/16 },
        { -1/2+4/16, -1/2+5/16, 1/2-5/16, 1/2-4/16, 1/2-5/16, 1/2-1/16 },
    },
}

minetest.register_node("electricity:transformer", {
    description = "Transformer",
    tiles = {
        "electricity_transformer_top.png",
        "electricity_transformer.png",
        "electricity_transformer_side_primary.png",
        "electricity_transformer_side_secondary.png",
        "electricity_transformer_front_primary.png",
        "electricity_transformer_front_secondary.png",
    },
    drop = 'electricity:transformer',
    groups = { crumbly = 3, conductor = 1 },

    paramtype = "light",
    drawtype = "nodebox",
    node_box = transformer_box,
    selection_box = transformer_box,

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("primary", 1)
        inv:set_size("secondary", 1)

        meta:set_string("formspec",
            "size[8,6.5]" ..
            "label[2,0;Primary winding]" ..
            "list[context;primary;2,0.5;1,1;]" ..
            "label[5,0;Secondary winding]" ..
            "list[context;secondary;5,0.5;1,1;]" ..
            "list[current_player;main;0,2;8,1;]" ..
            "list[current_player;main;0,3.5;8,3;8]"
        )

        set_resis(transformer_resis)(pos)
    end,
    on_destruct = and_then(reset_current, drop_everything),

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if minetest.get_item_group(stack:get_name(), "cable") > 0 then
            return stack:get_count()
        else
            return 0
        end
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack(from_list, from_index)

        if to_list == "primary" or to_list == "secondary" then
            if minetest.get_item_group(stack:get_name(), "cable") > 0 then
                return stack:get_count()
            else
                return 0
            end
        else
            return stack:get_count()
        end
    end,
})

local function is_cable(name)
    return minetest.get_item_group(name, "cable") ~= 0
end

model["electricity:transformer"] = function(pos, id)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local prim_winding = inv:get_stack("primary", 1)
    local sec_winding = inv:get_stack("secondary", 1)

    local N1 = prim_winding:get_count()
    local N2 = sec_winding:get_count()

    local n = N2 / N1
    if N1 == 0 and N2 == 0 or
       (not is_cable(prim_winding:get_name())) or
       (not is_cable(sec_winding:get_name())) then
        return
    end

    local in_pin = vector.new(1, 0, 0)
    local out_pin = vector.new(0, 0, 1)

    local prim0 = vector.add(pos, in_pin)
    local prim1 = vector.add(pos, out_pin)

    local sec0 = vector.subtract(pos, in_pin)
    local sec1 = vector.subtract(pos, out_pin)

    return {
        table.concat({
            "l" .. id .. "primary",
            hash_node_connect(pos, prim0),
            hash_node_connect(pos, prim1),
            N1 ^ 2
        }, " "),
        table.concat({
            "l" .. id .. "secondary",
            hash_node_connect(pos, sec0),
            hash_node_connect(pos, sec1),
            N2 ^ 2
        }, " "),
        table.concat({
            "k" .. id,
            "l" .. id .. "primary",
            "l" .. id .. "secondary",
            0.999999
        }, " ")
    }, nil
end