local tau = 2 * math.pi

local c_air = core.get_content_id("air")
local c_copper_sulfate = core.get_content_id("loria:copper_sulfate")

local c_viridi_stem = core.get_content_id("loria:viridi_petasum_stem")
local c_viridi_body = core.get_content_id("loria:viridi_petasum_body")
local c_vastatorem = core.get_content_id("loria:vastatorem")

local c_rete_stem = core.get_content_id("loria:rete_stem")
local c_rete_body = core.get_content_id("loria:rete_body")

local c_ammonium_manganese_pyrophosphate =
    core.get_content_id("loria:ammonium_manganese_pyrophosphate")
local c_naga = core.get_content_id("loria:naga")

local c_potassium_permanganate_source =
    core.get_content_id("loria:potassium_permanganate_source")

local c_potassium_permanganate_flowing =
    core.get_content_id("loria:potassium_permanganate_flowing")

local c_turris_stem = core.get_content_id("loria:turris_stem")
local c_turris_body = core.get_content_id("loria:turris_body")

local c_red_mercury_oxide = core.get_content_id("loria:red_mercury_oxide")

local c_colossus_stem = core.get_content_id("loria:colossus_stem")
local c_colossus_body = core.get_content_id("loria:colossus_body")

local c_sodium_peroxide = core.get_content_id("loria:sodium_peroxide")

local c_altitudo_stem = core.get_content_id("loria:altitudo_stem")
local c_altitudo_body = core.get_content_id("loria:altitudo_body")

local c_nickel_nitrate = core.get_content_id("loria:nickel_nitrate")

local c_timor_stem = core.get_content_id("loria:timor_stem")

local viridi_petasum = {
    min_height = 7,
    max_height = 30,
    min_radius = 3
}

local rete = {
    min_height = 5,
    max_height = 9
}

local naga = {
    min_height = 6,
    max_height = 20
}

local turris = {
    min_height = 9,
    max_height = 15,
    min_radius = 3,
    max_radius = 5
}

local colossus = {
    min_height = 30,
    max_height = 36,
    min_radius = 10,
    max_radius = 20
}

local altitudo = {
    min_height = 3,
    max_height = 6,
    min_radius = 5,
    max_radius = 7,
    radius_delta = 4,
    second_hat = 2,
}

local timor = {
    min_height = 7,
    max_height = 20,
    min_radius = 10,
    max_radius = 60,
    min_hat_count = 3,
    max_hat_count = 5,
}

local function generate_hat(x, y, z, radius, obj)
    local minp0 = vector.new(x - radius, y, z - radius)
    local maxp0 = vector.new(x + radius, y, z + radius)

    local vm = core.get_voxel_manip()
    local minp, maxp = vm:read_from_map(minp0, maxp0)

    local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
    local data = vm:get_data()

    local t = 0
    while t < 2 * math.pi do
        for k = 1, radius do
            local delta_x = math.floor(k * math.cos(t))
            local delta_z = math.floor(k * math.sin(t))

            data[area:index(x + delta_x, y, z + delta_z)] = obj
        end

        t = t + 0.4
    end

    vm:set_data(data)
    vm:write_to_map()
end

local function generate_viridi_petasum(x, y, z, g, data, area, hats)
    local height = g:next(viridi_petasum.min_height, viridi_petasum.max_height)
    local radius = g:next(viridi_petasum.min_radius, math.floor(height / 2))

    if not (area:contains(x, y, z)) or
       not (area:contains(x, y + height, z)) then
        return false
    end

    -- stem
    for k = 1, height do
        data[area:index(x, y + k, z)] = c_viridi_stem
    end

    -- body
    table.insert(hats, {
        pos = vector.new(x, y + height, z),
        radius = radius, material = c_viridi_body
    })
    return true
end

local function generate_rete(x, y, z, g, data, area)
    local height = g:next(rete.min_height, rete.max_height)
    local radius = 1

    if not (area:contains(x - radius - 1, y, z - radius - 1)) or
       not (area:contains(x + radius + 1, y + height, z + radius + 1)) then
        return false
    end

    for k = 1, height do
        data[area:index(x, y + k, z)] = c_rete_stem
    end

    for i = -radius, radius do
        for j = -radius, radius do
            data[area:index(x + i, y + height, z + j)] = c_rete_body

            data[area:index(x + i, y + height - math.abs(j) - 1, z + radius + 1)] = c_rete_body
            data[area:index(x + i, y + height - math.abs(j) - 1, z - radius - 1)] = c_rete_body

            data[area:index(x + radius + 1, y + height - math.abs(j) - 1, z + i)] = c_rete_body
            data[area:index(x - radius - 1, y + height - math.abs(j) - 1, z + i)] = c_rete_body
        end
    end

    return true
end

local function generate_naga(x, y, z, g, data, area)
    while data[area:index(x, y, z)] ~= c_air do
        y = y - 1
        if not area:contains(x, y, z) then
            return false
        end
    end

    if data[area:index(x, y + 1, z)] ~= c_ammonium_manganese_pyrophosphate then
        return false
    end

    local height = g:next(naga.min_height, naga.max_height)
    for k = 0, height do
        if not area:contains(x, y - k, z) then
            return true
        end

        local i = area:index(x, y - k, z)
        if data[i] ~= c_air then
            return true
        end
        data[i] = c_naga
    end

    return true
end

local function generate_colossus(x0, y, z0, g, data, area, hats)
    local height = g:next(colossus.min_height, colossus.max_height)
    local radius = g:next(colossus.min_radius, colossus.max_radius)

    if not (area:contains(x0 - radius, y, z0 - radius)) or
       not (area:contains(x0 + radius, y + height, z0 + radius)) then
       return false
    end

    local x, z = x0, z0
    for k = -height, height do
        x = x + g:next(-1, 1)
        z = z + g:next(-1, 1)

        if area:contains(x, y + k, z) then
            data[area:index(x + 0, y + k, z + 0)] = c_colossus_stem
            data[area:index(x + 1, y + k, z + 0)] = c_colossus_stem
            data[area:index(x - 1, y + k, z + 0)] = c_colossus_stem
            data[area:index(x + 0, y + k, z + 1)] = c_colossus_stem
            data[area:index(x + 0, y + k, z - 1)] = c_colossus_stem
        end
    end

    table.insert(hats, {
        pos = vector.new(x, y + height, z),
        radius = radius, material = c_colossus_body
    })
    return true
end

local function generate_altitudo(x, y, z, g, data, area, hats)
    local height = g:next(altitudo.min_height, altitudo.max_height)
    local radius = g:next(altitudo.min_radius, altitudo.max_radius)

    if not (area:contains(x, y, z)) or
       not (area:contains(x, y + height, z)) then
        return false
    end

    -- stem
    for k = -height, height do
        if area:contains(x, y + k, z) then
            data[area:index(x, y + k, z)] = c_altitudo_stem
        end
    end

    -- body
    table.insert(hats, {
        pos = vector.new(x, y + height, z),
        radius = radius, material = c_altitudo_body
    })

    if height >= altitudo.min_height + altitudo.second_hat then
        table.insert(hats, {
            pos = vector.new(x, y + height - altitudo.second_hat, z),
            radius = radius - altitudo.radius_delta, material = c_altitudo_body
        })
    end

    return true
end

local function generate_column(x, y, z, g, data, area)
    while (data[area:index(x, y, z)] ~= c_air) and
          (data[area:index(x, y, z)] ~= c_potassium_permanganate_flowing) and
          (data[area:index(x, y, z)] ~= c_potassium_permanganate_source) do
        y = y - 1
        if not area:contains(x, y, z) then
            return false
        end
    end

    local i = area:index(x, y, z)
    while data[i] == c_air or
          data[i] == c_potassium_permanganate_source or
          data[i] == c_potassium_permanganate_flowing do

        data[i + 1] = c_ammonium_manganese_pyrophosphate
        data[i] = c_ammonium_manganese_pyrophosphate

        y = y - 1
        x = x + g:next(-1, 1)
        z = z + g:next(-1, 1)

        if not area:contains(x, y, z) then
            return true
        end

        i = area:index(x, y, z)
    end

    return true
end

local function generate_turris(x, y, z, g, data, area)
    local height = g:next(turris.min_height, turris.max_height)
    local radius = g:next(turris.min_radius, turris.max_radius)

    if not (area:contains(x - radius, y, z - radius)) or
       not (area:contains(x + radius, y + height, z + radius)) then
        return false
    end

    for k = 1, height do
        data[area:index(x, y + k, z)] = c_turris_stem
    end

    for k = 0, radius do
        local h = y + height - k
        for delta = -k, k do
            data[area:index(x + delta, h, z + k)] = c_turris_body
            data[area:index(x + delta, h, z - k)] = c_turris_body
            data[area:index(x + k, h, z + delta)] = c_turris_body
            data[area:index(x - k, h, z + delta)] = c_turris_body
        end
    end

    return true
end

local function generate_timor(x, y, z, g, data, area)
    local height = g:next(timor.min_height, timor.max_height)
    local radius = g:next(timor.min_radius, timor.max_radius)
    local hat_count = g:next(timor.min_hat_count, timor.max_hat_count)

    if not (area:contains(x - radius, y, z - radius)) or
       not (area:contains(x + radius, y + height, z + radius)) then
        return false
    end

    for k = 1, height do
        data[area:index(x, y + k, z)] = c_timor_stem
    end

    local material = randtimor()
    for level = height, height - hat_count * 2, -2 do
        local t = 0
        while t < 2 * math.pi do
            for k = 1, radius do
                local delta_x = math.floor(k * math.cos(t))
                local delta_z = math.floor(k * math.sin(t))

                local idx = area:index(x + delta_x, y + level, z + delta_z)
                data[idx] = material
            end
    
            t = t + math.random() / 2 + 0.1
        end
    end

    return true
end

mushrooms = {
    [c_copper_sulfate] = {
        { func = generate_viridi_petasum, prob = 1 },
        { func = generate_rete, prob = 1 },
    },
    [c_viridi_body] = {
        { func = generate_viridi_petasum, prob = 1 },
    },
    [c_ammonium_manganese_pyrophosphate] = {
        { func = generate_column, prob = 0.5 },
        { func = generate_naga, prob = 0.5 },
        { func = generate_turris, prob = 1 },
    },
    [c_sodium_peroxide] = {
        { func = generate_altitudo, prob = 0.1 },
        { func = generate_colossus, prob = 0.1 },
    },
    [c_nickel_nitrate] = {
        { func = generate_timor, prob = 0.1 },
    }
}

function isthere(arr, x)
    if #arr == 0 then
        return true
    else
        return contains(arr, x)
    end
end

core.register_on_generated(function(minp0, maxp0, seed)
    local height_min = -31000
    local height_max = 31000

    local vm = core.get_voxel_manip()
    local minp, maxp = vm:read_from_map(minp0, maxp0)

    if maxp.y < height_min or minp.y > height_max then
        return
    end

    local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
    local data = vm:get_data()

    local y_min = math.max(minp.y, height_min)
    local y_max = math.min(maxp.y, height_max)

    local perlin1 = core.get_perlin(230, 3, 0.6, 100)
    local divlen = 4
    local divs = (maxp.x - minp.x) / divlen + 1

    local g = PseudoRandom(seed + 1)

    local hats = {}
    for divx = 0, (divs - 1) do
        for divz = 0, (divs - 1) do
            local x0 = minp.x + math.floor((divx + 0) * divlen)
            local z0 = minp.z + math.floor((divz + 0) * divlen)
            local x1 = minp.x + math.floor((divx + 1) * divlen)
            local z1 = minp.z + math.floor((divz + 1) * divlen)

            local amount = math.floor(perlin1:get_2d({x = x0, y = z0}))
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
                    local variants = mushrooms[ground]
                    if not variants then
                        break
                    end

                    for _, mushroom in ipairs(variants) do
                        if math.random() <= mushroom.prob then
                            if mushroom.func(x, ground_y, z, g, data, area, hats) then
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    vm:set_data(data)
    vm:write_to_map()

    for _, conf in ipairs(hats) do
        generate_hat(
            conf.pos.x, conf.pos.y, conf.pos.z,
            conf.radius, conf.material
        )
    end
    vm:update_map()
end)