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
        description = conf.name:gsub("^%l", string.upper) .. " cable",
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
            "group:consumer",
            "group:source",
            "group:conductor",
            "group:disabled_electric_tool",
        },

        on_construct = set_resis(conf.resis),
        on_destruct = reset_current,
    })
end

register_cable({ name = "aluminium", resis = 0.01 })