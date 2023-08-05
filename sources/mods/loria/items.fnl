(require-macros :useful-macros)

(minetest.register_item ":"
  {:type "none"
   :wield_image "wieldhand.png"
   :wield_scale {:x 1 :y 1 :z 3.5}
   :tool_capabilities
    {:full_punch_interval 1.0
     :max_drop_level 0
     :groupcaps
      {:oddly_breakable_by_hand {:times {1 7.00 2 4.00 3 1.40} :uses 0 :maxlevel 5}
       :fleshy                  {:times {2 2.00 3 1.00}        :uses 0 :maxlevel 1}
       :crumbly                 {:times {2 3.00 3 0.70}        :uses 0 :maxlevel 1}
       :snappy                  {:times {3 0.40}               :uses 0 :maxlevel 1}
       :cracky                  {:times {1 9.00 2 7.00 3 5.00}}}
     :damage_groups {:fleshy 1}}})

(minetest.register_craftitem "loria:broken_drill"
  {:description     "Broken drill"
   :inventory_image "loria_broken_drill.png"})

(minetest.register_tool "loria:drill"
  {:description "Drill"
   :stack_max 1
   :liquids_pointable false
   :range 5.0
   :inventory_image "loria_drill.png"
   :wield_image "loria_drill.png"
   :tool_capabilities
    {:full_punch_interval 1.0
     :max_drop_level 1
     :groupcaps
      {:cracky                  {:times {1 2.00 2 0.50 3 0.30} :uses 500}
       :choppy                  {:times {1 1.00 2 0.50 3 0.20} :uses 560}
       :crumbly                 {:times {1 0.50 2 0.30 3 0.10} :uses 600}
       :oddly_breakable_by_hand {:times {1 0.50 2 0.30 3 0.10}}}
     :damage_groups {:fleshy 2}}
   :after_use
    (fn [itemstack user node digparams]
      (if (≥ (+ (itemstack:get_wear) digparams.wear) 65535)
        {:name "loria:broken_drill" :count 1}
        (do (itemstack:add_wear digparams.wear) itemstack)))})

(minetest.register_craftitem "loria:super_drill"
  {:description "Super drill"
   :stack_max 1
   :liquids_pointable false
   :range 10.0
   :inventory_image "loria_super_drill.png"
   :wield_image "loria_super_drill.png"
   :tool_capabilities
    {:full_punch_interval 1.0
     :max_drop_level 1
     :groupcaps
      {:cracky                  {:times {1 0.05 2 0.05 3 0.05}}
       :crumbly                 {:times {1 0.05 2 0.05 3 0.05}}
       :oddly_breakable_by_hand {:times {1 0.05 2 0.05 3 0.05}}}
     :damage_groups {:fleshy 2}}})

(minetest.register_tool "loria:copper_hammer"
  {:inventory_image "loria_copper_hammer.png"
   :description "Copper hammer"
   :stack_max 1
   :liquids_pointable false
   :range 2.0
   :damage_groups {:fleshy 1}
   :tool_capabilities
    {:full_punch_interval 1.0
     :max_drop_level 1
     :groupcaps
      {:cracky  {:times {1 5.0 2 0.9 3 0.3} :uses 10}
       :crumbly {:times {1 7.0 2 5.0 3 2.0} :uses 100}}
     :damage_groups {:fleshy 2}}

   :after_use
    (fn [itemstack user node digparams]
      (when (∈ node.name brickable)
        (let [inv (user:get_inventory)]
          (add_or_drop inv "main" {:name (.. node.name "_brick") :count 1} (above (user:get_pos)))
          (inv:remove_item "main" {:name node.name :count 1})))

      (if (≥ (+ (itemstack:get_wear) digparams.wear) 65535)
          {:name "loria:stick" :count 1}
          (do (itemstack:add_wear digparams.wear) itemstack)))})

(minetest.register_tool "loria:copper_hammer_head"
  {:inventory_image "loria_copper_hammer_head.png"
   :description "Copper hammer head"
   :stack_max 1
   :liquids_pointable false
   :range 1.0
   :damage_groups {:fleshy 2}
   :tool_capabilities
    {:full_punch_interval 1.0
     :max_drop_level 1
     :groupcaps
      {:cracky  {:times {1 6.0  2 1.2  3 0.5} :uses 9}
       :crumbly {:times {1 15.0 2 10.0 3 4.0} :uses 90}}
     :damage_groups {:fleshy 2}}
   :after_use
    (fn [itemstack user node digparams]
      (if (≥ (+ (itemstack:get_wear) digparams.wear) 65535) nil
          (do (itemstack:add_wear digparams.wear) itemstack)))})

(minetest.register_tool "loria:nail_file"
  {:inventory_image "loria_nail_file.png"
   :description "Nail file"
   :stack_max 1
   :on_use (fn [itemstack user pointed_thing]
             (itemstack:set_name "loria:broken_nail_file") itemstack)})

(minetest.register_tool "loria:broken_nail_file"
  {:inventory_image "loria_broken_nail_file.png"
   :description "Broken nail file"
   :stack_max 1
   :range 0
   :tool_capabilities
    {:full_punch_interval 1.0
     :max_drop_level 0
     :groupcaps {:snappy {:times {1 100 2 60 3 30} :uses 5}}}})

(minetest.register_tool "loria:battery"
  {:inventory_image "loria_battery.png"
   :description "Battery"
   :groups {:item_source 5}})

(minetest.register_craftitem "loria:stick"
  {:inventory_image "loria_stick.png"
   :description     "Stick"
   :stack_max       120})

(minetest.register_craftitem "loria:aluminium_brick_mold"
  {:inventory_image "loria_aluminium_brick_mold.png"
   :description     "Aluminium brick mold"
   :stack_max       9})

(minetest.register_craftitem "loria:aluminium_case"
  {:inventory_image "loria_aluminium_case.png"
   :description     "Aluminium case"
   :stack_max       16})

(minetest.register_craftitem "loria:wolfram_filament"
  {:inventory_image "loria_wolfram_filament.png"
   :description     "Wolfram filament"
   :stack_max       30})

(minetest.register_craftitem "loria:empty_balloon"
  {:inventory_image "loria_empty_balloon.png"
   :description     "Empty balloon"
   :stack_max       1})

(minetest.register_craftitem "loria:thorium_ingot"
  {:description     "Thorium ingot"
   :inventory_image "loria_thorium_ingot.png"})

(minetest.register_craftitem "loria:uranium_ingot"
  {:description     "Uranium ingot"
   :inventory_image "loria_uranium_ingot.png"})

(minetest.register_craftitem "loria:plutonium_ingot"
  {:description     "Plutonium ingot"
   :inventory_image "loria_plutonium_ingot.png"})

(defun get_gas [pos] (detect_gas (. (minetest.get_node pos) :name)))

(global balloon_use            100)
(global balloon_coeff          64)
(global broken_spacesuit_coeff 3)
(global oxygen_decrease_time   5)

(var oxygen-timer 0)
(def-globalstep [Δt]
  (set+ oxygen-timer Δt)

  (each [_ player (ipairs (minetest.get_connected_players))]
    ;; disables breath mechanic
    (when (≠ (player:get_breath) 11)
      (player:set_breath 11))

    (var oxygen     0)
    (var oxygen-max 0)

    (when (> oxygen-timer oxygen_decrease_time)
      (local meta (player:get_meta "oxygen"))
      (set oxygen-timer 0)

      (let [inv (player:get_inventory)
            oxygen-stack (. (inv:get_list "oxygen") 1)]
        (if (inv:contains_item "oxygen" {:name "loria:oxygen_balloon"})
          (do (local Δ (if (> (meta:get_int "space_suit") 0) balloon_coeff
                           (* broken_spacesuit_coeff balloon_coeff)))
              (local wear (oxygen-stack:get_wear))

              (set oxygen (/ (- 65536 wear) balloon_coeff))
              (oxygen-stack:set_wear (+ wear Δ))

              (if (≥ (+ wear Δ) 65535)
                  (inv:set_stack "oxygen" 1 {:name "loria:empty_balloon"})
                  (inv:set_stack "oxygen" 1 oxygen-stack))

              (set oxygen-max (/ 65536 balloon_coeff)))
          (set oxygen 0)))

      (let [pos (player:get_pos)]
        (when (∧ (≠ (get_gas (above pos)) "oxygen")
                 (≠ (get_gas pos) "oxygen")
                 (≤ oxygen 0))
          (player:set_hp (- (player:get_hp) 1))))

      (meta:set_int "oxygen-max" oxygen-max)
      (meta:set_int "oxygen" oxygen))))