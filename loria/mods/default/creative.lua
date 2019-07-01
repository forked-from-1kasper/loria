local creative = minetest.settings:get_bool("creative_mode")

function player_formspec()
    local str =
        "size[9,10.5]"..
        "label[0,0.5;Oxygen]"..
        "list[context;oxygen;0,1;1,1;]"..
        "label[0,2.5;Drugs]"..
        "list[context;antiradiation;0,3;1,1;]"..
        "label[2,0.5;Input]"..
        "image[5,2;1,1;gui_arrow.png^[transformR270]"..
        "button[5,3;1,1;craft_it;Craft]"..
        "list[context;input;2,1;3,3;]"..
        "label[6,0.5;Output]"..
        "list[context;output;6,1;3,3;]"..
        "list[context;main;0.5,6;8,1;]"..
        "list[context;main;0.5,7.5;8,3;8]"

    if creative then
        str = str .. "button[3.5,4.5;2,1;go_to_creative;Creative]"
    end
    return str
end

local creative_formspec_width = 8
local creative_formspec_height = 4

local creative_inv = { }

local shift_min = 1
local shift_max

minetest.register_on_mods_loaded(function()
    for name, params in pairs(minetest.registered_items) do
        if not params.groups.not_in_creative_inventory then
            table.insert(creative_inv, name)
        end
    end

    shift_max = (
        math.floor(#creative_inv / creative_formspec_width) -
        creative_formspec_height + 1
    ) * creative_formspec_width
end)

function creative_formspec(shift)
    return
        "size[9,10.5]"..
        "list[context;creative_inv;0.5,0.5;" ..
        creative_formspec_width .. "," ..
        creative_formspec_height .. ";".. shift .. "]"..
        "button[2.5,4.5;1,1;creative_up;Up]"..
        "button[5.5,4.5;1,1;creative_down;Down]"..
        "button[3.5,4.5;2,1;go_to_survival;Survival]"..
        "list[context;main;0.5,6;8,1;]"..
        "list[context;main;0.5,7.5;8,3;8]"
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    local inv = player:get_inventory()
    local meta = player:get_meta()

    if fields.go_to_creative then
        player:set_inventory_formspec(creative_formspec(meta:get_int("creative_shift")))
    elseif fields.go_to_survival then
        player:set_inventory_formspec(player_formspec())
    elseif fields.creative_down then
        local shift = meta:get_int("creative_shift")
        shift = shift + 8

        if shift > shift_max then
            shift = shift_max
        end

        meta:set_int("creative_shift", shift)
        player:set_inventory_formspec(creative_formspec(shift))
    elseif fields.creative_up then
        local shift = meta:get_int("creative_shift")
        shift = shift - 8
        if shift < shift_min then
            shift = shift_min
        end

        meta:set_int("creative_shift", shift)
        player:set_inventory_formspec(creative_formspec(shift))
    end

    inv:set_list("creative_inv", creative_inv)
end)

local creative_privs = { "fly", "fast", "give", "noclip", "settime", "teleport" }

minetest.register_on_joinplayer(function(player)
    local meta = player:get_meta()
    local inv = player:get_inventory()
    local name = player:get_player_name()

    meta:set_int("creative_shift", 1)
    inv:set_size("creative_inv", #creative_inv)
    inv:set_list("creative_inv", creative_inv)

    player:set_inventory_formspec(player_formspec())

    local privs = minetest.get_player_privs(name)

    for _, priv in ipairs(creative_privs) do
        privs[priv] = creative or nil
    end
    minetest.set_player_privs(name, privs)
end)