local c_air = minetest.get_content_id("air")
local c_copper_sulfate = minetest.get_content_id("default:copper_sulfate")
local c_stem = minetest.get_content_id("default:viridi_petasum_stem")
local c_body = minetest.get_content_id("default:viridi_petasum_body")

viridi_petasum = {
    min_height = 7,
    max_height = 30,
    min_radius = 3
}

function generate_viridi_petasum(x, y, z, g, data, area)
    local height = g:next(viridi_petasum.min_height, viridi_petasum.max_height)
    local radius = g:next(viridi_petasum.min_radius, math.floor(height / 2))

    if not (area:contains(x - radius, y, z - radius)) or
       not (area:contains(x + radius, y + height, z + radius)) then
        return
    end

    -- stem
    for k = 1, height do
        data[area:index(x, y + k, z)] = c_stem
    end

    -- body
    local t = 0
    while t < 2 * math.pi do
        for k = 1, radius do
            local delta_x = math.floor(k * math.cos(t))
            local delta_z = math.floor(k * math.sin(t))

            data[area:index(x + delta_x, y + height, z + delta_z)] = c_body
        end

        t = t + 0.4
    end
end

minetest.register_on_generated(function(minp0, maxp0, seed)
    local height_min = 0
    local height_max = 31000
    
    local vm = minetest.get_voxel_manip()
    local minp, maxp = vm:read_from_map(minp0, maxp0)

    if maxp.y < height_min or minp.y > height_max then
        return
    end

    local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
    local data = vm:get_data()

    local y_min = math.max(minp.y, height_min)
    local y_max = math.min(maxp.y, height_max)

    local perlin1 = minetest.get_perlin(230, 3, 0.6, 100)
    local divlen = 8
    local divs = (maxp.x - minp.x) / divlen + 1

    local g = PseudoRandom(seed + 1)
    for divx = 0, (divs - 1) do
        for divz = 0, (divs - 1) do
            local x0 = minp.x + math.floor((divx + 0) * divlen)
            local z0 = minp.z + math.floor((divz + 0) * divlen)
            local x1 = minp.x + math.floor((divx + 1) * divlen)
            local z1 = minp.z + math.floor((divz + 1) * divlen)

            local amount = math.floor(perlin1:get2d({x = x0, y = z0}))
            for i = 0, amount do
                local x = g:next(x0, x1)
                local z = g:next(z0, z1)

                local ground_y = nil
                for y = y_max, y_min, -1 do
                    if data[area:index(x, y, z)] ~= c_air then
                        ground_y = y
                        break
                    end
                end

                if ground_y then
                    local ground = data[area:index(x, ground_y, z)]
                    if ground == c_copper_sulfate or ground == c_body then
                        generate_viridi_petasum(x, ground_y, z, g, data, area)
                    end
                end
            end
        end
    end

    vm:set_data(data)
    vm:write_to_map()
    vm:update_map()
end)