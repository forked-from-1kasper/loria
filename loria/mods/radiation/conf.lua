local cid = minetest.get_content_id

activity = {
    [cid("default:uranium_tetrachloride_cinnabar")] = {
        alpha = 1, beta = 0.3, gamma = 0
    },
    [cid("default:uranium_tetrachloride_azure")] = {
        alpha = 1, beta = 0.3, gamma = 0
    },
    [cid("default:uranium_tetrachloride")] = { alpha = 3, beta = 1, gamma = 0 },
    [cid("default:uranium")] = { alpha = 5, beta = 3, gamma = 0 },
    [cid("default:periculum")] = { alpha = 0, beta = 0, gamma = 0.5 },
    [cid("default:plutonium_trifluoride_cinnabar")] = {
        alpha = 7, beta = 0, gamma = 0
    },
    [cid("default:plutonium_trifluoride_azure")] = {
        alpha = 7, beta = 0, gamma = 0
    },
    [cid("default:plutonium_trifluoride")] = { alpha = 10, beta = 0, gamma = 0 },
    [cid("default:plutonium_tetrafluoride")] = { alpha = 8, beta = 0, gamma = 0 },
    [cid("default:plutonium_dioxide")] = { alpha = 20, beta = 0, gamma = 0 },
}

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