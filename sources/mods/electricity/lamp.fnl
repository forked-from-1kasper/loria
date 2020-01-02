(minetest.register_node "electricity:lamp_off"
  {:description "Lamp"
   :tiles
     ["electricity_lamp.png"
      "electricity_lamp.png"
      "electricity_lamp.png"
      "electricity_lamp.png"
      "electricity_lamp_connect_side.png"
      "electricity_lamp_connect_side.png"]
   :drop "electricity:lamp_off"
   :groups {:cracky 3 :conductor 1}
   :paramtype2 "facedir"

   :on_construct (set_resis 10)
   :on_destruct reset_current})

(minetest.register_node "electricity:lamp_on"
  {:description "Lamp (active)"
   :tiles
     ["electricity_lamp.png"
      "electricity_lamp.png"
      "electricity_lamp.png"
      "electricity_lamp.png"
      "electricity_lamp_connect_side.png"
      "electricity_lamp_connect_side.png"]
   :drop "electricity:lamp_off"
   :groups {:cracky 3 :conductor 1}
   :paramtype2 "facedir"
   :light_source 14

   :on_destruct reset_current
   :on_timer (reset_consumer "electricity:lamp_on")})

(local current
 {:I {:min 0.2 :max 5}
  :U {:min 1   :max 7}})

(tset consumer "electricity:lamp_off"
  {:on_activate (fn [pos] (swap_node pos "electricity:lamp_on"))
   :current current})

(tset consumer "electricity:lamp_on"
 {:on_deactivate (fn [pos] (swap_node pos "electricity:lamp_off"))
  :current current})

(tset model "electricity:lamp_off" resistor)
(tset model "electricity:lamp_on"  resistor)