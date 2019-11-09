local optimal = {
    I = { min = 0.5, max = 50 },
    U = { min = 30, max = 300 },
}

local conf = {
    name = "electric",
    description = "Electric furnace",
    lists = { },
    on_tick = { and_then(reset_consumer("furnace:electric"), const(true)) },
    on_destruct = and_then(reset_current, drop_everything),
    is_furnace_ready = function(pos)
        return minetest.get_meta(pos):get_int("active") == 1
    end,
    additional_formspec = function(meta)
        return "label[1,2;Electric furnace]"
    end,
    textures = {
        inactive = {
            "furnace_side.png", "furnace_side.png",
            "furnace_side.png", "furnace_side.png",
            "furnace_electric_back.png", "furnace_electric_front.png",
        },
        active = {
            "furnace_side.png", "furnace_side.png",
            "furnace_side.png", "furnace_side.png",
            "furnace_electric_back.png", "furnace_electric_front_active.png",
        }
    },
    light_source = 6,
    groups = { cracky = 2, conductor = 1 },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_float("resis", 50)
    end,
    on_destruct = reset_current,

    crafts = furnace_crafts,
}

consumer["furnace:electric"] = {
    on_activate = function(pos) run_furnace(conf, pos) end,
    on_deactivate = function(pos) stop_furnace(conf, pos) end,
    current = optimal,
}

register_furnace(conf)
model["furnace:electric"] = resistor
model["furnace:electric_active"] = resistor