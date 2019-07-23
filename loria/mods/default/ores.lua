for name, params in pairs(ores) do
    local light_source = params.light_source or 0

    minetest.register_node("default:" .. name .. "_cinnabar", {
        description = capitalization(name) .. " (in cinnabar)",
        tiles = { "default_cinnabar.png^default_" .. name .. "_ore.png" },
        groups = { cracky = 2 },
        drop = "default:" .. name .. "_cinnabar",
        light_source = math.floor(light_source / 2),
    })

    minetest.register_node("default:" .. name .. "_azure", {
        description = capitalization(name) .. " (in cobalt blue)",
        tiles = { "default_cobalt_blue.png^default_" .. name .. "_ore.png" },
        groups = { cracky = 2 },
        drop = "default:" .. name .. "_azure",
        light_source = math.floor(light_source / 2),
    })

    minetest.register_node("default:" .. name, {
        description = capitalization(name) .. " (" .. params.formula .. ")",
        tiles = { "default_" .. name .. ".png" },
        groups = { cracky = 1 },
        drop = "default:" .. name,
        light_source = light_source,
    })

    if params.has_ingot then
        minetest.register_craftitem("default:" .. name .."_ingot", {
            description = capitalization(name) .. " ingot",
            inventory_image = "default_" .. name .. "_ingot.png",
        })
    end
end

minetest.register_node("default:plutonium_dioxide", {
    description = "Plutonium (IV) oxide (PuO2)",
    tiles = { "default_plutonium_dioxide.png" },
    groups = { cracky = 2 },
    drop = 'default:plutonium_dioxide'
})

minetest.register_node("default:plutonium_tetrafluoride", {
    description = "Plutonium (IV) tetrafluoride (PuF4)",
    tiles = { "default_plutonium_tetrafluoride.png" },
    groups = { cracky = 2 },
    drop = 'default:plutonium_tetrafluoride'
})

liquid_ores = {
    ["trisilane"] = {
        liquid = "default:trisilane_source",
    },
    ["hydrochloric_acid"] = {
        liquid = "default:hydrochloric_acid_source",
        y_min = -150, y_max = 50,
    }
}

for name, params in pairs(liquid_ores) do
    minetest.register_node("default:" .. name .. "_cinnabar", {
        description = capitalization(name) .. " (in cinnabar)",
        tiles = { "default_cinnabar.png^default_" .. name .. "_ore.png" },
        groups = { cracky = 1 },
        drop = {},
        after_destruct = function(pos, oldnode)
            minetest.set_node(pos, { name = params.liquid })
        end
    })

    minetest.register_node("default:" .. name .. "_cobalt_blue", {
        description = capitalization(name) .. " (in cobalt blue)",
        tiles = { "default_cobalt_blue.png^default_" .. name .. "_ore.png" },
        groups = { cracky = 1 },
        drop = {},
        after_destruct = function(pos, oldnode)
            minetest.set_node(pos, { name = params.liquid })
        end
    })

    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:" .. name .. "_cinnabar",
        wherein        = "default:cinnabar",
        clust_scarcity = 8 * 8 * 8,
        clust_num_ores = 8,
        clust_size     = 3,
        y_min          = params.y_min or -10,
        y_max          = params.y_max or 80,
    })
    
    minetest.register_ore({
        ore_type       = "scatter",
        ore            = "default:" .. name .. "_cobalt_blue",
        wherein        = "default:cobalt_blue",
        clust_scarcity = 8 * 8 * 8,
        clust_num_ores = 8,
        clust_size     = 3,
        y_min          = params.y_min or -10,
        y_max          = params.y_max or 80,
    })
end