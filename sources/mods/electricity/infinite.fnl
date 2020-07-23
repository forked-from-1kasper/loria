(minetest.register_node "electricity:infinite_electricity"
  {:description "Infinite electricity"
   :tiles
     ["loria_test.png"
      "loria_test.png"
      "loria_test.png"
      "loria_test.png"
      "electricity_minus.png"
      "electricity_plus.png"]
   :paramtype2 "facedir"
   :groups {:crumbly 3 :source 1}
   :on_construct (set_resis 0.1)
   :on_destruct reset_current})

(local √2 (math.sqrt 2))
(local inf-emf (* 220 √2))

(tset model "electricity:infinite_electricity" (fn [pos id]
  (let [device-name (.. "v" id)]
    (twopole :voltage id pos (real inf-emf)))))

(minetest.register_node "electricity:infinite_consumer"
  {:description "Infinite consumer"
   :tiles
     ["loria_test.png^[colorize:#ff000050"
      "loria_test.png^[colorize:#ff000050"
      "loria_test.png^[colorize:#ff000050"
      "loria_test.png^[colorize:#ff000050"
      "electricity_minus.png^[colorize:#ff000050"
      "electricity_plus.png^[colorize:#ff000050"]
  :paramtype2 "facedir"
  :groups {:crumbly 3 :conductor 1}
  :on_destruct reset_current})
(tset model "electricity:infinite_consumer" (consumer 5))

(minetest.register_node "electricity:heavy_infinite_consumer"
  {:description "Heavy infinite consumer"
   :tiles
     ["loria_test.png^[colorize:#00ff0050"
      "loria_test.png^[colorize:#00ff0050"
      "loria_test.png^[colorize:#00ff0050"
      "loria_test.png^[colorize:#00ff0050"
      "electricity_minus.png^[colorize:#00ff0050"
      "electricity_plus.png^[colorize:#00ff0050"]
   :paramtype2 "facedir"
   :groups {:crumbly 3 :conductor 1}
   :on_destruct reset_current})
(tset model "electricity:heavy_infinite_consumer" (consumer (^ 10 10)))