default = {}
dofile(minetest.get_modpath("default").."/prelude.lua")
dofile(minetest.get_modpath("default").."/conf.lua")
dofile(minetest.get_modpath("default").."/inv_crafts.lua")
dofile(minetest.get_modpath("default").."/creative.lua")
dofile(minetest.get_modpath("default").."/biomes.lua")
dofile(minetest.get_modpath("default").."/ores.lua")
dofile(minetest.get_modpath("default").."/mushrooms_nodes.lua")
dofile(minetest.get_modpath("default").."/small_mushrooms.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/liquids.lua")
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/gases.lua")
dofile(minetest.get_modpath("default").."/items.lua")
dofile(minetest.get_modpath("default").."/craft.lua")
dofile(minetest.get_modpath("default").."/mushrooms.lua")
dofile(minetest.get_modpath("default").."/hud.lua")
dofile(minetest.get_modpath("default").."/sky.lua")
dofile(minetest.get_modpath("default").."/player.lua")

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
    if reason.type == "set_hp" then
        return hp_change
    end

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
    ["furnace:refiner_item"] = 1,
    ["default:oxygen_balloon"] = 1,
    ["default:empty_balloon"] = 1,
    ["default:bucket_empty"] = 2,
}

function init_inv(player)
    local name = player:get_player_name()
    local inv = player:get_inventory()

    inv:set_size("oxygen", 1)
    inv:set_size("antiradiation", 1)
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
    meta:set_float("dose_damage_limit", 1)

    meta:set_int("space_suit", space_suit_strength)
end)

minetest.register_on_respawnplayer(function(player)
    local meta = player:get_meta()

    player:set_hp(20)

    meta:set_float("received_dose", 0)
    meta:set_float("dose_damage_limit", 1)

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

local clear_radius = 500
minetest.register_chatcommand("clearitems", {
    params = "",
    description = "Deletes all items in " .. clear_radius .. " meters",
    privs = {},
    func = function(name)
        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()

            local objs = minetest.get_objects_inside_radius(pos, clear_radius)
            for _, obj in pairs(objs) do
                local name = player:get_player_name()
                local entity = obj:get_luaentity()
                if entity and entity.name == "__builtin:item" then
                    obj:remove()
                end
            end
        end
    end,
})