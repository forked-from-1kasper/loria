default = {}
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/items.lua")
dofile(minetest.get_modpath("default").."/craft.lua")
dofile(minetest.get_modpath("default").."/furnace.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/mushrooms.lua")
dofile(minetest.get_modpath("default").."/radiation.lua")
dofile(minetest.get_modpath("default").."/hud.lua")

function player_formspec()
    return
        "size[9,9.5]"..
        "label[0,1.5;Oxygen]"..
        "list[context;oxygen;0,2;1,1;]"..
        "label[2,0.5;Input]"..
        "image[5,2;1,1;gui_arrow.png]"..
        "button[5,3;1,1;craft_it;Craft]"..
        "list[context;input;2,1;3,3;]"..
        "label[6,0.5;Output]"..
        "list[context;output;6,1;3,3;]"..
        "list[context;main;0.5,5;8,1;]"..
        "list[context;main;0.5,6.5;8,3;8]"
end

oxygen_hud = {}
minetest.register_on_joinplayer(function(player)
    local meta = player:get_meta()

    local name = player:get_player_name()
    player:hud_set_flags({ healthbar = false })
    oxygen_hud[name] = player:hud_add({
        hud_elem_type = "text",
        position = { x = 0, y = 0.9 },
        text = "N/A",
        number = 0xFFFFFF,
        alignment = "right",
        offset = { x = 150, y = 0 }
    })
    player:set_clouds({ density = 0 })
    player:set_inventory_formspec(player_formspec())

    minetest.chat_send_player(name, "Welcome to Loria!")
end)

START_ITEMS = {
    ["default:oxygen_balloon"] = 1,
    ["default:furnace"] = 1
}

function init_inv(player)
    local name = player:get_player_name()
    local inv = player:get_inventory()

    inv:set_size("oxygen", 1)
    inv:set_size("input", 9)
    inv:set_size("output", 9)

    inv:add_item("main", { name = "default:drill", count = 1 })

    inv:add_item("oxygen", { name = "default:oxygen_balloon" })

    for name, count in pairs(START_ITEMS) do
        inv:add_item("main", { name = name, count = count })
    end
end

minetest.register_on_newplayer(function(player)
    init_inv(player)

    local meta = player:get_meta()
    meta:set_int("oxygen", OXYGEN_MAX)

    meta:set_float("radiation", 0)
    meta:set_float("received_dose", 0)
end)

minetest.register_on_respawnplayer(function(player)
    local meta = player:get_meta()
    meta:set_int("oxygen", OXYGEN_MAX)
    meta:set_float("received_dose", 0)
end)

MAX_HEIGHT = 31000
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local gravity = (MAX_HEIGHT / (player:get_pos().y + MAX_HEIGHT)) ^ 2
        player:set_physics_override({ gravity = gravity })
    end
end)