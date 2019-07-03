source = {}
quadripole = {}

cable_tick = 0.1

function set_resis(resis)
    return (function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_float("resis", resis)
    end)
end

function reset_current(pos)
    local already_processed = {}
    already_processed[serialize_pos(pos)] = true
    find_circuits(pos, { }, already_processed)
end
