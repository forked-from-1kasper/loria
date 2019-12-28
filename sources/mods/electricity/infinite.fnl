(minetest.register_node "electricity:infinite_electricity"
  {:description "Infinite electricity"
   :tiles
     ["default_test.png"
      "default_test.png"
      "default_test.png"
      "default_test.png"
      "electricity_minus.png"
      "electricity_plus.png"]
   :paramtype2 "facedir"
   :groups {:crumbly 3 :source 1}
   :on_construct (set_resis 0.1)
   :on_destruct reset_current})

(local inf-emf 220)
(tset model "electricity:infinite_electricity" (fn [pos id]
  (let [device-name (.. "v" id)]
    (values
      (two_pole device-name pos
               (string.format "DC SIN(0 %f 10Hz)" inf-emf))
      device-name))))

(minetest.register_node "electricity:infinite_consumer"
  {:description "Infinite consumer"
   :tiles
     ["default_test.png^[colorize:#ff000050"
      "default_test.png^[colorize:#ff000050"
      "default_test.png^[colorize:#ff000050"
      "default_test.png^[colorize:#ff000050"
      "electricity_minus.png^[colorize:#ff000050"
      "electricity_plus.png^[colorize:#ff000050"]
  :paramtype2 "facedir"
  :groups {:crumbly 3 :conductor 1}
  :on_construct (set_resis 5)
  :on_destruct reset_current})
(tset model "electricity:infinite_consumer" resistor)

(minetest.register_node "electricity:heavy_infinite_consumer"
  {:description "Infinite consumer"
   :tiles
     ["default_test.png^[colorize:#00ff0050"
      "default_test.png^[colorize:#00ff0050"
      "default_test.png^[colorize:#00ff0050"
      "default_test.png^[colorize:#00ff0050"
      "electricity_minus.png^[colorize:#00ff0050"
      "electricity_plus.png^[colorize:#00ff0050"]
   :paramtype2 "facedir"
   :groups {:crumbly 3 :conductor 1}
   :on_construct (set_resis 50)
   :on_destruct reset_current})
(tset model "electricity:heavy_infinite_consumer" resistor)