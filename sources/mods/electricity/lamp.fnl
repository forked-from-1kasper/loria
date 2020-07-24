(require-macros :infix)

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

(fn lamp-burn [burn-to]
  (fn [pos] (swap_node pos burn-to)
            (spawn-sparks pos)))

(fn register-lamp [conf]
  (let [broken-name   (.. "electricity:" conf.name "_broken")
        disabled-name (.. "electricity:" conf.name "_off")
        active-name   (.. "electricity:" conf.name "_on")
        burn          (lamp-burn broken-name)]
    (minetest.register_node broken-name
      {:description (.. (capitalization conf.name) " (broken)")
       :tiles conf.tiles-broken :groups {:cracky 3}
       :paramtype2 "facedir"})

    (minetest.register_node disabled-name
      {:description (capitalization conf.name)
       :tiles conf.tiles :groups {:cracky 3 :conductor 1}
       :paramtype2 "facedir" :on_destruct reset_current})

    (minetest.register_node active-name
      {:description (.. (capitalization conf.name) " (active)")
       :tiles conf.tiles :groups {:cracky 3 :conductor 1}
       :light_source conf.light-source :paramtype2 "facedir"
       :drop disabled-name :on_destruct reset_current
       :on_timer (reset_consumer active-name)})

    (tset consumers disabled-name
      {:on_activate (fn [pos] (swap_node pos active-name))
       :Pₘᵢₙ conf.Pₘᵢₙ :Iₘₐₓ conf.Iₘₐₓ :burn burn})

    (tset consumers active-name
      {:on_deactivate (fn [pos] (swap_node pos disabled-name))
       :Pₘᵢₙ conf.Pₘᵢₙ :Iₘₐₓ conf.Iₘₐₓ :burn burn})

    (tset model disabled-name (consumer 10 0.1))
    (tset model active-name   (consumer 10 0.1))))

(register-lamp
  {:name "lamp"
   :tiles ["electricity_lamp.png" "electricity_lamp.png"
           "electricity_lamp.png" "electricity_lamp.png"
           "electricity_lamp_connect_side.png"
           "electricity_lamp_connect_side.png"]
   :tiles-broken ["electricity_lamp_broken.png" "electricity_lamp_broken.png"
                  "electricity_lamp_broken.png" "electricity_lamp_broken.png"
                  "electricity_lamp_broken_connect_side.png"
                  "electricity_lamp_broken_connect_side.png"]
   :light-source 14
   :Pₘᵢₙ 50 :Iₘₐₓ 5})

;(local led-lamp-box
;  {:type "fixed"
;   :fixed [[(/ -1 2) (/ -1 2) (/ -1 2) (/ 1 2) (infix -1 / 2 + 2 / 16) (/ 1 2)]
;           []
;           []]})