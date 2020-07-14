(each [name params (pairs ores)]
  (let [light-source (or params.light_source 0)]
    (each [_ place (ipairs params.wherein)]
      (minetest.register_node (.. "loria:" name "_" place)
        {:description (.. (capitalization name) " (in " place ")")
         :tiles [(.. "loria_" place ".png^loria_" name "_ore.png")]
         :groups {:cracky 2}
         :light_source (math.floor (/ light-source 2))}))

    ; backward compatibility
    (when (contains params.wherein "cobalt_blue")
      (minetest.register_alias
        (.."loria:" name "_azure")
        (.."loria:" name "_cobalt_blue")))

    (minetest.register_node (.. "loria:" name)
      {:description (.. (capitalization name) " (" params.formula ")")
       :tiles [(.. "loria_" name ".png")]
       :groups {:cracky 1}
       :drop (.. "loria:" name)
       :light_source light-source})

    (when params.has_ingot
      (minetest.register_craftitem (.. "loria:" name "_ingot")
        {:description (.. (capitalization name) " ingot")
         :inventory_image (.. "loria_" name "_ingot.png")}))))

(minetest.register_node "loria:humus"
  {:description "Humus"
   :tiles ["loria_humus.png"]
   :groups {:cracky 3}})

(minetest.register_node "loria:plutonium_dioxide"
  {:description "Plutonium (IV) oxide (PuO2)"
   :tiles ["loria_plutonium_dioxide.png"]
   :groups {:cracky 2}})

(minetest.register_node "loria:plutonium_tetrafluoride"
  {:description "Plutonium (IV) tetrafluoride (PuF4)"
   :tiles ["loria_plutonium_tetrafluoride.png"]
   :groups {:cracky 2}})

(minetest.register_node "loria:plutonium_hexafluoride"
  {:description "Plutonium (VI) hexafluoride (PuF6)"
   :tiles ["loria_plutonium_hexafluoride.png"]
   :groups {:cracky 2}})

(global liquid_ores
  {"trisilane" {:liquid "loria:trisilane_source"}
   "hydrochloric_acid"
     {:liquid "loria:hydrochloric_acid_source"
      :y_min -150 :y_max 50}})

(each [name params (pairs liquid_ores)]
  (minetest.register_node (.. "loria:" name "_cinnabar")
    {:description (.. (capitalization name) " (in cinnabar)")
     :tiles [(.. "loria_cinnabar.png^loria_" name "_ore.png")]
     :groups {:cracky 1}
     :drop {}
     :after_destruct (fn [pos oldnode]
       (minetest.set_node pos {:name params.liquid}))})

  (minetest.register_node (.. "loria:" name "_cobalt_blue")
    {:description (.. (capitalization name) " (in cobalt blue)")
     :tiles [(.. "loria_cobalt_blue.png^loria_" name "_ore.png")]
     :groups {:cracky 1}
     :drop {}
     :after_destruct (λ [pos oldnode]
       (minetest.set_node pos {:name params.liquid}))})

  (minetest.register_ore
    {:ore_type       "scatter"
     :ore            (.. "loria:" name "_cinnabar")
     :wherein        "loria:cinnabar"
     :clust_scarcity (* 8 8 8)
     :clust_num_ores 8
     :clust_size     3
     :y_min          (or params.y_min -10)
     :y_max          (or params.y_max  80)})

  (minetest.register_ore
    {:ore_type       "scatter"
     :ore            (.. "loria:" name "_cobalt_blue")
     :wherein        "loria:cobalt_blue"
     :clust_scarcity (* 8 8 8)
     :clust_num_ores 8
     :clust_size     3
     :y_min          (or params.y_min -10)
     :y_max          (or params.y_max  80)}))

(minetest.register_ore
  {:ore_type       "scatter"
   :ore            "loria:sulfur"
   :wherein        "loria:chromium_fluoride"
   :clust_scarcity (* 8 8 8)
   :clust_num_ores 8
   :clust_size     7
   :y_min          -200
   :y_max           120})