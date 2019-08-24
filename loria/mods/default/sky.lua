local default_color = { r = 140, g = 186, b = 250 }
local night_color = { r = 0, g = 0, b = 16 }

local colors = {
    [minetest.get_biome_id("default:redland")] = { r = 255, g = 200, b = 150 },
    [minetest.get_biome_id("default:purple_swamp")] = { r = 190, g = 155, b = 255 },
    [minetest.get_biome_id("default:acidic_landscapes")] = { r = 200, g = 255, b = 100 },
}

local sunrise = { start = 4500/24000, finish = 5751/24000 }
local sunset = { start = 18600/24000, finish = 19502/24000 }

local function brightness(color, x)
    return {
        r = x * color.r,
        g = x * color.g,
        b = x * color.b,
    }
end

local function addition(c1, c2)
    return {
        r = math.min(c1.r + c2.r, 255),
        g = math.min(c1.g + c2.g, 255),
        b = math.min(c1.b + c2.b, 255),
    }
end

local function get_sky_color(color, timeofday)
    if timeofday < sunrise.start then
        return brightness(color, 0)
    elseif timeofday >= sunrise.start and timeofday < sunrise.finish then
        return brightness(color,
            (timeofday - sunrise.start) / (sunrise.finish - sunrise.start)
        )
    elseif timeofday >= sunrise.finish and timeofday < sunset.start then
        return brightness(color, 1)
    elseif timeofday >= sunset.start and timeofday < sunset.finish then
        return brightness(color,
            (sunset.finish - timeofday) / (sunset.finish - sunset.start)
        )
    elseif timeofday >= sunset.finish then
        return brightness(color, 0)
    end
end

minetest.register_globalstep(function(dtime)
    local timeofday = minetest.get_timeofday()

    for _, player in ipairs(minetest.get_connected_players()) do
        local pos = player:get_pos()
        local color = colors[minetest.get_biome_data(pos).biome] or default_color

        player:set_sky(
            addition(get_sky_color(color, timeofday), night_color), "plain"
        )
    end
end)