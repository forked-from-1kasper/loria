dofile(minetest.get_modpath("default").."/gases_arch.lua")

gas_levels = 128
gas_timer = 1
gas_vect = vector.new(16, 16, 16)

function is_organic(name)
    return
        starts_with(name, "default:pars") or
        starts_with(name, "default:truncus") or
        starts_with(name, "default:viriditas") or
        starts_with(name, "default:rami") or
        starts_with(name, "default:spears") or
        starts_with(name, "default:naga") or
        ends_with(name, "_body") or
        (small_mushrooms[name:sub(#"default:" + 1)] ~= nil)
end

function is_heavy_organic(name)
    return ends_with(name, "_stem")
end

function is_fuel(name)
    return
        starts_with(name, "default:potassium") or
        starts_with(name, "default:trisilane")
end

chlorine = {
    name = "chlorine",
    icon = "default_chlorine_symbol.png",
    color = { r = 210, g = 255, b = 0 },
    destroys = is_organic,
    transparent = false,
    damage = 2,
    reactions = {
        ["default:mercury"] = {
            result = "default:mercury_chloride"
        },
        ["default:mercury_source"] = {
            result = "default:mercury_chloride"
        },
        ["default:mercury_flowing"] = {
            result = "default:mercury_chloride"
        },
    },
}

oxygen = {
    name = "oxygen",
    icon = "default_oxygen_symbol.png",
    color = { r = 255, g = 255, b = 255 },
    destroys = function(name)
        return false
    end,
    transparent = true,
    damage = 0,
    reactions = {
        ["default:cinnabar"] = {
            result = "default:mercury",
            gas = "default:sulfur_dioxide"
        },
        ["furnace:gas_active"] = {
            result = "furnace:gas_active",
            gas = "default:fire"
        },
    },
}

hydrogen = {
    name = "hydrogen",
    icon = "default_hydrogen_symbol.png",
    color = { r = 255, g = 255, b = 255 },
    destroys = function(name)
        return false
    end,
    transparent = true,
    damage = 0,
    reactions = {
        ["furnace:gas_active"] = {
            result = "furnace:gas_active",
            gas = "default:fire"
        },
    },
}

sulfur_dioxide = {
    name = "sulfur_dioxide",
    icon = "default_sulfur_dioxide_symbol.png",
    color = { r = 255, g = 255, b = 255 },
    destroys = function(name)
        return false
    end,
    transparent = true,
    damage = 1,
    reactions = {},
}

fluorine = {
    name = "fluorine",
    icon = "default_fluorine_symbol.png",
    color = { r = 255, g = 251, b = 164 },
    destroys = function(name)
        return is_organic(name) or is_heavy_organic(name)
    end,
    transparent = false,
    damage = 5,
    reactions = {
        ["default:mercury_oxide"] = {
            result = "default:mercury_fluoride",
            gas = "default:oxygen"
        },
        ["default:red_mercury_oxide"] = {
            result = "default:mercury_fluoride",
            gas = "default:oxygen"
        },
    },
}

fire = {
    name = "fire",
    no_balloon = true,
    color = { r = 255, g = 255, b = 255 },
    destroys = function(name)
        return
            is_organic(name) or
            is_heavy_organic(name) or
            is_fuel(name)
    end,
    transparent = false,
    damage = 10,
    light_source = 14,
    texture = function(alpha)
        local postfix
        if alpha > 90 then
            postfix = "^[colorize:#ffffff^[opacity:" .. alpha + 128
        elseif alpha > 32 then
            postfix = "^[colorize:#ffff00^[opacity:" .. alpha + 128
        else
            postfix = "^[colorize:#ff0000^[opacity:" .. alpha
        end
        return {
            "default_gas.png" .. postfix
        }
    end
}

fire.reactions = {
    ["default:hydrogen"] = {
        result = "default:fire_" .. gas_levels,
        gas = "default:fire"
    },
    ["default:oxygen"] = {
        result = "default:fire_" .. gas_levels,
        gas = "default:fire"
    },
    ["default:mercury"] = {
        result = "default:mercury_source",
        gas = "default:fire"
    },
    ["default:trisilane_source"] = {
        result = "default:fire_" .. gas_levels,
        gas = "default:fire"
    },
    ["default:trisilane_flowing"] = {
        result = "default:fire_" .. gas_levels,
        gas = "default:fire"
    }
}

evaporates = {
    "default:red_mercury_oxide",
    "default:mercury_oxide",
    "default:cinnabar",
    "default:copper_sulfate",
    "default:cobalt_blue",
    "default:ammonium_manganese_pyrophosphate"
}

for _, name in ipairs(evaporates) do
    fire.reactions[name] = {
        result = "air"
    }
end

gases = { chlorine, oxygen, hydrogen, sulfur_dioxide, fluorine, fire }
for _, gas in ipairs(gases) do
    register_gas(gas)
end