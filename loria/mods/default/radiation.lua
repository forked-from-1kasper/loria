local c_uranyl_acetate = minetest.get_content_id("default:uranyl_acetate")
local c_plutonium_fluoride = minetest.get_content_id("default:plutonium_fluoride")
local c_turris_body = minetest.get_content_id("default:turris_body")
local c_periculum = minetest.get_content_id("default:periculum")

activity = {
    [c_uranyl_acetate] = 1,
    [c_plutonium_fluoride] = 20,
    [c_periculum] = 0.5,
}

radiation_vect = vector.new(16, 16, 16)

DOSE_DECREASE_TIME = 1
DOSE_DAMAGE_LIMIT = 1

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

            if dose > DOSE_DAMAGE_LIMIT then
                player:set_hp(player:get_hp() - 1)
            end
        end
    end
end)

function hypot_sqr(pos1, pos2)
    return
        (pos1.x - pos2.x) ^ 2 +
        (pos1.y - pos2.y) ^ 2 +
        (pos1.z - pos2.z) ^ 2
end

function calculate_inventory_radiation(inv)
    local radiation = 0

    for _, list in pairs(inv:get_lists()) do
        for _, stack in ipairs(list) do
            local A = activity[minetest.get_content_id(stack:get_name())]
            if A then
                radiation = radiation + A * stack:get_count()
            end
        end
    end

    return radiation
end

minetest.register_globalstep(function(dtime)
    local vm = minetest.get_voxel_manip()

    for _, player in ipairs(minetest.get_connected_players()) do
        local radiation = 0

        local pos = player:get_pos()

        local minp, maxp = vm:read_from_map(
            vector.subtract(pos, radiation_vect),
            vector.add(pos, radiation_vect)
        )

        local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
        local data = vm:get_data()
        for i = 1, #data do
            local A = activity[data[i]]
            if A then
                local node = area:position(i)
                radiation = radiation + A / hypot_sqr(pos, node)
            end
        end

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