function furnace_formspec(conf, craft_percent, meta)
    return
        "size[11,9.5]"..
        "label[4,0.5;Input]"..
        "image[7,2;1,1;gui_arrow.png^[lowpart:"
        .. craft_percent .. ":gui_active_arrow.png^[transformR270]"..
        "list[context;input;4,1;3,3;]"..
        "label[8,0.5;Output]"..
        "list[context;output;8,1;3,3;]"..
        "list[current_player;main;2,5;8,1;]"..
        "list[current_player;main;2,6.5;8,3;8]"..
        conf.additional_formspec(meta)
end

function run_furnace(conf, pos)
    if conf.before_run then
        conf.before_run(pos)
    end

    minetest.get_node_timer(pos):start(0.3)
    swap_node(pos, "furnace:" .. conf.name .. "_active")
end

function stop_furnace(conf, pos)
    local meta = minetest.get_meta(pos)
    swap_node(pos, "furnace:" .. conf.name)

    meta:set_string("formspec", furnace_formspec(conf, 0, meta))
    meta:set_float("cooking", 0)

    minetest.get_node_timer(pos):stop()

    if conf.after_stop then
        conf.after_stop(pos)
    end
end

function check_and_run_furnace(conf, pos)
    if conf.is_furnace_ready(pos) then
        run_furnace(conf, pos)
    end
end

function check_and_stop_furnace(conf, pos)
    if not conf.is_furnace_ready(pos) then
        stop_furnace(conf, pos)
    end
end

function furnace_on_timer(conf)
    return (function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()

        for _, func in ipairs(conf.on_tick) do
            if not func(pos, elapsed) then
                stop_furnace(conf, pos)
                return true
            end
        end

        local cooking = meta:get_float("cooking") + elapsed
        local recipe = get_craft(conf.crafts, inv)

        if recipe ~= nil and cooking >= recipe.time then
            cooking = 0
            for _, reagent in ipairs(recipe.input) do
                inv:remove_item("input", reagent)
            end

            for _, result in ipairs(recipe.output) do
                add_or_drop(
                    inv, "output", result,
                    vector.add(pos, vector.new(0, 1, 0))
                )
            end
        end

        if recipe == nil then
            cooking = 0
            meta:set_string("formspec", furnace_formspec(conf, 0, meta))
        else
            meta:set_string("formspec", furnace_formspec(
                conf, math.floor(100 * cooking / recipe.time), meta
            ))
        end

        meta:set_float("cooking", cooking)

        return true
    end)
end

function construct_furnace(conf)
    return (function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", furnace_formspec(conf, 0, meta))
        meta:set_float("cycle", 0)
        meta:set_float("cooking", 0)

        local inv = meta:get_inventory()

        inv:set_size('input', 9)
        inv:set_size('output', 9)
        for name, size in pairs(conf.lists) do
            inv:set_size(name, size)
        end

        if conf.on_construct then
            conf.on_construct(pos)
        end
    end)
end

function register_furnace(conf)
    minetest.register_node("furnace:" .. conf.name, {
        description = conf.description,
        drop = conf.drop or "furnace:" .. conf.name,
        tiles = conf.textures.inactive,

        on_destruct = andthen(conf.on_destruct or nope, drop_everything),
        on_construct = construct_furnace(conf),

        paramtype2 = "facedir",
        legacy_facedir_simple = true,
        groups = conf.groups or { },

        paramtype = conf.paramtype,
        drawtype = conf.drawtype,
        mesh = conf.mesh,
        collision_box = conf.collision_box,
        selection_box = conf.selection_box,

        allow_metadata_inventory_put = function(pos, listname, index, stack, player)
            if listname == "output" then
                return 0
            else
                return stack:get_count()
            end
        end,

        on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
            check_and_run_furnace(conf, pos)
        end,
        on_metadata_inventory_put = function(pos, listname, index, stack, player)
            check_and_run_furnace(conf, pos)
        end,
        on_metadata_inventory_take = function(pos, listname, index, stack, player)
            check_and_run_furnace(conf, pos)
        end,

        on_receive_fields = conf.on_receive_fields,
    })

    minetest.register_node("furnace:" .. conf.name .. "_active", {
        description = conf.description .. " (active)",
        drop = conf.drop or "furnace:" .. conf.name,
        tiles = conf.textures.active,

        light_source = conf.light_source,
        paramtype2 = "facedir",
        legacy_facedir_simple = true,
        groups = join(conf.groups or { }, { not_in_creative_inventory = 1 }),

        paramtype = conf.paramtype,
        drawtype = conf.drawtype,
        mesh = conf.mesh,
        collision_box = conf.collision_box,
        selection_box = conf.selection_box,

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
            return stack:get_count()
        end,

        on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
            check_and_stop_furnace(conf, pos)
        end,
        on_metadata_inventory_put = function(pos, listname, index, stack, player)
            check_and_stop_furnace(conf, pos)
        end,
        on_metadata_inventory_take = function(pos, listname, index, stack, player)
            check_and_stop_furnace(conf, pos)
        end,

        on_destruct = andthen(conf.on_destruct or nope, drop_everything),
        on_timer = furnace_on_timer(conf),

        on_receive_fields = conf.on_receive_fields,
    })
end