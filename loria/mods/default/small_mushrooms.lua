truncus_names = {
    "hyacinthum",
    "viridi",
    "purpura"
}

for i, name in ipairs(truncus_names) do
    minetest.register_node("default:truncus_" .. i, {
        description = "Truncus " .. name,
        drawtype = "plantlike",
        tiles = { "default_truncus_" .. i .. ".png" },
        wield_image = "default_truncus_" .. i .. ".png",
        inventory_image = "default_truncus_" .. i .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 }
    })
end

pars_names = {
    "ordinarius",
    "insignis",
    "comantem",
    "longus",
    "lenis"
}

for i, name in ipairs(pars_names) do
    minetest.register_node("default:pars_" .. i, {
        description = "Pars " .. name,
        drawtype = "plantlike",
        tiles = { "default_pars_" .. i .. ".png" },
        wield_image = "default_pars_" .. i .. ".png",
        inventory_image = "default_pars_" .. i .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 }
    })
end

for _, name in ipairs({ "rami", "spears", "viriditas" }) do
    minetest.register_node("default:" .. name, {
        description = name:gsub("^%l", string.upper),
        drawtype = "plantlike",
        tiles = { "default_" .. name .. ".png" },
        wield_image = "default_" .. name .. ".png",
        inventory_image = "default_" .. name .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 }
    })
end

minetest.register_node("default:naga", {
    description = "Naga",
    drawtype = "plantlike",
    tiles = { "default_naga.png" },
    wield_image = "default_naga.png",
    inventory_image = "default_naga.png",
    paramtype = "light",
    walkable = false,
    light_source = 5,
    groups = { snappy = 3, attached_node = 1 }
})

small_mushrooms = {
    ["pusilli"] = { damage = 5 },
    ["rosea"] = { damage = 4 },
    ["purpura"] = { features = { light_source = 5 } },
    ["picea"] = { damage = 9 },
    ["caput"] = { damage = 15 },
    ["periculum"] = { features = { light_source = 3 }, damage = 18 },
    ["vastatorem"] = { features = { light_source = 8 } },
    ["quercu"] = { damage = 7 },
    ["grebe"] = { damage = 11 },
    ["secreta"] = { damage = 12 },
    ["pulchram"] = { damage = 3 },
    ["conc"] = { damage = 16 }
}

for name, params in pairs(small_mushrooms) do
    local info = {
        description = name:gsub("^%l", string.upper),
        drawtype = "plantlike",
        tiles = { "default_" .. name .. ".png" },
        wield_image = "default_" .. name .. ".png",
        inventory_image = "default_" .. name .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 },
        on_use = function(itemstack, user, pointed_thing)
            local damage = params.damage or 1
            local hp = user:get_hp()

            if damage <= hp then
                user:set_hp(hp - damage)
            else
                user:set_hp(0)
            end

            itemstack:set_count(itemstack:get_count() - 1)
            return itemstack
        end
    }

    for key, value in pairs(params.features or {}) do
        info[key] = value
    end

    minetest.register_node("default:" .. name, info)
end