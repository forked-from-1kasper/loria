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
        starts_with(name, "default:petite") or
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
    palette = "chlorine_palette.png",
    post_effect_color = { a = 50, r = 210, g = 255, b = 0 },
    destroys = is_organic,
    heavy = true,
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
        ["default:glow_stick"] = {
            result = "default:blowed_out_glow_stick",
            gas = "default:chlorine"
        }
    },
}

oxygen = {
    name = "oxygen",
    icon = "default_oxygen_symbol.png",
    destroys = const(false),
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
    destroys = const(false),
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
    destroys = const(false),
    heavy = true,
    transparent = true,
    damage = 1,
    reactions = {},
}

fluorine = {
    name = "fluorine",
    icon = "default_fluorine_symbol.png",
    post_effect_color = { a = 50, r = 255, g = 251, b = 164 },
    palette = "fluorine_palette.png",
    destroys = function(name)
        return is_organic(name) or is_heavy_organic(name)
    end,
    heavy = true,
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
        ["default:glow_stick"] = {
            result = "default:blowed_out_glow_stick",
            gas = "default:fluorine"
        }
    },
}

fire = {
    name = "fire",
    no_balloon = true,
    post_effect_color = { a = 150, r = 255, g = 255, b = 255 },
    palette = "fire_palette.png",
    destroys = function(name)
        return
            is_organic(name) or
            is_heavy_organic(name) or
            is_fuel(name)
    end,
    damage = 10,
    light_source = 14,
    alpha = 230,
}

fire.reactions = {
    ["default:hydrogen"] = {
        result = "default:fire",
        gas = "default:fire"
    },
    ["default:oxygen"] = {
        result = "default:fire",
        gas = "default:fire"
    },
    ["default:trisilane_source"] = {
        result = "default:fire",
        gas = "default:fire"
    },
    ["default:trisilane_flowing"] = {
        result = "default:fire",
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
    fire.reactions[name] = { result = "air" }
end

for name, _ in pairs(ores) do
    fire.reactions["default:" .. name] = { result = "air" }
    fire.reactions["default:" .. name .. "_cinnabar"] = { result = "air" }
    fire.reactions["default:" .. name .. "_azure"] = { result = "air" }
end

gases = { chlorine, oxygen, hydrogen, sulfur_dioxide, fluorine, fire }
foreach(register_gas, gases)