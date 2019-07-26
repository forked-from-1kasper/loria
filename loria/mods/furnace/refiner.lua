local refiner_box = {
    type = "fixed",
    fixed = {
        { -1/2, -1/2, -1/2, 1/2, 1/2, 3/2 },
    },
}

minetest.register_node("furnace:barrier", {
    description = "Barrier",
    groups = { cracky = 2 },

    paramtype = "light",
    paramtype2 = "facedir",

    drawtype = "airlike",
    pointable = false,

    groups = { not_in_creative_inventory = 1 },
})

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

    return
      gases_list[gas] ~= nil and
      fuel_list[fuel] ~= nil and
      meta:get_int("switch") == 1
end

local conf = {
    name = "refiner",
    description = "Refiner",
    lists = { gas = 1, fuel = 1 },
    on_tick = { update_fuel, update_gas },
    is_furnace_ready = is_furnace_ready,
    additional_formspec = function(meta)
        return
            "label[0,1.5;Gas]"..
            "list[context;gas;0,2;1,1;]"..
            "label[2,1.5;Fuel]"..
            "list[context;fuel;2,2;1,1;]"..
            "button[7,3;1,1;switch;On/off]"
    end,
    textures = {
        inactive = { "furnace_refiner.png" },
        active = {{
            image = "furnace_refiner_active.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 64,
                aspect_h = 64,
                length = 1.5
            }
        }},
    },
    groups = { not_in_creative_inventory = 1, cracky = 2 },
    after_stop = function(pos)
        minetest.get_meta(pos):set_float("cycle", 0)
    end,

    paramtype = "light",
    drawtype = "mesh",
    mesh = "doubled.obj",
    collision_box = refiner_box,
    selection_box = refiner_box,

    on_destruct = function(pos)
        local node = minetest.get_node(pos)

        local back = vector.add(pos, minetest.facedir_to_dir(node.param2))
        local node2 = minetest.get_node(back)

        if minetest.get_node(back).name == "furnace:barrier" and
           node.param2 == node2.param2 then
            minetest.set_node(back, { name = "air" })
        end
    end,

    after_stop = function(pos)
        minetest.get_meta(pos):set_int("switch", 0)
    end,

    drop = "furnace:refiner_item",

    crafts = refiner_crafts,
}

conf.on_receive_fields = function(pos, formname, fields, sender)
    if fields.switch then
        local meta = minetest.get_meta(pos)
        local active = meta:get_int("switch")

        if active == 1 then
            meta:set_int("switch", 0)
            check_and_stop_furnace(conf, pos)
        else
            meta:set_int("switch", 1)
            check_and_run_furnace(conf, pos)
        end
    end
end

register_furnace(conf)

local rolled_refiner_box = {
    type = "fixed",
    fixed = {
        { -7/16, -1/2, -7/16, 7/16, 6/16, 7/16 },
    },
}

local function is_buildable(pos)
    local name = minetest.get_node(pos).name
    return minetest.registered_nodes[name].buildable_to or name == "furnace:refiner_item"
end

minetest.register_node("furnace:refiner_item", {
    description = "Refiner (rolled)",
    tiles = {
        "furnace_rolled_refiner_top.png", "furnace_rolled_refiner_top.png",
        "furnace_rolled_refiner.png", "furnace_rolled_refiner.png",
        "furnace_rolled_refiner.png", "furnace_rolled_refiner.png",
    },
    groups = { cracky = 2 },

    paramtype = "light",
    drawtype = "nodebox",
    node_box = rolled_refiner_box,
    selection_box = rolled_refiner_box,

    on_construct = function(pos)
        minetest.get_meta(pos):set_string("infotext", "Right click to unroll")
    end,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if (not pointed_thing) or pointed_thing.type ~= "node" then
            return
        end

        local param2 = minetest.dir_to_facedir(clicker:get_look_dir())
        local dir = minetest.facedir_to_dir(param2)
        local back = vector.add(pos, dir)

        if is_buildable(pos) and is_buildable(back) then
            minetest.set_node(pos, { name = "furnace:refiner", param2 = param2 })
            minetest.set_node(back, { name = "furnace:barrier", param2 = param2 })
        end
    end
})