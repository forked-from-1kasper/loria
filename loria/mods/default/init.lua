default = {}
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/items.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/mushrooms.lua")
dofile(minetest.get_modpath("default").."/hud.lua")

hud_pos = { x = 100, y = 600 }
oxygen_hud = {}
minetest.register_on_joinplayer(function(player)
    local meta = player:get_meta()
    if meta:get_int("oxygen") == 0 then
        meta:set_int("oxygen", OXYGEN_MAX)
    end

    local name = player:get_player_name()
    player:hud_set_flags({ healthbar = false })
    oxygen_hud[name] = player:hud_add({
        hud_elem_type = "text",
        position = { x = 0, y = 0 },
        text = "N/A",
        number = 0xFFFFFF,
        alignment = "right",
        offset = hud_pos
    })

    minetest.chat_send_player(name, "Welcome to Loria!")
end)

minetest.register_on_respawnplayer(function(player)
    local meta = player:get_meta()
    meta:set_int("oxygen", OXYGEN_MAX)
end)

MAX_HEIGHT = 31000
minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local gravity = (MAX_HEIGHT / (player:get_pos().y + MAX_HEIGHT)) ^ 2
        player:set_physics_override({ gravity = gravity })
    end
end)

OXYGEN_MAX = 255
OXYGEN_DECREASE_TIME = 5

local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    for _, player in ipairs(minetest.get_connected_players()) do
        -- disables breath
        if player:get_breath() ~= 11 then
            player:set_breath(11)
        end

        local meta = player:get_meta("oxygen")
        local oxygen = meta:get_int("oxygen")

        if timer > OXYGEN_DECREASE_TIME then
            timer = 0
            if oxygen > 0 then
                oxygen = oxygen - 1
            else
                player:set_hp(player:get_hp() - 1)
            end
        end
        if oxygen > OXYGEN_MAX then
            meta:set_int("oxygen", OXYGEN_MAX)
            oxygen = OXYGEN_MAX
        end
        meta:set_int("oxygen", oxygen)
    end
end)