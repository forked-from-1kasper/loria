(minetest.register_node "electricity:lamp_broken"
  {:description "Lamp (broken)"
   :tiles
     ["electricity_lamp_broken.png"
      "electricity_lamp_broken.png"
      "electricity_lamp_broken.png"
      "electricity_lamp_broken.png"
      "electricity_lamp_broken_connect_side.png"
      "electricity_lamp_broken_connect_side.png"]
   :groups {:cracky 3}
   :paramtype2 "facedir"})

(minetest.register_node "electricity:lamp_off"
  {:description "Lamp"
   :tiles
     ["electricity_lamp.png"
      "electricity_lamp.png"
      "electricity_lamp.png"
      "electricity_lamp.png"
      "electricity_lamp_connect_side.png"
      "electricity_lamp_connect_side.png"]
   :groups {:cracky 3 :conductor 1}
   :paramtype2 "facedir"

   :on_construct (set_resis 10 0.1)
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
   :groups {:cracky 3 :conductor 1}
   :paramtype2 "facedir"
   :light_source 14

   :on_destruct reset_current
   :on_timer (reset_consumer "electricity:lamp_on")})

(local Pₘᵢₙ 0.3)
(local Iₘₐₓ 1)

(fn get-sparks-amount []
  (math.random 4 10))

(fn spawn-sparks [pos]
  (minetest.add_particlespawner
    {:amount (get-sparks-amount)
     :time   0.2
     :minpos pos :maxpos pos
     :minvel {:x -5 :y -5 :z -5}
     :maxvel {:x  5 :y  5 :z  5}
     :minacc {:x -2 :y -2 :z -2}
     :maxacc {:x -1 :y -1 :z -1}
     :minexptime 0.5 :maxexptime 3
     :minsize 0.1 :maxsize 0.3
     :collisiondetection true :glow 14
     :texture "electricity_spark.png"}))

(fn lamp-burn [pos]
  (swap_node pos "electricity:lamp_broken")
  (spawn-sparks pos))

(tset consumers "electricity:lamp_off"
  {:on_activate (fn [pos] (swap_node pos "electricity:lamp_on"))
   :Pₘᵢₙ Pₘᵢₙ :Iₘₐₓ Iₘₐₓ :burn lamp-burn})

(tset consumers "electricity:lamp_on"
 {:on_deactivate (fn [pos] (swap_node pos "electricity:lamp_off"))
  :Pₘᵢₙ Pₘᵢₙ :Iₘₐₓ Iₘₐₓ :burn lamp-burn})

(tset model "electricity:lamp_off" consumer)
(tset model "electricity:lamp_on"  consumer)