function destruct_column(name, pos)
    pos.y = pos.y + 1
    while minetest.get_node(pos).name == name do
        minetest.set_node(pos, { name = "air" })
        minetest.add_item(pos, { name = name })
        pos.y = pos.y + 1
    end
end

function destruct_hanging(name, pos)
    pos.y = pos.y - 1
    while minetest.get_node(pos).name == name do
        minetest.set_node(pos, { name = "air" })
        minetest.add_item(pos, { name = name })
        pos.y = pos.y - 1
    end
end

minetest.register_on_dignode(function(pos, oldnode, digger)
    local node_above_name = minetest.get_node(above(pos)).name
    local node_under_name = minetest.get_node(under(pos)).name

    if minetest.get_item_group(oldnode.name, "column") > 0 then
        destruct_column(oldnode.name, pos)
    elseif minetest.get_item_group(oldnode.name, "hanging") > 0 then
        destruct_hanging(oldnode.name, pos)
    elseif minetest.get_item_group(node_above_name, "column") > 0 then
        destruct_column(node_above_name, pos)
    elseif minetest.get_item_group(node_under_name, "hanging") > 0 then
        destruct_hanging(node_under_name, pos)
    end
end)

local function can_grow(placename, nodename)
    local key, _ = nodename:match("^default:([^%d]+)_%d+$")
    key = nodename:match("^default:([^%d]+)$") or key

    local walkable = minetest.registered_nodes[placename].walkable
    return walkable and not (key and grasses[key] and grasses[key].place_on ~= placename)
end

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if minetest.get_item_group(newnode.name, "column") > 0 then
        local under = minetest.get_node(under(pos))
        if not (can_grow(under.name, newnode.name) or under.name == newnode.name) then
            minetest.set_node(pos, { name = "air" })
            minetest.add_item(pos, { name = newnode.name })
        end
    elseif minetest.get_item_group(newnode.name, "hanging") > 0 then
        local above = minetest.get_node(above(pos))
        if not (can_grow(above.name, newnode.name) or above.name == newnode.name) then
            minetest.set_node(pos, { name = "air" })
            minetest.add_item(pos, { name = newnode.name })
        end
    end
end)

on_grasses(function(name, desc, _)
    minetest.register_node("default:" .. name, {
        description = capitalization(desc),
        drawtype = "plantlike",
        tiles = { "default_" .. name .. ".png" },
        wield_image = "default_" .. name .. ".png",
        inventory_image = "default_" .. name .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, column = 1 },
        sunlight_propagates = true,
    })

    minetest.register_abm{
        label = desc .. " growth",
        nodenames = { "default:" .. name },
        interval = 15,
        chance = 500,
        action = function(pos)
            local name = minetest.get_node(pos).name
            if minetest.get_node(above(pos)).name == "air" then
                local height = 0
                local curr = pos

                while minetest.get_node(curr).name == name do
                    height = height + 1
                    curr = under(curr)
                end

                if math.random() <= (1 / height) then
                    minetest.set_node(above(pos), minetest.get_node(pos))
                end
            end
        end,
    }
end)

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

odorantur_names = {
    "comantem",
    "aspero",
    "aequaliter",
    "agrariae",
    "conicum",
    "acribus"
}

for i, name in ipairs(odorantur_names) do
    minetest.register_node("default:odorantur_" .. i, {
        description = "Odorantur " .. name,
        drawtype = "plantlike",
        tiles = { "default_odorantur_" .. i .. ".png" },
        wield_image = "default_odorantur_" .. i .. ".png",
        inventory_image = "default_odorantur_" .. i .. ".png",
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

qui_lucem_names = {
    "vulgaris",
    "genu",
    "hyacinthum",
    "lucidum",
    "fluctuatur"
}

for i, name in ipairs(qui_lucem_names) do
    minetest.register_node("default:qui_lucem_" .. i, {
        description = "Qui lucem " .. name,
        drawtype = "plantlike",
        tiles = { "default_qui_lucem_" .. i .. ".png" },
        wield_image = "default_qui_lucem_" .. i .. ".png",
        inventory_image = "default_qui_lucem_" .. i .. ".png",
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

minetest.register_node("default:naga", {
    description = "Naga",
    drawtype = "plantlike",
    tiles = { "default_naga.png" },
    wield_image = "default_naga.png",
    inventory_image = "default_naga.png",
    paramtype = "light",
    walkable = false,
    light_source = 5,
    groups = { snappy = 3, hanging = 1 },
    sunlight_propagates = true,
})

on_grasses(function(name, desc, _)
    minetest.register_node("default:" .. name .. "_pressed", {
        description = "Pressed " .. desc,
        tiles = { "default_" .. name .. "_pressed.png" },
        groups = { crumbly = 3 },
    })
end)

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