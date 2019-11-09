local c_air = minetest.get_content_id("air")
local c_copper_sulfate = minetest.get_content_id("default:copper_sulfate")

local c_viridi_stem = minetest.get_content_id("default:viridi_petasum_stem")
local c_viridi_body = minetest.get_content_id("default:viridi_petasum_body")
local c_vastatorem = minetest.get_content_id("default:vastatorem")

local c_rete_stem = minetest.get_content_id("default:rete_stem")
local c_rete_body = minetest.get_content_id("default:rete_body")

local c_ammonium_manganese_pyrophosphate =
    minetest.get_content_id("default:ammonium_manganese_pyrophosphate")
local c_naga = minetest.get_content_id("default:naga")

local c_potassium_permanganate_source =
    minetest.get_content_id("default:potassium_permanganate_source")

local c_potassium_permanganate_flowing =
    minetest.get_content_id("default:potassium_permanganate_flowing")

local c_turris_stem = minetest.get_content_id("default:turris_stem")
local c_turris_body = minetest.get_content_id("default:turris_body")

local c_red_mercury_oxide = minetest.get_content_id("default:red_mercury_oxide")

local c_colossus_stem = minetest.get_content_id("default:colossus_stem")
local c_colossus_body = minetest.get_content_id("default:colossus_body")

local c_sodium_peroxide = minetest.get_content_id("default:sodium_peroxide")

local c_altitudo_stem = minetest.get_content_id("default:altitudo_stem")
local c_altitudo_body = minetest.get_content_id("default:altitudo_body")

local c_nickel_nitrate = minetest.get_content_id("default:nickel_nitrate")

local c_timor_stem = minetest.get_content_id("default:timor_stem")
local c_timor_body = minetest.get_content_id("default:timor_body")

viridi_petasum = {
    min_height = 7,
    max_height = 30,
    min_radius = 3
}

rete = {
    min_height = 5,
    max_height = 9
}

columnae = {
    min_height = 6,
    max_height = 20
}

turris = {
    min_height = 9,
    max_height = 15,
    min_radius = 3,
    max_radius = 5
}

colossus = {
    min_height = 30,
    max_height = 36,
    min_radius = 10,
    max_radius = 20
}

altitudo = {
    min_height = 3,
    max_height = 6,
    min_radius = 5,
    max_radius = 7,
    radius_delta = 4,
    second_hat = 2,
}

timor = {
    min_height = 7,
    max_height = 20,
    min_radius = 10,
    max_radius = 60,
    min_hat_count = 3,
    max_hat_count = 5,
}

local function generate_hat(x, y, z, height, radius, data, area, obj)
    local t = 0
    while t < 2 * math.pi do
        for k = 1, radius do
            local delta_x = math.floor(k * math.cos(t))
            local delta_z = math.floor(k * math.sin(t))

            data[area:index(x + delta_x, y + height, z + delta_z)] = obj
        end

        t = t + 0.4
    end
end

local function generate_viridi_petasum(x, y, z, g, data, area)
    local height = g:next(viridi_petasum.min_height, viridi_petasum.max_height)
    local radius = g:next(viridi_petasum.min_radius, math.floor(height / 2))

    if not (area:contains(x - radius, y, z - radius)) or
       not (area:contains(x + radius, y + height, z + radius)) then
        return
    end

    -- stem
    for k = 1, height do
        data[area:index(x, y + k, z)] = c_viridi_stem
    end

    -- body
    generate_hat(x, y, z, height, radius, data, area, c_viridi_body)
end

local function generate_rete(x, y, z, g, data, area)
    local height = g:next(rete.min_height, rete.max_height)
    local radius = 1

    if not (area:contains(x - radius - 1, y, z - radius - 1)) or
       not (area:contains(x + radius + 1, y + height, z + radius + 1)) then
        return
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
end

local function generate_columnae(x, y, z, g, data, area)
    while data[area:index(x, y, z)] ~= c_air do
        y = y - 1
        if not area:contains(x, y, z) then
            return
        end
    end

    local height = g:next(columnae.min_height, columnae.max_height)
    for k = 0, height do
        if not area:contains(x, y - k, z) then
            return
        end

        local i = area:index(x, y - k, z)
        if data[i] ~= c_air then
            return
        end
        data[i] = c_naga
    end
end

local function generate_colossus(x, y, z, g, data, area)
    local height = g:next(colossus.min_height, colossus.max_height)
    local radius = g:next(colossus.min_radius, colossus.max_radius)

    if not (area:contains(x - radius, y, z - radius)) or
       not (area:contains(x + radius, y + height, z + radius)) then
       return
    end

    for k = -height, height do
        for delta_x = -1, 1 do
            for delta_z = -1, 1 do
                local x1, y1, z1 = x + delta_x, y + k, z + delta_z
                if math.abs(delta_x * delta_z) ~= 1 and
                   area:contains(x1, y1, z1) then
                    data[area:index(x1, y1, z1)] = c_colossus_stem
                end
            end
        end
        x = x + g:next(-1, 1)
        z = z + g:next(-1, 1)
    end

    generate_hat(x, y, z, height, radius,
        data, area, c_colossus_body
    )
end

local function generate_altitudo(x, y, z, g, data, area)
    local height = g:next(altitudo.min_height, altitudo.max_height)
    local radius = g:next(altitudo.min_radius, altitudo.max_radius)

    if not (area:contains(x - radius, y, z - radius)) or
       not (area:contains(x + radius, y + height, z + radius)) then
        return
    end

    -- stem
    for k = -height, height do
        data[area:index(x, y + k, z)] = c_altitudo_stem
    end

    -- body
    generate_hat(x, y, z, height, radius, data, area, c_altitudo_body)

    if height >= altitudo.min_height + altitudo.second_hat then
        generate_hat(
            x, y, z,
            height - altitudo.second_hat,
            radius - altitudo.radius_delta,
            data, area, c_altitudo_body
        )
    end
end

local function generate_column(x, y, z, g, data, area)
    while (data[area:index(x, y, z)] ~= c_air) and
          (data[area:index(x, y, z)] ~= c_potassium_permanganate_flowing) and
          (data[area:index(x, y, z)] ~= c_potassium_permanganate_source) do
        y = y - 1
        if not area:contains(x, y, z) then
            return
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
            return
        end

        i = area:index(x, y, z)
    end
end

local function generate_turris(x, y, z, g, data, area)
    local height = g:next(turris.min_height, turris.max_height)
    local radius = g:next(turris.min_radius, turris.max_radius)

    if not (area:contains(x - radius, y, z - radius)) or
       not (area:contains(x + radius, y + height, z + radius)) then
        return
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
end

local function generate_timor(x, y, z, g, data, area)
    local height = g:next(timor.min_height, timor.max_height)
    local radius = g:next(timor.min_radius, timor.max_radius)
    local hat_count = g:next(timor.min_hat_count, timor.max_hat_count)

    if not (area:contains(x - radius, y, z - radius)) or
       not (area:contains(x + radius, y + height, z + radius)) then
        return
    end

    for k = 1, height do
        data[area:index(x, y + k, z)] = c_timor_stem
    end

    for level = height, height - hat_count * 2, -2 do
        local t = 0
        while t < 2 * math.pi do
            for k = 1, radius do
                local delta_x = math.floor(k * math.cos(t))
                local delta_z = math.floor(k * math.sin(t))

                local idx = area:index(x + delta_x, y + level, z + delta_z)
                data[idx] = c_timor_body
            end
    
            t = t + math.random() / 2 + 0.1
        end
    end
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
        { func = generate_columnae, prob = 1 },
        { func = generate_column, prob = 1 },
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

local noise_depth = 4
function noise(x, z, minp, maxp, area, data)
    local y = maxp.y

    while data[area:index(x, y, z)] == c_air do
        y = y - 1
        if y < minp.y then
            return
        end
    end

    if data[area:index(x, y, z)] ~= c_ammonium_manganese_pyrophosphate then
        return
    end

    while data[area:index(x, y, z)] ~= c_air do
        y = y - 1
        if y < minp.y then
            return
        end
    end

    for delta = 0, math.random(0, noise_depth) do
        data[area:index(x, y + delta, z)] = c_air
    end

    while data[area:index(x, y, z)] ~= c_potassium_permanganate_source and
          data[area:index(x, y, z)] ~= c_potassium_permanganate_flowing do
        y = y - 1
        if y < minp.y then
            return
        end
    end

    while data[area:index(x, y, z)] == c_potassium_permanganate_source or
          data[area:index(x, y, z)] == c_potassium_permanganate_flowing do
        y = y - 1
        if y < minp.y then
            return
        end
    end

    for delta = 0, math.random(0, noise_depth) do
        data[area:index(x, y - delta, z)] = c_potassium_permanganate_source
    end
end

minetest.register_on_generated(function(minp0, maxp0, seed)
    local height_min = -31000
    local height_max = 31000
    
    local vm = minetest.get_voxel_manip()
    local minp, maxp = vm:read_from_map(minp0, maxp0)

    if maxp.y < height_min or minp.y > height_max then
        return
    end

    local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
    local data = vm:get_data()

    for x = minp.x, maxp.x do
        for z = minp.z, maxp.z do
            noise(x, z, minp, maxp, area, data)
        end
    end

    local y_min = math.max(minp.y, height_min)
    local y_max = math.min(maxp.y, height_max)

    local perlin1 = minetest.get_perlin(230, 3, 0.6, 100)
    local divlen = 4
    local divs = (maxp.x - minp.x) / divlen + 1

    local g = PseudoRandom(seed + 1)
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

                    local mushroom = variants[g:next(1, #variants)]
                    if math.random() <= mushroom.prob then
                        mushroom.func(x, ground_y, z, g, data, area)
                    end
                end
            end
        end
    end

    vm:set_data(data)
    vm:write_to_map()
    vm:update_map()
end)