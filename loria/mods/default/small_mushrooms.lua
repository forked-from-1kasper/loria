function destruct_column(name, pos)
    pos.y = pos.y + 1
    while minetest.get_node(pos).name == name do
        minetest.set_node(pos, { name = "air" })
        minetest.add_item(pos, { name = name })
        pos.y = pos.y + 1
    end
end

minetest.register_on_dignode(function(pos, oldnode, digger)
    local above = vector.add(pos, vector.new(0, 1, 0))
    local node_above_name = minetest.get_node(above).name

    if minetest.get_item_group(oldnode.name, "column") > 0 then
        destruct_column(oldnode.name, pos)
    elseif minetest.get_item_group(node_above_name, "column") > 0 then
        destruct_column(node_above_name, pos)
    end
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if minetest.get_item_group(newnode.name, "column") > 0 then
        local under = minetest.get_node(vector.add(pos, vector.new(0, -1, 0)))
        if not (under.walkable or under.name == newnode.name) then
            minetest.set_node(pos, { name = "air" })
            minetest.add_item(pos, { name = newnode.name })
        end
    end
end)

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
        groups = { snappy = 3, column = 1 },
        sunlight_propagates = true,
    })
end

minetest.register_node("default:lectica", {
    description = "Lectica",
    drawtype = "plantlike",
    tiles = { "default_lectica.png" },
    wield_image = "default_lectica.png",
    inventory_image = "default_lectica.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, column = 1 },
    sunlight_propagates = true,
})

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
        groups = { snappy = 3, attached_node = 1 },
        sunlight_propagates = true,
    })
end

petite_names = {
    "longus",
    "humilis"
}

for i, name in ipairs(petite_names) do
    minetest.register_node("default:petite_" .. i, {
        description = "Petite " .. name,
        drawtype = "plantlike",
        tiles = { "default_petite_" .. i .. ".png" },
        wield_image = "default_petite_" .. i .. ".png",
        inventory_image = "default_petite_" .. i .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 },
        sunlight_propagates = true,
    })
end

minetest.register_node("default:imitationis", {
    description = "Imitationis",
    drawtype = "plantlike",
    tiles = { "default_imitationis.png" },
    wield_image = "default_imitationis.png",
    inventory_image = "default_imitationis.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, attached_node = 1 },
    sunlight_propagates = true,
})

minetest.register_node("default:nihil", {
    description = "Nihil",
    drawtype = "plantlike",
    tiles = { "default_nihil.png" },
    wield_image = "default_nihil.png",
    inventory_image = "default_nihil.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, attached_node = 1 },
    sunlight_propagates = true,
})

minetest.register_node("default:viriditas", {
    description = "Viriditas",
    drawtype = "plantlike",
    tiles = { "default_viriditas.png" },
    wield_image = "default_viriditas.png",
    inventory_image = "default_viriditas.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, attached_node = 1 },
    sunlight_propagates = true,
})

for _, name in ipairs({ "rami", "spears" }) do
    minetest.register_node("default:" .. name, {
        description = capitalization(name),
        drawtype = "plantlike",
        tiles = { "default_" .. name .. ".png" },
        wield_image = "default_" .. name .. ".png",
        inventory_image = "default_" .. name .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, column = 1 },
        sunlight_propagates = true,
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
    groups = { snappy = 3, attached_node = 1 },
    sunlight_propagates = true,
})

small_mushrooms = {
    ["pusilli"] = {
        damage = 5,
        place_on = {
            "default:cinnabar",
            "default:red_mercury_oxide",
            "default:mercury_oxide"
        },
        optimal_light = 11,
        fill_ratio = 0.01,
        biomes = "default:redland",
        optimal_radiation = 5,
        max_radiation = 10,
    },
    ["rosea"] = {
        damage = 4,
        place_on = "default:copper_sulfate",
        fill_ratio = 0.05,
        biomes = "default:azure",
    },
    ["purpura"] = {
        features = { light_source = 5 },
        place_on = "default:copper_sulfate",
        fill_ratio = 0.05,
        biomes = "default:azure",
    },
    ["picea"] = {
        damage = 9,
        place_on = "default:copper_sulfate",
        fill_ratio = 0.05,
        biomes = "default:azure",
    },
    ["caput"] = {
        damage = 15,
        place_on = {
            "default:cinnabar",
            "default:red_mercury_oxide",
            "default:mercury_oxide"
        },
        optimal_light = 11,
        fill_ratio = 0.01,
        biomes = "default:redland",
        optimal_radiation = 5,
        max_radiation = 10,
    },
    ["periculum"] = {
        features = { light_source = 3 },
        damage = 18,
        place_on = "default:ammonium_manganese_pyrophosphate",
        fill_ratio = 0.01,
        biomes = "default:purple_swamp",
    },
    ["vastatorem"] = { features = { light_source = 8 } },
    ["quercu"] = {
        damage = 7,
        place_on = {
            "default:cinnabar",
            "default:red_mercury_oxide",
            "default:mercury_oxide"
        },
        optimal_light = 11,
        biomes = "default:redland",
    },
    ["grebe"] = {
        damage = 11,
        place_on = "default:ammonium_manganese_pyrophosphate",
        fill_ratio = 0.01,
        biomes = "default:purple_swamp",
    },
    ["secreta"] = {
        damage = 12,
        place_on = "default:ammonium_manganese_pyrophosphate",
        fill_ratio = 0.01,
        biomes = "default:purple_swamp",
    },
    ["pulchram"] = { damage = 3 },
    ["conc"] = { damage = 16 }
}

for name, params in pairs(small_mushrooms) do
    local info = {
        description = capitalization(name),
        drawtype = "plantlike",
        tiles = { "default_" .. name .. ".png" },
        wield_image = "default_" .. name .. ".png",
        inventory_image = "default_" .. name .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 },
        on_use = function(itemstack, user, pointed_thing)
            local damage = params.damage or 1
            user:set_hp(user:get_hp() - damage)

            itemstack:set_count(itemstack:get_count() - 1)
            return itemstack
        end,
        sunlight_propagates = true,
    }

    for key, value in pairs(params.features or {}) do
        info[key] = value
    end

    minetest.register_node("default:" .. name, info)
    minetest.register_abm({
        label = capitalization(name) .. " spread",
        nodenames = { "default:" .. name },
        interval = 11,
        chance = 150,
        action = function(pos)
            local positions = minetest.find_nodes_in_area_under_air(
                { x = pos.x - 1, y = pos.y - 2, z = pos.z - 1 },
                { x = pos.x + 1, y = pos.y + 1, z = pos.z + 1 },
                params.place_on
            )

            if #positions == 0 then
                return
            end

            local pos2 = positions[math.random(#positions)]
            pos2.y = pos2.y + 1

            local optimal_light = params.optimal_light or 7

            local optimal_radiation = params.optimal_radiation or 0.1
            local max_radiation = params.max_radiation or 2.00

            local radiation = total(calculate_radiation(minetest.get_voxel_manip(), pos))

            if radiation > max_radiation then
                minetest.set_node(pos, { name = "air" })
            elseif minetest.get_node_light(pos) <= optimal_light and
               radiation >= optimal_radiation then
                minetest.set_node(pos2, { name = "default:" .. name })
            end
        end
    })

    if params.place_on and params.fill_ratio and params.biomes then
        minetest.register_decoration({
            deco_type = "simple",
            place_on = params.place_on,
            sidelen = 16,
            fill_ratio = params.fill_ratio,
            biomes = params.biomes,
            decoration = "default:" .. name,
            height = 1,
            y_min = params.y_min or -20,
        })
    end
end

terribilis_names = {
    chloric = { gas = "default:chlorine" },
    fluoro = { gas = "default:fluorine" },
}

for name, params in pairs(terribilis_names) do
    minetest.register_node("default:terribilis_" .. name, {
        description = "Terribilis " .. name,
        tiles = {
            "default_cobalt_blue.png^default_terribilis_" .. name .. ".png"
        },
        groups = { cracky = 2 },

        on_punch = function(pos, node, puncher, pointed_thing)
            for _, dir in ipairs(neighbors) do
                local vect = vector.add(pos, dir)
                if minetest.get_node(vect).name == "air" then
                    minetest.set_node(vect, {
                        name = params.gas, param2 = params.value or 200
                    })
                end
            end
        end,

        after_destruct = function(pos, oldnode)
            minetest.set_node(pos, { name = "default:cobalt_blue" })
        end,

        drop = "",
    })

    minetest.register_ore({
        ore_type       = "blob",
        ore            = "default:terribilis_" .. name,
        wherein        = "default:cobalt_blue",
        clust_scarcity = 16 * 16 * 16,
        clust_num_ores = 50,
        clust_size     = 3,
        y_min          = params.y_min or -400,
        y_max          = params.y_max or 400,
        noise_threshold = 0.0,
        noise_params    = {
            offset = 0.5,
            scale = 0.2,
            spread = { x = 3, y = 3, z = 3 },
            seed = 17676,
            octaves = 1,
            persist = 0.0
        }
    })
end