local multimeter_resis = 0.01
local multimeter_timeout = 0.5
minetest.register_tool("electricity:multimeter", {
    inventory_image = "electricity_multimeter.png",
    description = "Multimeter",
    stack_max = 1,
    liquids_pointable = true,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        local name = minetest.get_node(pointed_thing.under).name
        local meta = minetest.get_meta(pointed_thing.under)

        meta:set_float("user_resis", multimeter_resis)
        minetest.after(multimeter_timeout, function(meta, name)
            minetest.chat_send_player(name, string.format(
                "I = %f, U = %f", meta:get_float("I"), meta:get_float("U")
            ))

            meta:set_float("user_resis", 0)
        end, meta, user:get_player_name())
        return
    end,
})