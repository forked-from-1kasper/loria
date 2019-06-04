GASES_RADIUS = 8
GASES_UPDATE_TIME = 1

gases_minp = vector.new(-GASES_RADIUS, -GASES_RADIUS, -GASES_RADIUS)
gases_maxp = vector.new(GASES_RADIUS, GASES_RADIUS, GASES_RADIUS)

GASES = {
    ["default:chlorine"] = {
        color = 0xFFFF00
    },
}

neighbors = {
    vector.new( 1, 0, 0),
    vector.new(-1, 0, 0),
    vector.new( 0, 1, 0),
    vector.new( 0,-1, 0),
    vector.new( 0, 0, 1),
    vector.new( 0, 0,-1)
}

function get_neighbors(pos)
    local res = {}
    for _, v in ipairs(neighbors) do
        table.insert(res, vector.add(pos, v))
    end
    return res
end

function get_gases(pos)
    local res = {}
    local meta = minetest.get_meta(pos)
    for name, _ in pairs(GASES) do
        local value = meta:get_float(name)
        if value ~= 0 then
            table.insert(res, { name = name, value = value })
        end
    end

    return res
end

function update_gases(pos)
    local meta = minetest.get_meta(pos)
    for name, conf in pairs(GASES) do
        local quantity = meta:get_float(name)

        if quantity ~= 0 then
            local value = 1
            local metas = { }
            for _, v in ipairs(get_neighbors(pos)) do
                if minetest.get_node(v).name == "air" then
                    value = value + 1
                    table.insert(metas, minetest.get_meta(v))
                end
            end

            local q = quantity / value
            meta:set_float(name, q)
            for _, m in ipairs(metas) do
                m:set_float(name, m:get_float(name) + q)
            end
        end
    end
end

local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer > GASES_UPDATE_TIME then
        timer = 0

        local vm = minetest.get_voxel_manip()

        for _, player in ipairs(minetest.get_connected_players()) do
            local pos = player:get_pos()

            local minp, maxp = vector.add(pos, gases_minp), vector.add(pos, gases_maxp)

            for x = minp.x, maxp.x do
                for y = minp.y, maxp.y do
                    for z = minp.z, maxp.z do
                        local pos = vector.new(x, y, z)
                        if minetest.get_node(pos).name == "air" then
                            update_gases(pos)
                        end
                    end
                end
            end
        end
    end
end)

minetest.register_abm({
    label = "Chlorine source",
    nodenames = { "default:test" },
    interval = 1,
    chance = 0.1,
    action = function(pos)
        pos = vector.add(pos, vector.new(0, 1, 0))
        if minetest.get_node(pos).name == "air" then
            meta = minetest.get_meta(pos)
            meta:set_float("default:chlorine", meta:get_float("default:chlorine") + 1)
        end
    end
})

-- HUD

--function gases(player)
--    local res = {}
--
--    local pos = vector.round(player:get_pos())
--
--    for _, item in ipairs(get_gases(pos)) do
--        if item.value > 0.001 then
--            table.insert(res, item.name .. " : " .. tostring(item.value))
--        end
--    end
--
--    return "Gases: " .. table.concat(res, ", ")
--end