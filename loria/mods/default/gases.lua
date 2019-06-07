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

gas_levels = 128
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

        minetest.register_node("default:" .. gas.name .. "_" .. i, {
            description = gas.name:gsub("^%l", string.upper) .. " gas",
            tiles = { "default_gas.png^[colorize:" .. color .. "^[opacity:"..alpha },
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
        })

        minetest.register_abm{
            nodenames = { "default:" .. gas.name .. "_" .. i },
            interval = 1,
            chance = 2,
            action = function(pos)
                local accepted = { pos }
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
                        minetest.set_node(v, { name = reaction.result })
                        if reaction.gas then
                            minetest.set_node(pos, { name = reaction.gas .. "_" .. i })
                        end
                        return
                    elseif (node.name == "air") or
                       starts_with(node.name, "default:" .. gas.name) or
                       gas.destroys(node.name) then
                        table.insert(accepted, v)
                    end
                end

                local j = i - (#accepted - 1)
                if j > 0 then
                    for _, pos in ipairs(accepted) do
                        minetest.set_node(pos, {
                            name = "default:" .. gas.name .. "_" .. j
                        })
                    end
                else
                    minetest.set_node(pos, { name = "air" })
                end
            end
        }
    end

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

chlorine = {
    name = "chlorine",
    icon = "default_chlorine_symbol.png",
    color = { r = 210, g = 255, b = 0 },
    destroys = is_organic,
    transparent = false,
    damage = 2,
    reactions = {},
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
        }
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
    reactions = {},
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

gases = { chlorine, oxygen, hydrogen, sulfur_dioxide, fluorine }
for _, gas in ipairs(gases) do
    register_gas(gas)
end