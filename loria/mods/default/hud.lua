function health(player)
    return "Health: "..player:get_hp()
end

function oxygen(player)
    local meta = player:get_meta()
    return "Oxygen: "..(meta:get_int("oxygen") - 1).."/"..(OXYGEN_MAX - 1)
end

function gravity(player)
    local gravity = player:get_physics_override().gravity * 100
    return string.format("Gravity: %.4f %%", gravity)
end

function radiation(player)
    local meta = player:get_meta()
    return string.format(
        "Radiation: %.3f CU/h",
        meta:get_float("radiation")
    ) .. "\n" .. string.format(
        "Received dose: %.3f CU",
        meta:get_float("received_dose")
    )
end

function copyright(player)
    return table.concat({
        "",
        "Just Another Space Suit v15.0",
        "© 2073—2081 Skolkovo"
    }, "\n")
end

hud_elems = { health, oxygen, gravity, radiation, copyright }

minetest.register_globalstep(function(dtime)
    for _, player in ipairs(minetest.get_connected_players()) do
        local text = ""
        for _, func in ipairs(hud_elems) do
            text = text .. "\n" .. func(player)
        end

        local hud = oxygen_hud[player:get_player_name()]
        player:hud_change(hud, "text", text)
    end
end)