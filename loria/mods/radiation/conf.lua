local c_uranium_tetrachloride_ore = minetest.get_content_id("default:uranium_tetrachloride_ore")
local c_uranium_tetrachloride = minetest.get_content_id("default:uranium_tetrachloride")
local c_uranium = minetest.get_content_id("default:uranium")

local c_plutonium_fluoride_ore = minetest.get_content_id("default:plutonium_fluoride_ore")
local c_plutonium_trifluoride = minetest.get_content_id("default:plutonium_trifluoride")
local c_plutonium_tetrafluoride = minetest.get_content_id("default:plutonium_tetrafluoride")
local c_plutonium_dioxide = minetest.get_content_id("default:plutonium_dioxide")

local c_periculum = minetest.get_content_id("default:periculum")

activity = {
    [c_uranium_tetrachloride_ore] = { alpha = 1, beta = 0.3, gamma = 0 },
    [c_uranium_tetrachloride] = { alpha = 3, beta = 1, gamma = 0 },
    [c_uranium] = { alpha = 5, beta = 3, gamma = 0 },
    [c_periculum] = { alpha = 0, beta = 0, gamma = 0.5 },
    [c_plutonium_fluoride_ore] = { alpha = 7, beta = 0, gamma = 0 },
    [c_plutonium_trifluoride] = { alpha = 10, beta = 0, gamma = 0 },
    [c_plutonium_tetrafluoride] = { alpha = 8, beta = 0, gamma = 0 },
    [c_plutonium_dioxide] = { alpha = 20, beta = 0, gamma = 0 },
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