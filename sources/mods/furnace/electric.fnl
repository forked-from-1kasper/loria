(local optimal 
  {:I {:min 0.5 :max 50}
   :U {:min 30  :max 300}})

(local conf
  {:name "electric"
   :description "Electric furnace"
   :lists []
   :on_tick [(andthen (reset_consumer "furnace:electric") (const true))]
   :on_destruct (andthen reset_current drop_everything)
   :is_furnace_ready (fn [pos]
     (= (-> (minetest.get_meta pos) (: :get_int :active)) 1))
   :additional_formspec (fn [meta] "label[1,2;Electric furnace]")
   :textures
     {:inactive
        ["furnace_side.png" "furnace_side.png"
         "furnace_side.png" "furnace_side.png"
         "furnace_electric_back.png" "furnace_electric_front.png"]
      :active
        ["furnace_side.png" "furnace_side.png"
         "furnace_side.png" "furnace_side.png"
         "furnace_electric_back.png" "furnace_electric_front_active.png"]}
   :light_source 6
   :groups {:cracky 2 :conductor 1}
   :on_construct (fn [pos]
     (-> (minetest.get_meta pos)
         (: :set_float :resis 50)))
   :on_destruct reset_current
   :crafts furnace_crafts})

(tset consumer "furnace:electric"
  {:on_activate (partial run_furnace conf)
   :on_deactivate (partial stop_furnace conf)
   :current optimal})

(register_furnace conf)
(tset model "furnace:electric" resistor)
(tset model "furnace:electric_active" resistor)