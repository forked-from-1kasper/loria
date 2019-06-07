default = {}
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/gases.lua")
dofile(minetest.get_modpath("default").."/items.lua")
dofile(minetest.get_modpath("default").."/craft.lua")
dofile(minetest.get_modpath("default").."/furnace.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/mushrooms.lua")
dofile(minetest.get_modpath("default").."/radiation.lua")
dofile(minetest.get_modpath("default").."/hud.lua")
dofile(minetest.get_modpath("default").."/player.lua")

oxygen_hud = {}
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

player_api.register_model("player.b3d", {
    animation_speed = 30,
    textures = { "player.png" },
    animations = {
        stand = { x = 0, y = 79 },
        lay = { x = 162, y = 166 },
        walk = { x = 168, y = 187 },
        mine = { x = 189, y = 198 },
        walk_mine = { x = 200, y = 219 },
        sit = { x = 81, y = 160 }
    },
    collisionbox = { -0.3, 0.0, -0.3, 0.3, 1.7, 0.3 },
    stepheight = 0.6,
    eye_height = 1.47,
})

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

    player_api.set_model(player, "player.b3d")
    player:set_local_animation(
        { x = 0,   y = 79 },
        { x = 168, y = 187 },
        { x = 189, y = 198 },
        { x = 200, y = 219 },
        30
    )

    minetest.chat_send_player(name, "Welcome to Loria!")
end)

space_suit_strength = 20

minetest.register_on_player_hpchange(function(player, hp_change, reason)
    local meta = player:get_meta()
    local space_suit = meta:get_int("space_suit")

    if space_suit > 0 then
        if reason.type ~= "node_damage" then
            local new = space_suit + math.floor(hp_change / 2)
            if new > 0 then
                meta:set_int("space_suit", new)
            else
                meta:set_int("space_suit", 0)
            end
        end
        return 0
    else
        return hp_change
    end
end, true)

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
    meta:set_int("oxygen", 0)

    meta:set_float("radiation", 0)
    meta:set_float("received_dose", 0)
    meta:set_int("space_suit", space_suit_strength)
end)

minetest.register_on_respawnplayer(function(player)
    local meta = player:get_meta()

    meta:set_float("received_dose", 0)
    meta:set_int("space_suit", space_suit_strength)
end)

MAX_HEIGHT = 31000
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        if pos.y ~= -MAX_HEIGHT then
            local gravity = (MAX_HEIGHT / (player:get_pos().y + MAX_HEIGHT)) ^ 2
            player:set_physics_override({ gravity = gravity })
        else
            player:set_physics_override({ gravity = 1 })
        end
    end
end)