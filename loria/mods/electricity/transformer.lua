local transformer_resis = 1

local transformer_box = {
    type = "fixed",
    fixed = {
        { -1/2, -1/2, -1/2, 1/2, -1/2+2/16, 1/2 },
        { -1/2+2/16, -1/2+2/16, -1/2+2/16, 1/2-2/16, 1/2-2/16, 1/2-2/16 },
        { -1/2, 1/2-2/16, -1/2, 1/2, 1/2, 1/2 },
    },
}

minetest.register_node("electricity:transformer", {
    description = "Transformer",
    tiles = {
        "electricity_transformer.png",
        "electricity_transformer.png",
        "electricity_transformer_side.png",
        "electricity_transformer_side.png",
        "electricity_transformer_side.png",
        "electricity_transformer_side.png",
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
quadripole["electricity:transformer"] = function(meta)
    local inv = meta:get_inventory()
    local prim_winding = inv:get_stack("primary", 1)
    local sec_winding = inv:get_stack("secondary", 1)

    local N1 = prim_winding:get_count()
    local N2 = sec_winding:get_count()

    if N1 == 0 or N2 == 0 or
       minetest.get_item_group(prim_winding:get_name(), "cable") == 0 or
       minetest.get_item_group(sec_winding:get_name(), "cable") == 0 then
        return const({ I = 0, U = 0 })
    else
        local n = N2 / N1
        return (function(I, U) return { I = I / n, U = U * n } end)
    end
    meta:set_float("resis", (N1 + N2 + 1) * transformer_resis)
end