dofile(minetest.get_modpath("radiation").."/conf.lua")

radiation_vect = vector.new(16, 16, 16)

radiation_effects_timeout = 1

null = { alpha = 0, beta = 0, gamma = 0 }

local function hypot_sqr(pos1, pos2)
    return
        (pos1.x - pos2.x) ^ 2 +
        (pos1.y - pos2.y) ^ 2 +
        (pos1.z - pos2.z) ^ 2
end

local function alpha(A, source, pos)
    return A * math.exp(-hypot_sqr(source, pos))
end

local function beta(A, source, pos)
    local dist_sqr = hypot_sqr(source, pos)
    if dist_sqr ~= 0 then
        return A * math.exp(-math.sqrt(dist_sqr)) / dist_sqr
    else
        return A
    end
end

local function gamma(A, source, pos)
    local dist_sqr = hypot_sqr(source, pos)
    if dist_sqr ~= 0 then
        return A / hypot_sqr(source, pos)
    else
        return A
    end
end

local function radiation_summary(A, source, pos)
    return {
        alpha = alpha(A.alpha, source, pos),
        beta = beta(A.beta, source, pos),
        gamma = gamma(A.gamma, source, pos),
    }
end

local function add(A1, A2)
    return {
        alpha = A1.alpha + A2.alpha,
        beta = A1.beta + A2.beta,
        gamma = A1.gamma + A2.gamma,
    }
end

local function mult(k, A)
    return {
        alpha = k * A.alpha,
        beta = k * A.beta,
        gamma = k * A.gamma,
    }
end

function total(A)
    return A.alpha + A.beta + A.gamma
end

local function calculate_inventory_radiation(inv)
    local radiation = { alpha = 0, beta = 0, gamma = 0 }

    for listname, list in pairs(inv:get_lists()) do
        if listname ~= "creative_inv" then
            for _, stack in ipairs(list) do
                local A = activity[minetest.get_content_id(stack:get_name())] or null
                -- no radiation.alpha
                radiation.beta = radiation.beta + A.beta * stack:get_count()
                radiation.gamma = radiation.gamma + A.gamma * stack:get_count()
            end
        end
    end

    return radiation
end

function calculate_radiation(vm, pos)
    local radiation = null

    local minp, maxp = vm:read_from_map(
        vector.subtract(pos, radiation_vect),
        vector.add(pos, radiation_vect)
    )

    local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
    local data = vm:get_data()
    for i = 1, #data do
        local cid = data[i]
        local A = activity[cid]

        if A then
            local node = vector.add(area:position(i), vector.new(0, -1/2, 0))
            radiation = add(radiation, radiation_summary(A, pos, node))
        end

        if has_inventory[cid] then
            local node = vector.add(area:position(i), vector.new(0, -1/2, 0))
            local inv = minetest.get_meta(node):get_inventory()
            local A = calculate_inventory_radiation(inv)
            radiation = add(radiation, radiation_summary(A, pos, node))
        end
    end

    return radiation
end

local function calculate_player_radiation(player, vm)
    local pos = player:get_pos()
    local radiation = calculate_radiation(vm, pos)

    local objs = minetest.get_objects_inside_radius(pos, vector.length(radiation_vect))
    for _, obj in pairs(objs) do
        local name = player:get_player_name()
        local entity = obj:get_luaentity()
        if entity and entity.name == "__builtin:item" then
            local stack = ItemStack(entity.itemstring)
            local A = activity[minetest.get_content_id(stack:get_name())] or null
            radiation = add(
                radiation,
                mult(
                    stack:get_count(),
                    radiation_summary(A, pos, obj:get_pos())
                )
            )
        end
    end

    radiation = add(radiation, calculate_inventory_radiation(player:get_inventory()))
    return radiation
end

local maximum_dose = 5
local function radiation_effects(player, radiation)
    local meta = player:get_meta()

    local dose = meta:get_float("received_dose") +
        (radiation / 3600) * radiation_effects_timeout

    if dose < 0 then dose = 0 end

    meta:set_float("received_dose", dose)
    local dose_damage_limit = meta:get_float("dose_damage_limit")

    if dose > dose_damage_limit then
        local inv = player:get_inventory()
        local drug_stack = inv:get_list("antiradiation")[1]

        local drug_value = antiradiation_drugs[drug_stack:get_name()]

        if drug_value and dose <= maximum_dose then
            meta:set_float("dose_damage_limit", dose_damage_limit + drug_value)
            drug_stack:set_count(drug_stack:get_count() - 1)
            inv:set_stack("antiradiation", 1, drug_stack)
        else
            player:set_hp(player:get_hp() - math.floor(dose))
        end
    end
end

local radiation_timer = 0
minetest.register_globalstep(function(dtime)
    radiation_timer = radiation_timer + dtime
    local vm = minetest.get_voxel_manip()

    for _, player in ipairs(minetest.get_connected_players()) do
        local radiation = total(calculate_player_radiation(player, vm))

        local meta = player:get_meta()
        meta:set_float("radiation", (meta:get_float("radiation") + radiation) / 2)

        if radiation_timer > radiation_effects_timeout then
            radiation_effects(player, radiation)
        end
    end

    if radiation_timer > radiation_effects_timeout then
        radiation_timer = 0
    end
end)