local cable_box = {
    type = "connected",
    fixed = { -1/16, -1/2, -1/16, 1/16, -1/2+1/16, 1/16 },
    connect_top = { -1/16, -1/2, -1/16, 1/16, 1/2, 1/16 },
    connect_bottom = { -1/16, -1/2, -1/16, 1/16, -1/2+1/16, 1/16 },
    connect_front = { -1/16, -1/2, -1/2, 1/16, -1/2+1/16, 1/16 },
    connect_left = { -1/2, -1/2, -1/16, 1/16, -1/2+1/16, 1/16 },
    connect_back = { -1/16, -1/2, -1/16, 1/16, -1/2+1/16, 1/2 },
    connect_right = { -1/16, -1/2, -1/16, 1/2, -1/2+1/16, 1/16 },
}

function register_cable(conf)
    minetest.register_node("electricity:" .. conf.name .. "_cable", {
        description = capitalization(conf.name) .. " cable",
        drawtype = "nodebox",
        tiles = {
            "electricity_" .. conf.name .. "_cable.png",
            "electricity_" .. conf.name .. "_cable.png",
            "electricity_" .. conf.name .. "_cable_side.png",
            "electricity_" .. conf.name .. "_cable_side.png",
            "electricity_" .. conf.name .. "_cable_side.png",
            "electricity_" .. conf.name .. "_cable_side.png"
        },

        inventory_image = "electricity_" .. conf.name .. "_cable_item.png",
        wield_image = "electricity_" .. conf.name .. "_cable_item.png",
        is_ground_content = false,
        sunlight_propagates = true,
        paramtype = "light",
        drop = "electricity:" .. conf.name .. "_cable",
        groups = { crumbly = 3, dig_immediate = 3, conductor = 1, cable = 1 },

        selection_box = cable_box,
        node_box = cable_box,

        connects_to = {
            "group:source",
            "group:conductor",
            "group:disabled_electric_tool",
        },

        on_destruct = reset_current,
    })

    model["electricity:" .. conf.name .. "_cable"] = function(pos, id)
        local res = { }
        local center = hash_node_pos(pos)
    
        for idx, vect in ipairs(neighbors) do
            table.insert(res, table.concat({
                "r" .. id .. idx,
                center, hash_node_connect(pos, vector.add(pos, vect)),
                conf.resis
            }, " "))
        end

        return res, nil
    end
end

register_cable({ name = "aluminium", resis = 0.01 })