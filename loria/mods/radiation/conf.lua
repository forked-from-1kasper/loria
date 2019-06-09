local c_uranium_tetrachloride_ore = minetest.get_content_id("default:uranium_tetrachloride_ore")
local c_uranium_tetrachloride = minetest.get_content_id("default:uranium_tetrachloride")
local c_uranium = minetest.get_content_id("default:uranium")

local c_plutonium_fluoride = minetest.get_content_id("default:plutonium_fluoride")
local c_periculum = minetest.get_content_id("default:periculum")

activity = {
    [c_uranium_tetrachloride_ore] = 1,
    [c_uranium_tetrachloride] = 3,
    [c_uranium] = 5,
    [c_plutonium_fluoride] = 20,
    [c_periculum] = 0.5,
}