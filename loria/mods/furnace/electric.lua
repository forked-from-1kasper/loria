optimal = {
    I = { value = 5, delta = 2 },
    U = { value = 220, delta = 50 },
}

function is_furnace_ready(meta)
    local I = meta:get_float("I")
    local U = meta:get_float("U")

    return
        (I >= optimal.I.value - optimal.I.delta) and
        (I <= optimal.I.value + optimal.I.delta) and
        (U >= optimal.U.value - optimal.U.delta) and
        (U <= optimal.U.value + optimal.U.delta)
end

function check_current(pos, elapsed)
    reset_current(pos, elapsed)
    return is_furnace_ready(minetest.get_meta(pos))
end

register_furnace({
    name = "electric",
    description = "Electric furnace",
    lists = { },
    on_tick = { check_current },
    on_inactive_timer = reset_current,
    is_furnace_ready = function(pos)
        return is_furnace_ready(minetest.get_meta(pos))
    end,
    additional_formspec = function(meta)
        return string.format(
            "label[0,2;I = %f]"..
            "label[2,2;U = %f]",
            meta:get_float("I"),
            meta:get_float("U")
        )
    end,
    textures = {
        side = "furnace_side.png",
        front_inactive = "furnace_electric_front.png",
        front_active = "furnace_electric_front_active.png",
    },
    light_source = 6,
    groups = { cracky = 2, consumer = 1 },
})

consumer["furnace:electric"] = { resis = 50 }
consumer["furnace:electric_active"] = { resis = 50 }