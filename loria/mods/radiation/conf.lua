local cid = minetest.get_content_id

activity = { }
minetest.register_on_mods_loaded(function()
    activity = {
        -- Thorium
        [cid("default:thorium")] = { alpha = 16, beta = 5, gamma = 0 },
        ["default:thorium_ingot"] = { alpha = 8, beta = 3, gamma = 0 },
        [cid("electricity:thorium_cable")] = { alpha = 6, beta = 2, gamma = 0 },
        [cid("default:thorium_iodide")] = { alpha = 12, beta = 4, gamma = 0 },
        -- Uranium
        [cid("default:uranium")] = { alpha = 5, beta = 3, gamma = 0 },
        ["default:uranium_ingot"] = { alpha = 3, beta = 1, gamma = 0 },
        [cid("electricity:uranium_cable")] = { alpha = 2, beta = 0.6, gamma = 0 },
        [cid("default:uranium_tetrachloride")] = { alpha = 3, beta = 1, gamma = 0 },
        [cid("default:uranium_tetrachloride_brick")] = { alpha = 2, beta = 1, gamma = 0 },
        -- Plutonium
        [cid("default:plutonium")] = { alpha = 20, beta = 0, gamma = 0 },
        ["default:plutonium_ingot"] = { alpha = 5, beta = 0, gamma = 0 },
        [cid("electricity:plutonium_cable")] = { alpha = 7, beta = 0, gamma = 0 },
        [cid("default:plutonium_trifluoride")] = { alpha = 20, beta = 0, gamma = 0 },
        [cid("default:plutonium_tetrafluoride")] = { alpha = 16, beta = 0, gamma = 0 },
        [cid("default:plutonium_dioxide")] = { alpha = 40, beta = 0, gamma = 0 },
        [cid("default:plutonium_dioxide_brick")] = { alpha = 26, beta = 0, gamma = 0 },
        -- Americium
        [cid("default:americium_trifluoride")] = { alpha = 5, beta = 0, gamma = 7 },
        -- Polluted mercury
        ["default:bucket_polluted_mercury"] = { alpha = 5, beta = 2.3, gamma = 0 },
        [cid("default:polluted_mercury_source")] = { alpha = 5, beta = 2.3, gamma = 0 },
        [cid("default:polluted_mercury_flowing")] = { alpha = 5, beta = 2.3, gamma = 0 },
        -- Technic
        [cid("furnace:refiner_active")] = { alpha = 0, beta = 0, gamma = 0.3 },
        -- Organic
        [cid("default:periculum")] = { alpha = 0, beta = 0, gamma = 0.5 },
        [cid("default:imitationis")] = { alpha = 0, beta = 0, gamma = 0.05 },
        [cid("default:nihil")] = { alpha = 0, beta = 0, gamma = 0.01 },
        [cid("default:lectica")] = { alpha = 0, beta = 0, gamma = 0.07 },
    }

    for name, params in pairs(ores) do
        if params.radioactive then
            local A0 = activity[cid("default:" .. name)]
            local A = { alpha = A0.alpha / 5, beta = A0.beta / 3, gamma = A0.gamma / 2 }
            for _, place in ipairs(params.wherein) do
                activity[cid("default:" .. name .. "_" .. place)] = A
            end
        end
    end
end)

antiradiation_drugs = {
    ["default:manganese_oxide"] = 0.5,
}

has_inventory = { }
minetest.register_on_mods_loaded(function()
    has_inventory = {
        [minetest.get_content_id("default:lead_box")] = true,
        [minetest.get_content_id("furnace:gas")] = true,
        [minetest.get_content_id("furnace:electric")] = true,
        [minetest.get_content_id("electricity:riteg")] = true,
    }
end)