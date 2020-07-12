(require-macros :useful-macros)

(minetest.register_tool "electricity:accumulator"
  {:inventory_image "electricity_accumulator.png"
   :description "Accumulator"
   :groups {:item_source 4 :rechargeable 1}})

(local charger-box-resis 0.1)
(local charge-speed 500)
(local voltage-delta 4)
(local charger-formspec
  (.. "size[8,6.5]"
      "label[3.5,0;Charger box]" 
      "list[context;place;3.5,0.5;1,1;]"
      "list[current_player;main;0,2;8,1;]"
      "list[current_player;main;0,3.5;8,3;8]"))

(minetest.register_node "electricity:charger_box"
  {:description "Charger box"
   :tiles
     ["electricity_charger_box.png"
      "electricity_charger_box.png"
      "electricity_charger_box_side.png"
      "electricity_charger_box_side.png"
      "electricity_charger_box_connect_side.png"
      "electricity_charger_box_connect_side.png"]
   :groups {:cracky 3 :conductor 1}
   :paramtype2 :facedir

   :on_construct (fn [pos]
     (let [meta (minetest.get_meta pos)
           inv (meta:get_inventory)]
       (inv:set_size :place 1)
       (meta:set_string :formspec charger-formspec)
       (meta:set_float :resis charger-box-resis)
       (-> (minetest.get_node_timer pos) (: :start 0.5))))

   :on_destruct (andthen reset_current drop_everything)
   :on_timer (fn [pos elapsed]
     (let [meta (minetest.get_meta pos)
           inv (meta:get_inventory)
           stack (inv:get_stack "place" 1)
           name (stack:get_name)
           emf (minetest.get_item_group name :item_source)]
       (when (∧ (> (minetest.get_item_group name :rechargeable) 0) (> emf 0))
         (let [I (meta:get_float :I)
               U (meta:get_float :U)
               wear (stack:get_wear)
               Δwear (* charge-speed I (/ U emf) elapsed)]
           (when (≤ (math.abs (- U emf)) voltage-delta)
               (if (> wear Δwear) (stack:set_wear (- wear Δwear))
                   (≥ wear 65536) (stack:set_wear 65536)
                   (≤ wear Δwear) (stack:set_wear 0)
                   (nope))
               (inv:set_stack "place" 1 stack)))))
     true)

   :allow_metadata_inventory_put (fn [pos listname index stack player]
     (let [inv (: (minetest.get_meta pos) :get_inventory)]
       (if (= (: (inv:get_stack listname index) :get_count) 1) 0 1)))})

(tset model "electricity:charger_box" consumer)