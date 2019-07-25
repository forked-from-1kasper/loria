local gases_list = {
    ["default:oxygen_balloon"] = balloon_coeff * 3
}

local fuel_list = {
    ["default:cinnabar"] = 1,
    ["default:potassium"] = 2,
    ["default:potassium_cinnabar"] = 3,
    ["default:potassium_azure"] = 4,
    ["default:potassium_ingot"] = 5,
    ["default:bucket_trisilane"] = 10,
}

local function is_furnace_ready(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    local gas = inv:get_list("gas")[1]:get_name()
    local fuel = inv:get_list("fuel")[1]:get_name()

    return gases_list[gas] ~= nil and fuel_list[fuel] ~= nil
end

function update_gas(pos, elapsed)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    local gas = inv:get_list("gas")[1]
    local wear = gas:get_wear() + gases_list[gas:get_name()]

    if wear >= 65535 then
        inv:set_stack("gas", 1, { name = "default:empty_balloon" })
        return false
    else
        gas:set_wear(wear)
    end
    inv:set_stack("gas", 1, gas)

    return true
end

function update_fuel(pos, elapsed)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    local fuel = inv:get_list("fuel")[1]

    local cycle = meta:get_float("cycle") + elapsed
    local fuel_name = fuel:get_name()

    if bucket.is_bucket[fuel_name] then
        local wear = fuel:get_wear()
        local wear_delta = (elapsed / fuel_list[fuel_name]) * 65535

        if wear + wear_delta >= 65535 then
            add_or_drop(
                inv, "output",
                { name = "default:bucket_empty" },
                vector.add(pos, vector.new(0, 1, 0))
            )
            inv:set_list("fuel", { })
            return false
        else
            fuel:add_wear(wear_delta)
            inv:set_stack("fuel", 1, fuel)

            cycle = (1 - fuel:get_wear() / 65535) * fuel_list[fuel_name]
        end
    end

    if cycle > fuel_list[fuel_name] then
        cycle = 0
        local count = fuel:get_count() - 1
        fuel:set_count(count)
        inv:set_stack("fuel", 1, fuel)

        if count == 0 then
            return false
        end
    end

    meta:set_float("cycle", cycle)
    return true
end

register_furnace({
    name = "gas",
    description = "Gas furnace",
    lists = { gas = 1, fuel = 1 },
    on_tick = { update_fuel, update_gas },
    is_furnace_ready = is_furnace_ready,
    additional_formspec = function(meta)
        return
            "label[0,1.5;Gas]"..
            "list[context;gas;0,2;1,1;]"..
            "label[2,1.5;Fuel]"..
            "list[context;fuel;2,2;1,1;]"
    end,
    textures = {
        inactive = {
            "furnace_side.png", "furnace_side.png",
            "furnace_side.png", "furnace_side.png",
            "furnace_side.png", "furnace_gas_front.png"
        },
        active = {
            "furnace_side.png", "furnace_side.png",
            "furnace_side.png", "furnace_side.png",
            "furnace_side.png", {
                image = "furnace_gas_front_active.png",
                backface_culling = false,
                animation = {
                    type = "vertical_frames",
                    aspect_w = 16,
                    aspect_h = 16,
                    length = 1.5
                }
            }
        }
    },
    groups = { cracky = 2 },

    light_source = 10,

    after_stop = function(pos)
        minetest.get_meta(pos):set_float("cycle", 0)
    end,

    crafts = furnace_crafts,
})