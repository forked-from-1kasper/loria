source = {}
quadripole = {}
consumer = {}
model = { }

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
    reset_circuits(pos, already_processed)
end

function reset_consumer(name)
    return (function(pos)
        local meta = minetest.get_meta(pos)
        local consumer = consumer[name]

        if not check_current(meta, consumer) and consumer.on_deactivate then
            consumer.on_deactivate(pos)
            meta:set_int("active", 0)
        end
    end)
end

neighbors = {
    vector.new( 1,  0,  0),
    vector.new(-1,  0,  0),
    vector.new( 0,  0,  1),
    vector.new( 0,  0, -1),
    vector.new( 0,  1,  0),
    vector.new( 0, -1,  0)
}