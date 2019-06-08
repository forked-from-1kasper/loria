neighbors = {
    vector.new( 1, 0, 0),
    vector.new(-1, 0, 0),
    vector.new( 0, 1, 0),
    vector.new( 0,-1, 0),
    vector.new( 0, 0, 1),
    vector.new( 0, 0,-1)
}

function get_neighbors(pos)
    local res = {}
    for _, v in ipairs(neighbors) do
        table.insert(res, vector.add(pos, v))
    end
    return res
end

local function starts_with(str, start)
    return str:sub(1, #start) == start
end

local function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

gas_table = { }
function detect_gas(name)
    for _, gas in ipairs(gas_table) do
        if starts_with(name, "default:" .. gas) then
            return gas
        end
    end
    return false
end

local function get_gas_value(gas, name)
    return tonumber(name:sub(#("default:" .. gas.name) + 2))
end

function process_gas(gas, pos, node)
    local accepted = { pos }

    local value = get_gas_value(gas, node.name)
    for _, v in ipairs(get_neighbors(pos)) do
        local node = minetest.get_node(v)

        local reaction

        local gas_name = detect_gas(node.name)
        if gas_name ~= false then
            reaction = gas.reactions["default:" .. gas_name]
        else
            reaction = gas.reactions[node.name]
        end
        if reaction ~= nil then
            minetest.swap_node(v, { name = reaction.result })
            if reaction.gas then
                minetest.set_node(pos, {
                    name = reaction.gas .. "_" .. value
                })
            else
                minetest.set_node(pos, { name = "air" })
            end
            return
        elseif starts_with(node.name, "default:" .. gas.name) or
              (node.name == "air") or
               gas.destroys(node.name) then
            table.insert(accepted, v)
        end
    end

    local value_new = value - (#accepted - 1)
    if value_new > 0 then
        for _, v in ipairs(accepted) do
            minetest.set_node(v, {
                name = "default:" .. gas.name .. "_" .. value_new
            })
        end
    else
        minetest.set_node(pos, { name = "air" })
    end
end

gas_levels = 128
gas_timer = 1
gas_vect = vector.new(16, 16, 16)
function register_gas(gas)
    table.insert(gas_table, gas.name)
    for i = 1, gas_levels do
        local level = gas_levels - i
        local alpha = 150 - (128 / gas_levels) * level
        local color = string.format(
            "#%02x%02x%02x",
            gas.color.r,
            gas.color.g,
            gas.color.b
        )

        if gas.transparent then
            alpha = 0
        end

        local tiles = {
            "default_gas.png^[colorize:" .. color .. "^[opacity:"..alpha
        }
        if gas.texture ~= nil then
            tiles = gas.texture(alpha)
        end

        minetest.register_node("default:" .. gas.name .. "_" .. i, {
            description = gas.name:gsub("^%l", string.upper) .. " gas",
            tiles = tiles,
            drawtype = "glasslike",
            paramtype = "light",
            paramtype2 = "glasslikeliquidlevel",
            damage_per_second = gas.damage,
            sunlight_propagates = true,
            walkable = false,
            alpha = alpha,
            post_effect_color = {
                a = alpha,
                r = gas.color.r,
                g = gas.color.g,
                b = gas.color.b
            },
            drop = {},
            pointable = false,
            buildable_to = true,
            light_source = gas.light_source or 0,
        })
    end

    if not gas.no_balloon then
        minetest.register_tool("default:" .. gas.name .. "_balloon", {
            inventory_image = "default_empty_balloon.png^[combine:16x16:0,0=" .. gas.icon,
            description = gas.name:gsub("^%l", string.upper) .. " balloon",
            stack_max = 1,
            on_use = function(itemstack, user, pointed_thing)
                if pointed_thing.type ~= "node" then
                    return
                end

                local wear = 65535 - itemstack:get_wear()
                local value = math.ceil(wear * gas_levels / 65536)
                minetest.add_node(pointed_thing.above, {
                    name = "default:" .. gas.name .. "_" .. value
                })
                return { name = "default:empty_balloon" }
            end
        })
    end
end

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
        ["default:hydrogen"] = {
            result = "default:water_source"
        },
        ["default:furnace_active"] = {
            result = "default:furnace_active",
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
        ["default:furnace_active"] = {
            result = "default:furnace_active",
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
    color = { r = 255, g = 0, b = 0 },
    destroys = function(name)
        return is_organic(name) or is_heavy_organic(name) or is_fuel(name)
    end,
    transparent = false,
    damage = 3,
    light_source = 14,
    reactions = {
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
        }
    },
    texture = function(alpha)
        return {
            "default_gas.png^[colorize:#ffff00^[opacity:"..(alpha + 128)
        }
    end
}

gases = { chlorine, oxygen, hydrogen, sulfur_dioxide, fluorine, fire }
for _, gas in ipairs(gases) do
    register_gas(gas)
end

local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer > gas_timer then
        timer = 0

        for _, player in ipairs(minetest.get_connected_players()) do
            local pos = player:get_pos()

            local minp = vector.subtract(pos, gas_vect)
            local maxp = vector.add(pos, gas_vect)
            for x = minp.x, maxp.x do
                for y = minp.y, maxp.y do
                    for z = minp.z, maxp.z do
                        local pos = vector.new(x, y, z)
                        local node = minetest.get_node(pos)

                        for _, gas in ipairs(gases) do
                            if starts_with(node.name, "default:" .. gas.name) then
                                if math.random() <= 0.5 then
                                    process_gas(gas, pos, node)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

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
                        name = "default:" .. gas .. "_" .. gas_levels
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
            minetest.set_node(pos, { name = "default:chlorine_" .. gas_levels })
        end
    end
})