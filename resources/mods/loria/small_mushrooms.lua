function destruct_column(name, pos)
    pos.y = pos.y + 1
    while core.get_node(pos).name == name do
        core.set_node(pos, { name = "air" })
        core.add_item(pos, { name = name })
        pos.y = pos.y + 1
    end
end

function destruct_hanging(name, pos)
    pos.y = pos.y - 1
    while core.get_node(pos).name == name do
        core.set_node(pos, { name = "air" })
        core.add_item(pos, { name = name })
        pos.y = pos.y - 1
    end
end

core.register_on_dignode(function(pos, oldnode, digger)
    local node_above_name = core.get_node(above(pos)).name
    local node_under_name = core.get_node(under(pos)).name

    if core.get_item_group(oldnode.name, "column") > 0 then
        destruct_column(oldnode.name, pos)
    elseif core.get_item_group(oldnode.name, "hanging") > 0 then
        destruct_hanging(oldnode.name, pos)
    elseif core.get_item_group(node_above_name, "column") > 0 then
        destruct_column(node_above_name, pos)
    elseif core.get_item_group(node_under_name, "hanging") > 0 then
        destruct_hanging(node_under_name, pos)
    end
end)

local function can_grow(placename, nodename)
    local key, _ = nodename:match("^loria:([^%d]+)_%d+$")
    key = nodename:match("^loria:([^%d]+)$") or key

    local walkable = core.registered_nodes[placename].walkable
    return walkable and not (key and grasses[key] and grasses[key].place_on ~= placename)
end

core.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    if core.get_item_group(newnode.name, "column") > 0 then
        local under = core.get_node(under(pos))
        if not (can_grow(under.name, newnode.name) or under.name == newnode.name) then
            core.set_node(pos, { name = "air" })
            core.add_item(pos, { name = newnode.name })
        end
    elseif core.get_item_group(newnode.name, "hanging") > 0 then
        local above = core.get_node(above(pos))
        if not (can_grow(above.name, newnode.name) or above.name == newnode.name) then
            core.set_node(pos, { name = "air" })
            core.add_item(pos, { name = newnode.name })
        end
    end
end)

on_grasses(function(name, desc, _)
    core.register_node("loria:" .. name, {
        description = capitalization(desc),
        drawtype = "plantlike",
        tiles = { "loria_" .. name .. ".png" },
        wield_image = "loria_" .. name .. ".png",
        inventory_image = "loria_" .. name .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, column = 1 },
        sunlight_propagates = true,
    })

    core.register_abm{
        label = desc .. " growth",
        nodenames = { "loria:" .. name },
        interval = 15,
        chance = 500,
        action = function(pos)
            local name = core.get_node(pos).name
            if core.get_node(above(pos)).name == "air" then
                local height = 0
                local curr = pos

                while core.get_node(curr).name == name do
                    height = height + 1
                    curr = under(curr)
                end

                if math.random() <= (1 / height) then
                    core.set_node(above(pos), core.get_node(pos))
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
    core.register_node("loria:pars_" .. i, {
        description = "Pars " .. name,
        drawtype = "plantlike",
        tiles = { "loria_pars_" .. i .. ".png" },
        wield_image = "loria_pars_" .. i .. ".png",
        inventory_image = "loria_pars_" .. i .. ".png",
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
    core.register_node("loria:odorantur_" .. i, {
        description = "Odorantur " .. name,
        drawtype = "plantlike",
        tiles = { "loria_odorantur_" .. i .. ".png" },
        wield_image = "loria_odorantur_" .. i .. ".png",
        inventory_image = "loria_odorantur_" .. i .. ".png",
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
    core.register_node("loria:petite_" .. i, {
        description = "Petite " .. name,
        drawtype = "plantlike",
        tiles = { "loria_petite_" .. i .. ".png" },
        wield_image = "loria_petite_" .. i .. ".png",
        inventory_image = "loria_petite_" .. i .. ".png",
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
    "fluctuatur",
    "caeruleum",
    "clara"
}

for i, name in ipairs(qui_lucem_names) do
    core.register_node("loria:qui_lucem_" .. i, {
        description = "Qui lucem " .. name,
        drawtype = "plantlike",
        tiles = { "loria_qui_lucem_" .. i .. ".png" },
        wield_image = "loria_qui_lucem_" .. i .. ".png",
        inventory_image = "loria_qui_lucem_" .. i .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 },
        sunlight_propagates = true,
    })
end

core.register_node("loria:imitationis", {
    description = "Imitationis",
    drawtype = "plantlike",
    tiles = { "loria_imitationis.png" },
    wield_image = "loria_imitationis.png",
    inventory_image = "loria_imitationis.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, attached_node = 1 },
    sunlight_propagates = true,
})

core.register_node("loria:nihil", {
    description = "Nihil",
    drawtype = "plantlike",
    tiles = { "loria_nihil.png" },
    wield_image = "loria_nihil.png",
    inventory_image = "loria_nihil.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, attached_node = 1 },
    sunlight_propagates = true,
})

core.register_node("loria:viriditas", {
    description = "Viriditas",
    drawtype = "plantlike",
    tiles = { "loria_viriditas.png" },
    wield_image = "loria_viriditas.png",
    inventory_image = "loria_viriditas.png",
    paramtype = "light",
    walkable = false,
    groups = { snappy = 3, attached_node = 1 },
    sunlight_propagates = true,
})

core.register_node("loria:naga", {
    description = "Naga",
    drawtype = "plantlike",
    tiles = { "loria_naga.png" },
    wield_image = "loria_naga.png",
    inventory_image = "loria_naga.png",
    paramtype = "light",
    walkable = false,
    light_source = 5,
    groups = { snappy = 3, hanging = 1 },
    sunlight_propagates = true,
})

on_grasses(function(name, desc, _)
    core.register_node("loria:" .. name .. "_pressed", {
        description = "Pressed " .. desc,
        tiles = { "loria_" .. name .. "_pressed.png" },
        groups = { crumbly = 3 },
    })
end)

for name, params in pairs(small_mushrooms) do
    local info = {
        description = capitalization(name),
        drawtype = "plantlike",
        tiles = { "loria_" .. name .. ".png" },
        wield_image = "loria_" .. name .. ".png",
        inventory_image = "loria_" .. name .. ".png",
        paramtype = "light",
        walkable = false,
        groups = { snappy = 3, attached_node = 1 },
        on_use = function(itemstack, user, pointed_thing)
            local damage = params.damage or 1
            user:set_hp(user:get_hp() - damage)

            itemstack:set_count(itemstack:get_count() - 1)
            return itemstack
        end,
        sunlight_propagates = true
    }

    for key, value in pairs(params.features or {}) do
        info[key] = value
    end

    core.register_node("loria:" .. name, info)
    core.register_abm({
        label = capitalization(name) .. " spread",
        nodenames = { "loria:" .. name },
        interval = 11,
        chance = 150,
        action = function(pos)
            local positions = core.find_nodes_in_area_under_air(
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

            local optimal_radiation = params.optimal_radiation or 3.0
            local max_radiation = params.max_radiation or 5.0

            local vm   = core.get_voxel_manip()
            local area = getVoxelArea(vm, pos)
            local data = vm:get_data()

            local radiation = EquivalentDose(radiantFluxAtPos(area, data, pos))

            if radiation > max_radiation then
                core.set_node(pos, { name = "air" })
            elseif core.get_node_light(pos) <= optimal_light and
                   radiation >= optimal_radiation then
                core.set_node(pos2, { name = "loria:" .. name })
            end
        end
    })

    if params.place_on and params.fill_ratio and params.biomes then
        core.register_decoration({
            deco_type = "simple",
            place_on = params.place_on,
            sidelen = params.sidelen or 16,
            fill_ratio = params.fill_ratio,
            biomes = params.biomes,
            decoration = "loria:" .. name,
            height = 1,
            y_min = params.y_min or -20,
            y_max = params.y_max,
            noise_params = params.noise_params
        })
    end
end

terribilis_names = {
    chloric = { gas = "loria:chlorine" },
    fluoro = { gas = "loria:fluorine" },
}

for name, params in pairs(terribilis_names) do
    core.register_node("loria:terribilis_" .. name, {
        description = "Terribilis " .. name,
        tiles = {
            "loria_cobalt_blue.png^loria_terribilis_" .. name .. ".png"
        },
        groups = { cracky = 2 },

        on_punch = function(pos, node, puncher, pointed_thing)
            for _, dir in ipairs(neighbors) do
                local vect = vector.add(pos, dir)
                if core.get_node(vect).name == "air" then
                    core.set_node(vect, {
                        name = params.gas, param2 = params.value or 200
                    })
                end
            end
        end,

        after_destruct = function(pos, oldnode)
            core.set_node(pos, { name = "loria:cobalt_blue" })
        end,

        drop = "",
    })

    core.register_ore({
        ore_type       = "blob",
        ore            = "loria:terribilis_" .. name,
        wherein        = "loria:cobalt_blue",
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

core.register_ore({
    ore_type       = "blob",
    ore            = "loria:humus",
    wherein        = "loria:copper_sulfate",
    clust_scarcity = 8 * 8 * 8,
    clust_num_ores = 50,
    clust_size     = 4,
    y_min          = -15,
    y_max          = 31000,
    noise_threshold = 0.0,
    noise_params    = {
        offset = 0.5,
        scale = 0.2,
        spread = { x = 3, y = 3, z = 3 },
        seed = 666,
        octaves = 1,
        persist = 0.0
    }
})