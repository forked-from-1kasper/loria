local multimeter_box = {
    type = "fixed",
    fixed = {
        { -1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2 },
        { -4/16, -1/2+1/16, -1/2+2/16, 4/16, 1/2-2/16, 1/2-2/16 },
    },
}

local multimeter_resis = { min = 0.015, max = 1500 }

local k = 10
local function multimeter_resis_step(R)
    local r = k * R
    if r > multimeter_resis.max then
        return multimeter_resis.min
    else
        return r
    end
end

local function update_infotext(meta)
    local I, U, R = meta:get_float("I"), meta:get_float("U"), meta:get_float("resis")
    meta:set_string("infotext", string.format(
        "I = %.1f A\nU = %.1f V\nR = %.3f Ohms",
        I, U, R
    ))
end

minetest.register_node("electricity:multimeter", {
    description = "Multimeter",
    tiles = {
        "electricity_multimeter_top.png",
        "electricity_multimeter_bottom.png",
        "electricity_multimeter_front.png",
        "electricity_multimeter_back.png",
        "electricity_multimeter_side.png",
        "electricity_multimeter_side.png",
    },
    paramtype = "light",
    paramtype2 = "facedir",

    drop = 'electricity:multimeter',
    groups = { dig_immediate = 3, conductor = 1, },

    on_construct = andthen(
        set_resis(multimeter_resis.min),
        comp(update_infotext, minetest.get_meta)
    ),
    on_destruct = reset_current,

    drawtype = "nodebox",
    node_box = multimeter_box,
    selection_box = multimeter_box,

    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        meta:set_float("resis", multimeter_resis_step(meta:get_float("resis")))
        update_infotext(meta)
    end,
})
model["electricity:multimeter"] = resistor
on_circuit_tick["electricity:multimeter"] = update_infotext

minetest.register_craftitem("electricity:multimeter_debug", {
    inventory_image = "electricity_multimeter.png",
    description = "Multimeter (debug tool)",
    stack_max = 1,
    liquids_pointable = true,
    on_use = function(itemstack, user, pointed_thing)
        if pointed_thing.type ~= "node" then
            return
        end

        local meta = minetest.get_meta(pointed_thing.under)
        local I, U = meta:get_float("I"), meta:get_float("U")

        minetest.chat_send_player(user:get_player_name(),
            string.format("I = %f, U = %f", I, U)
        )
    end
})