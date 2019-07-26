local no_top_neighbors = {
    vector.new( 1, 0, 0),
    vector.new(-1, 0, 0),
    vector.new( 0,-1, 0),
    vector.new( 0, 0, 1),
    vector.new( 0, 0,-1)
}

function get_neighbors(pos, heavy)
    local add = function(v) return vector.add(pos, v) end
    return map(add, heavy and no_top_neighbors or neighbors)
end

is_heavy = { }
function detect_gas(name)
    return minetest.get_item_group(name, "gas") > 0 and
           minetest.registered_nodes[name].description
end

local function process_gas(gas, pos)
    local accepted = { pos }

    local node = minetest.get_node(pos)
    for _, v in ipairs(get_neighbors(pos, is_heavy[gas.name])) do
        local neighbor = minetest.get_node(v)
        local reaction = gas.reactions[neighbor.name]

        if reaction ~= nil then
            minetest.swap_node(v, {
                name = reaction.result,
                param1 = neighbor.param1,
                param2 = neighbor.param2,
            })
            if reaction.gas then
                minetest.swap_node(pos, {
                    name = reaction.gas,
                    param1 = node.param1,
                    param2 = node.param2,
                })
            else
                minetest.set_node(pos, { name = "air" })
            end
            return
        elseif neighbor.name == node.name or
               neighbor.name == "air" or
               gas.destroys(neighbor.name) then
            table.insert(accepted, v)
        end
    end

    node.param2 = node.param2 - #accepted + 1
    if node.param2 >= 128 then
        for _, v in ipairs(accepted) do
            minetest.swap_node(v, node)
        end
    else
        minetest.set_node(pos, { name = "air" })
    end
end

local gas_levels = 255
local gas_vect = vector.new(16, 16, 16)
function register_gas(gas)
    is_heavy[gas.name] = gas.heavy or false
    minetest.register_node("default:" .. gas.name, {
        description = gas.name,
        tiles = { "default_gas.png^[opacity:" .. (gas.alpha or 128) },
        drawtype = gas.transparent and "airlike" or "glasslike",
        paramtype = "light",
        paramtype2 = "color",
        palette = gas.palette,
        damage_per_second = gas.damage,
        sunlight_propagates = true,
        use_texture_alpha = true,
        walkable = false,
        post_effect_color = gas.post_effect_color,
        drop = {},
        pointable = false,
        buildable_to = true,
        light_source = gas.light_source or 0,
        groups = { not_in_creative_inventory = 1, gas = 1 },
    })

    minetest.register_abm({
        nodenames = { "default:" .. gas.name },
        interval = 1,
        chance = 2,
        action = function(pos)
            process_gas(gas, pos)
        end
    })

    if not gas.no_balloon then
        minetest.register_tool("default:" .. gas.name .. "_balloon", {
            inventory_image = "default_empty_balloon.png^[combine:16x16:0,0=" .. gas.icon,
            description = capitalization(gas.name) .. " balloon",
            stack_max = 1,
            on_use = function(itemstack, user, pointed_thing)
                if pointed_thing.type ~= "node" then
                    return
                end

                local wear = 65535 - itemstack:get_wear()
                local value = math.ceil(wear * 128 / 65535)
                minetest.add_node(pointed_thing.above, {
                    name = "default:" .. gas.name, param2 = 127 + value
                })
                return { name = "default:empty_balloon" }
            end
        })
    end
end

local attack_radius = 30
local attack_step = 10
minetest.register_chatcommand("chemical_attack", {
    params = "<gas>",
    description = "Sends gas",
    privs = {},
    func = function(name, gas)
        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()
            for x = pos.x - attack_radius, pos.x + attack_radius, attack_step do
                for z = pos.z - attack_radius, pos.z + attack_radius, attack_step do
                    minetest.set_node({ x = x, y = pos.y, z = z }, {
                        name = "default:" .. gas, param2 = gas_levels
                    })
                end
            end
            minetest.chat_send_player(name, "Done")
        end
    end,
})

minetest.register_chatcommand("fill", {
    params = "<nodename>",
    description = "Fill 10 × 10 square",
    privs = {},
    func = function(name, nodename)
        local radius = 10
        if not nodename then
            minetest.chat_send_player(name, "Invalid command")
            return
        end

        local player = minetest.get_player_by_name(name)
        if player then
            local pos = player:get_pos()
            for x = pos.x - radius, pos.x + radius do
                for z = pos.z - radius, pos.z + radius do
                    minetest.set_node({ x = x, y = pos.y - 1, z = z }, {
                        name = nodename
                    })
                end
            end
            minetest.chat_send_player(name, "Done")
        end
    end,
})

minetest.register_chatcommand("cid", {
    params = "<node>",
    description = "Returns content id.",
    privs = {},
    func = function(name, node)
        minetest.chat_send_player(name, tostring(minetest.get_content_id(node)))
    end,
})

minetest.register_abm({
    label = "Chlorine source",
    nodenames = { "default:test" },
    interval = 1,
    chance = 1,
    action = function(pos)
        pos = vector.add(pos, vector.new(0, 1, 0))
        if minetest.get_node(pos).name == "air" then
            minetest.set_node(pos, { name = "default:chlorine", param2 = gas_levels })
        end
    end
})

minetest.register_abm({
    label = "Oxygen source",
    nodenames = { "default:infinite_oxygen" },
    interval = 1,
    chance = 1,
    action = function(pos)
        vects = {
            vector.new(0, 1, 0),
            vector.new(1, 0, 0),
            vector.new(-1, 0, 0),
            vector.new(0, 0, 1),
            vector.new(0, 0, -1),
        }

        for _, vect in ipairs(vects) do
            local v = vector.add(pos, vect)
            if minetest.get_node(v).name == "air" then
                minetest.set_node(v, { name = "default:oxygen", param2 = gas_levels })
            end
        end
    end
})