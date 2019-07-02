source = {}
quadripole = {}

cable_tick = 0.1

function run_timer(resis)
    return (function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_float("resis", resis)

        minetest.get_node_timer(pos):start(cable_tick)
    end)
end

function reset_current(pos, elapsed)
    local meta = minetest.get_meta(pos)
    local timeout = meta:get_float("electricity_timeout")

    if timeout <= elapsed then
        meta:set_float("I", 0)
        meta:set_float("U", 0)
        meta:set_float("electricity_timeout", 0)
    else
        meta:set_float("electricity_timeout", timeout - elapsed)
    end

    return true
end
