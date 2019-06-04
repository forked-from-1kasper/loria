minetest.register_node("default:furnace", {
    description = "Furnace",
    tiles = {
        "default_furnace_side.png", "default_furnace_side.png",
        "default_furnace_side.png", "default_furnace_side.png",
        "default_furnace_side.png", "default_furnace_front.png"
    },
    paramtype2 = "facedir",
    groups = { cracky = 2 }
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
    paramtype2 = "facedir",
    groups = { cracky = 2 }
})