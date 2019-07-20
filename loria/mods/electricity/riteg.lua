riteg_box = {
    type = "fixed",
    fixed = {
        { -4/16, -1/2+3/16, -4/16, 4/16, 1/2, 4/16 },
        { -1/2, -1/2, -1/2, 1/2, -1/2+3/16, 1/2 },
    },
}

fuel = {
    ["default:plutonium_dioxide"] = 3,
    ["default:plutonium_tetrafluoride"] = 0.4,
    ["default:plutonium_trifluoride"] = 0.3,
    ["default:uranium"] = 0.5,
    ["default:uranium_tetrachloride"] = 0.1,
}

local riteg_formspec =
    "size[8,6.5]" ..
    "label[3.5,0;RITEG]" ..
    "list[context;place;3.5,0.5;1,1;]" ..
    "list[current_player;main;0,2;8,1;]"..
    "list[current_player;main;0,3.5;8,3;8]"

local function update_riteg(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local stack = inv:get_stack("place", 1)

    meta:set_float("emf", fuel[stack:get_name()] or 0)
end

minetest.register_node("electricity:riteg", {
    description = "RITEG",
    tiles = {
        "electricity_riteg_top.png",
        "electricity_riteg_bottom.png",
        "electricity_riteg_side.png",
        "electricity_riteg_side.png",
        "electricity_riteg_connect_side.png",
        "electricity_riteg_connect_side.png"
    },
    drop = 'electricity:riteg',
    groups = { crumbly = 3, source = 1 },
    paramtype2 = "facedir",

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        inv:set_size("place", 1)
        meta:set_float("resis", 0.4)

        meta:set_string("formspec", riteg_formspec)
    end,

    paramtype = "light",
    drawtype = "nodebox",
    node_box = riteg_box,
    selection_box = riteg_box,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local inv = minetest.get_meta(pos):get_inventory()
        if inv:get_stack(listname, index):get_count() == 1 then
            return 0
        else
            return 1
        end
    end,

    on_metadata_inventory_move = update_riteg,
    on_metadata_inventory_put = update_riteg,
    on_metadata_inventory_take = update_riteg,

    on_destruct = and_then(reset_current, drop_everything),
})

model["electricity:riteg"] = dc_source