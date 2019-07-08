optimal = {
    I = { min = 0.5, max = 50 },
    U = { min = 30, max = 300 },
}

conf = {
    name = "electric",
    description = "Electric furnace",
    lists = { },
    on_tick = { and_then(const(true), reset_consumer("furnace:electric")) },
    on_destruct = and_then(reset_current, drop_everything),
    is_furnace_ready = function(pos)
        return minetest.get_meta(pos):get_int("active") == 1
    end,
    additional_formspec = function(meta)
        return "label[1,2;Electric furnace]"
    end,
    textures = {
        side = "furnace_side.png",
        back = "furnace_electric_back.png",
        front_inactive = "furnace_electric_front.png",
        front_active = "furnace_electric_front_active.png",
    },
    light_source = 6,
    groups = { cracky = 2, conductor = 1 },
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_float("resis", 50)
    end,
    on_destruct = reset_current,
}

consumer["furnace:electric"] = {
    on_activate = function(pos) run_furnace(conf, pos) end,
    on_deactivate = function(pos) stop_furnace(conf, pos) end,
    current = optimal,
}

--consumer["furnace:electric_active"] = {
--    on_deactivate = function(pos) stop_furnace(conf, pos) end,
--    current = optimal,
--}

register_furnace(conf)
model["furnace:electric"] = resistor
model["furnace:electric_active"] = resistor