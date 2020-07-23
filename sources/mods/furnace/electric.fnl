(local electric-furnace-textures
  {:inactive
    ["furnace_side.png" "furnace_side.png"
     "furnace_side.png" "furnace_side.png"
     "furnace_electric_back.png" "furnace_electric_front.png"]
   :active
    ["furnace_side.png" "furnace_side.png"
     "furnace_side.png" "furnace_side.png"
     "furnace_electric_back.png" "furnace_electric_front_active.png"]})

(local conf
  {:name "electric"
   :description "Electric furnace"
   :lists []
   :on_tick [(andthen (reset_consumer "furnace:electric") (const true))]
   :on_destruct (andthen reset_current drop_everything)
   :is_furnace_ready (fn [pos]
     (= (-> (minetest.get_meta pos) (: :get_int :active)) 1))
   :additional_formspec (fn [meta] "label[1,2;Electric furnace]")
   :textures electric-furnace-textures
   :light_source 6
   :groups {:cracky 2 :conductor 1}
   :on_construct (set_resis 50 10)
   :on_destruct reset_current
   :crafts furnace_crafts})

(minetest.register_node "furnace:electric_broken"
  {:description "Electric furnace (broken)"
   :tiles electric-furnace-textures.inactive
   :groups {:cracky 2}
   :paramtype2 "facedir"})

(tset consumers "furnace:electric"
  {:on_activate (partial run_furnace conf)
   :on_deactivate (partial stop_furnace conf)
   :Pₘᵢₙ 1000 :Iₘₐₓ 10
   :burn (fn [pos] (swap_node pos "furnace:electric_broken"))})

(register_furnace conf)
(tset model "furnace:electric" (consumer 50 10))
(tset model "furnace:electric_active" (consumer 50 10))