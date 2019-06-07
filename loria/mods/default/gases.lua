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

gas_levels = 128
function register_gas(gas)
    for i = 1, gas_levels do
        local level = gas_levels - i
        local alpha = 150 - (128 / gas_levels) * level

        if gas.transparent then
            alpha = 0
        end

        minetest.register_node("default:" .. gas.name .. "_" .. i, {
            description = gas.name:gsub("^%l", string.upper) .. " gas",
            tiles = { "default_gas.png^[colorize:" .. gas.color .. "^[opacity:"..alpha },
            drawtype = "glasslike",
            paramtype = "light",
            paramtype2 = "glasslikeliquidlevel",
            damage_per_second = gas.damage,
            sunlight_propagates = true,
            walkable = false,
            alpha = alpha,
            post_effect_color = {
                a = alpha,
                r = gas.post_effect_color.r,
                g = gas.post_effect_color.g,
                b = gas.post_effect_color.b
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
                for _, pos in ipairs(get_neighbors(pos)) do
                    local node = minetest.get_node(pos)
                    if (node.name == "air") or
                       starts_with(node.name, "default:" .. gas.name) or
                       gas.destroys(node.name) then
                        table.insert(accepted, pos)
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

            minetest.add_node(pointed_thing.above, {
                name = "default:" .. gas.name .. "_" .. gas_levels
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
        ends_with(name, "_body") or
        (small_mushrooms[name:sub(#"default:" + 1)] ~= nil)
end

chlorine = {
    name = "chlorine",
    color = "#d2ff00",
    icon = "default_chlorine_symbol.png",
    post_effect_color = { r = 210, g = 255, b = 0 },
    destroys = is_organic,
    transparent = false,
    damage = 1,
}

oxygen = {
    name = "oxygen",
    color = "#ffffff",
    icon = "default_oxygen_symbol.png",
    post_effect_color = { r = 255, g = 255, b = 255 },
    destroys = function(name)
        return false
    end,
    transparent = true,
    damage = 0,
}

hydrogen = {
    name = "hydrogen",
    color = "#ffffff",
    icon = "default_hydrogen_symbol.png",
    post_effect_color = { r = 255, g = 255, b = 255 },
    destroys = function(name)
        return false
    end,
    transparent = true,
    damage = 0,
}

fluorine = {
    name = "fluorine",
    color = "#fffba4",
    icon = "default_fluorine_symbol.png",
    post_effect_color = { r = 255, g = 251, b = 164 },
    destroys = is_organic,
    transparent = false,
    damage = 5,
}

gases = { chlorine, oxygen, hydrogen, fluorine }
for _, gas in ipairs(gases) do
    register_gas(gas)
end