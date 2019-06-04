gases_list = {
    ["default:oxygen_balloon"] = balloon_coeff * 10
}

fuel_list = {
    ["default:viridi_petasum_body"] = 35,
    ["default:turris_body"] = 25,
    ["default:rete_body"] = 15,
    ["default:oxygen_baloon"] = 5,
}

crafts = {
    {
        input = {
            { name = "default:copper_sulfate", count = 1 },
            { name = "default:bucket_empty", count = 5 }
        },
        output = {
            { name = "default:copper_sulfate_pure", count = 1 },
            { name = "default:bucket_water", count = 5 }
        },
        time = 5
    },
    {
        input = {
            { name = "default:aluminium", count = 1 }
        },
        output = {
            { name = "default:aluminium_ingot", count = 1 },
            { name = "default:cinnabar", count = 1 }
        },
        time = 3
    },
    {
        input = {
            { name = "default:aluminium_ingot", count = 8 }
        },
        output = {
            { name = "default:bucket_empty", count = 1 }
        },
        time = 8
    }
}

function get_craft(inv)
    for _, craft in ipairs(crafts) do
        local checked = true
        for _, reagent in ipairs(craft.input) do
            checked = checked and inv:contains_item("input", reagent)
        end

        if checked then
            return craft
        end
    end
end

function inactive_formspec()
    return
        "size[11,9]"..
        "label[0,1.5;Gas]"..
        "list[context;gas;0,2;1,1;]"..
        "label[2,1.5;Fuel]"..
        "list[context;fuel;2,2;1,1;]"..
        "label[4,0.5;Input]"..
        "list[context;input;4,1;3,3;]"..
        "label[8,0.5;Output]"..
        "list[context;output;8,1;3,3;]"..
        "list[current_player;main;2,5;8,1;]"..
        "list[current_player;main;2,6;8,3;8]"
end

function run_furnace(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    local gas = inv:get_list("gas")[1]:get_name()
    local fuel = inv:get_list("fuel")[1]:get_name()

    if (gases_list[gas] ~= nil) and (fuel_list[fuel] ~= nil) then
        minetest.swap_node(pos, { name = "default:furnace_active" })
        minetest.get_node_timer(pos):start(1)
    end
end

function stop_furnace(pos)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()

    local gas = inv:get_list("gas")[1]:get_name()
    local fuel = inv:get_list("fuel")[1]:get_name()

    if (gases_list[gas] == nil) or (fuel_list[fuel] == nil) then
        minetest.swap_node(pos, { name = "default:furnace" })
        minetest.get_node_timer(pos):stop()
        meta:set_float("cooking", 0)
    end
end

minetest.register_node("default:furnace", {
    description = "Furnace",
    tiles = {
        "default_furnace_side.png", "default_furnace_side.png",
        "default_furnace_side.png", "default_furnace_side.png",
        "default_furnace_side.png", "default_furnace_front.png"
    },

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", inactive_formspec())
        meta:set_float("cycle", 0)
        meta:set_float("cooking", 0)

        local inv = meta:get_inventory()

        inv:set_size('gas', 1)
        inv:set_size('fuel', 1)
        inv:set_size('input', 9)
        inv:set_size('output', 9)
    end,

    paramtype2 = "facedir",
    groups = { cracky = 2 },

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "output" then
            return 0
        else
            return stack:get_count()
        end
    end,

    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        run_furnace(pos)
    end,

    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        run_furnace(pos)
    end,

    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        run_furnace(pos)
    end,
})

minetest.register_node("default:furnace_active", {
    description = "Furnace",
    tiles = {
        "default_furnace_side.png", "default_furnace_side.png",
        "default_furnace_side.png", "default_furnace_side.png",
        "default_furnace_side.png",
        {
            image = "default_furnace_front_active.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 1.5
            }
        }
    },
    light_source = 10,
    paramtype2 = "facedir",
    groups = { cracky = 2 },

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        if listname == "output" then
            return 0
        else
            return stack:get_count()
        end
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        if to_list == "input" then
            return 0
        else
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            local stack = inv:get_stack(from_list, from_index)
            return stack:get_count()
        end
    end,

    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
        if listname == "input" then
            return 0
        else
            return stack:get_count()
        end
    end,

    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
        stop_furnace(pos)
    end,

    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        stop_furnace(pos)
    end,

    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        stop_furnace(pos)
    end,

    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        local gas = inv:get_list("gas")[1]
        local wear = gas:get_wear() + gases_list[gas:get_name()]
        if wear >= 65535 then
            gas = { name = "default:empty_balloon", count = 1 }

            minetest.swap_node(pos, { name = "default:furnace" })
            minetest.get_node_timer(pos):stop()
            meta:set_float("cooking", 0)
        else
            gas:set_wear(gas:get_wear() + gases_list[gas:get_name()])
        end
        inv:set_stack("gas", 1, gas)

        local fuel = inv:get_list("fuel")[1]

        local cycle = meta:get_float("cycle") + elapsed
        if cycle > fuel_list[fuel:get_name()] then
            cycle = 0
            local count = fuel:get_count() - 1
            fuel:set_count(count)
            
            if count == 0 then
                minetest.swap_node(pos, { name = "default:furnace" })
                minetest.get_node_timer(pos):stop()
                meta:set_float("cooking", 0)
            end
            inv:set_stack("fuel", 1, fuel)
        end
        meta:set_float("cycle", cycle)

        local cooking = meta:get_float("cooking") + elapsed
        local recipe = get_craft(inv)

        if recipe ~= nil and cooking >= recipe.time then
            cooking = 0
            for _, reagent in ipairs(recipe.input) do
                inv:remove_item("input", reagent)
            end

            for _, result in ipairs(recipe.output) do
                if inv:room_for_item("output", result) then
                    inv:add_item("output", result)
                else
                    minetest.add_item(vector.add(pos, vector.new(0, 1, 0)), result)
                end
            end
        end

        if recipe == nil then
            cooking = 0
        end

        meta:set_float("cooking", cooking)

        return true
    end
})