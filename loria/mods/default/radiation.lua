local c_uranyl_acetate = minetest.get_content_id("default:uranyl_acetate")
activity = {
    [c_uranyl_acetate] = 5
}

RADIATION_LIMIT = 16

DOSE_DECREASE_TIME = 1
DOSE_DAMAGE_LIMIT = 1
DOSE_DECREASE_VALUE = 0.001

local radiation_timer = 0
minetest.register_globalstep(function(dtime)
    radiation_timer = radiation_timer + dtime
    if radiation_timer > DOSE_DECREASE_TIME then
        radiation_timer = 0

        for _, player in ipairs(minetest.get_connected_players()) do
            local meta = player:get_meta()
            local radiation = meta:get_float("radiation")

            local dose = meta:get_float("received_dose") +
                (radiation / 3600) * DOSE_DECREASE_TIME -
                DOSE_DECREASE_VALUE

            if dose < 0 then dose = 0 end

            meta:set_float("received_dose", dose)

            if dose > DOSE_DAMAGE_LIMIT then
                player:set_hp(player:get_hp() - 1)
            end
        end
    end
end)

minetest.register_globalstep(function(dtime)
    local vm = minetest.get_voxel_manip()

    for _, player in ipairs(minetest.get_connected_players()) do
        local radiation = 0

        local pos = player:get_pos()

        local minp, maxp = vm:read_from_map(
            { x = pos.x - RADIATION_LIMIT,
              y = pos.y - RADIATION_LIMIT,
              z = pos.z - RADIATION_LIMIT },
            { x = pos.x + RADIATION_LIMIT,
              y = pos.y + RADIATION_LIMIT,
              z = pos.z + RADIATION_LIMIT }
        )

        local area = VoxelArea:new({MinEdge = minp, MaxEdge = maxp})
        local data = vm:get_data()
        for i = 1, #data do
            local A = activity[data[i]]
            if A then
                local node = area:position(i)
                radiation = radiation + A / (
                    (pos.x - node.x) ^ 2 +
                    (pos.y - node.y) ^ 2 +
                    (pos.z - node.z) ^ 2
                )
            end
        end

        local meta = player:get_meta()
        meta:set_float("radiation", radiation)
    end
end)