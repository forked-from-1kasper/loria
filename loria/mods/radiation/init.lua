dofile(minetest.get_modpath("radiation").."/conf.lua")

radiation_vect = vector.new(16, 16, 16)

DOSE_DECREASE_TIME = 1

local radiation_timer = 0
minetest.register_globalstep(function(dtime)
    radiation_timer = radiation_timer + dtime
    if radiation_timer > DOSE_DECREASE_TIME then
        radiation_timer = 0

        for _, player in ipairs(minetest.get_connected_players()) do
            local meta = player:get_meta()
            local radiation = meta:get_float("radiation")

            local dose = meta:get_float("received_dose") +
                (radiation / 3600) * DOSE_DECREASE_TIME

            if dose < 0 then dose = 0 end

            meta:set_float("received_dose", dose)
            local dose_damage_limit = meta:get_float("dose_damage_limit")

            if dose > dose_damage_limit then
                local inv = player:get_inventory()
                local drug_stack = inv:get_list("antiradiation")[1]

                local drug_value = antiradiation_drugs[drug_stack:get_name()]

                if drug_value then
                    meta:set_float("dose_damage_limit", dose_damage_limit + drug_value)
                    drug_stack:set_count(drug_stack:get_count() - 1)
                    inv:set_stack("antiradiation", 1, drug_stack)
                else
                    player:set_hp(player:get_hp() - 1)
                end
            end
        end
    end
end)

local function hypot_sqr(pos1, pos2)
    return
        (pos1.x - pos2.x) ^ 2 +
        (pos1.y - pos2.y) ^ 2 +
        (pos1.z - pos2.z) ^ 2
end

local function calculate_inventory_radiation(inv)
    local radiation = 0

    for listname, list in pairs(inv:get_lists()) do
        if listname ~= "creative_inv" then
            for _, stack in ipairs(list) do
                local A = activity[minetest.get_content_id(stack:get_name())]
                if A then
                    radiation = radiation + A * stack:get_count()
                end
            end
        end
    end

    return radiation
end

function calculate_radiation(vm, pos)
    local radiation = 0

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
            local node = area:position(i)
            radiation = radiation + A / hypot_sqr(pos, node)
        end

        if has_inventory[cid] then
            local node = area:position(i)
            local inv = minetest.get_meta(node):get_inventory()
            local A = calculate_inventory_radiation(inv)
            radiation = radiation + A / hypot_sqr(pos, node)
        end
    end

    return radiation
end

minetest.register_globalstep(function(dtime)
    local vm = minetest.get_voxel_manip()

    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        local radiation = calculate_radiation(vm, pos)

        local objs = minetest.get_objects_inside_radius(pos, vector.length(radiation_vect))
        for _, obj in pairs(objs) do
            local name = player:get_player_name()
            local entity = obj:get_luaentity()
            if entity and entity.name == "__builtin:item" then
                local stack = ItemStack(entity.itemstring)
                local A = activity[minetest.get_content_id(stack:get_name())]
                if A then
                    A = A * stack:get_count()
                    radiation = radiation + A / hypot_sqr(pos, obj:get_pos())
                end
            end
        end

        radiation = radiation +
            calculate_inventory_radiation(player:get_inventory())

        local meta = player:get_meta()
        meta:set_float("radiation", radiation)
    end
end)