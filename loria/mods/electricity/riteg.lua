riteg_box = {
    type = "fixed",
    fixed = {
        { -4/16, -1/2+3/16, -4/16, 4/16, 1/2, 4/16 },
        { -1/2, -1/2, -1/2, 1/2, -1/2+3/16, 1/2 },
    },
}

local function riteg_formspec(P, emf)
    return
        "size[8,6.5]" ..
        "label[3.5,0;RITEG]" ..
        "list[context;place;3.5,0.5;1,1;]" ..
        "list[current_player;main;0,2;8,1;]"..
        "list[current_player;main;0,3.5;8,3;8]"
end

minetest.register_node("electricity:riteg", {
    description = "RITEG",
    tiles = {
        "electricity_riteg_top.png",
        "electricity_riteg_bottom.png",
        "electricity_riteg_side.png",
        "electricity_riteg_side.png",
        "electricity_riteg_side.png",
        "electricity_riteg_side.png"
    },
    drop = 'electricity:riteg',
    groups = { crumbly = 3, source = 1 },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("place", 1)
        meta:set_float("resis", 0.4)

        meta:set_string("formspec", riteg_formspec(0, 0))
    end,

    paramtype = "light",
    drawtype = "nodebox",
    node_box = riteg_box,
    selection_box = riteg_box,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        return 1
    end,

    on_destruct = drop_everything,
})

local k = 3 / 20
source["electricity:riteg"] = function(meta, P, R, emf, elapsed)
    local inv = meta:get_inventory()
    local stack = inv:get_stack("place", 1)
    local A = activity[minetest.get_content_id(stack:get_name())] or 0

    return k * A
end