(require-macros :useful-macros)

(local battery-box-formspec
  (.. "size[8,6.5]"
      "label[0,0.75;Battery box]"
      "list[context;box;1.5,0.5;6,1;]"
      "list[current_player;main;0,2;8,1;]"
      "list[current_player;main;0,3.5;8,3;8]"))

(minetest.register_node "electricity:battery_box"
  {:description "Battery box"
   :tiles ["electricity_battery_top.png"
           "electricity_battery_bottom.png"
           "electricity_battery_side.png"
           "electricity_battery_side.png"
           "electricity_battery_connect_side.png"
           "electricity_battery_connect_side.png"]
   :drop "electricity:battery_box"
   :paramtype2 "facedir"

   :groups {:crumbly 3 :source 1}
  
   :on_construct
    (fn [pos]
      (let [meta (minetest.get_meta pos)
            inv  (meta:get_inventory)]
        (inv:set_size "box" 6)
        (meta:set_float "resis" 0.4)

        (meta:set_string "formspec" battery-box-formspec)))

   :allow_metadata_inventory_put
    (fn [pos listname index stack player]
      (if (> (minetest.get_item_group (stack:get_name) "item_source") 0)
          (stack:get_count) 0))

   :allow_metadata_inventory_move
    (fn [pos from-list from-index to-list to-index count player]
      (let [meta  (minetest.get_meta pos)
            inv   (meta:get_inventory)
            stack (inv:get_stack from-list from-index)]

        (if (= to-list "box")
          (if (> (minetest.get_item_group (stack:get_name) "item_source") 0)
            (stack:get_count) 0)
          (stack:get_count))))

   :on_destruct (andthen reset_current drop_everything)})

(local k 5)

(tset on_circuit_tick "electricity:battery_box"
  (fn [meta elapsed]
    (let [inv  (meta:get_inventory)
          I    (math.abs (meta:get_float "I"))
          U    (math.abs (meta:get_float "U"))
          wear (* k I U elapsed)]
      (var emf 0)

      (each [idx stack (ipairs (inv:get_list "box"))]
        (let [stack-emf (minetest.get_item_group (stack:get_name) "item_source")]
          (when (> stack-emf 0)
            (set+ emf (* (- 65536 (stack:get_wear)) (/ stack-emf 65536)))

            (if (≥ (+ (stack:get_wear) wear) 65535)
              (stack:set_wear 65535)
              (stack:add_wear wear))

            (inv:set_stack "box" idx stack))))

      (meta:set_float "emf" emf))))

(tset model "electricity:battery_box" vsource)