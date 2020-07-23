(require-macros :infix)

(local switch-resis 0.05)
(local switch-box
  {:type "fixed"
   :fixed [(/ -1 2) (/ -1 2)                (/ -1 2)
           (/ 1 2)  (infix -1 / 2 + 3 / 16) (/ 1 2)]})

(minetest.register_node "electricity:switch_off"
  {:description "Switch"
   :tiles ["electricity_switch_top_off.png"
           "electricity_switch_bottom.png"
           "electricity_switch_side.png"
           "electricity_switch_side.png"
           "electricity_switch_side.png"
           "electricity_switch_side.png"]

   :drop "electricity:switch_off"
   :groups {:crumbly 3 :disabled_electric_tool 1}

   :paramtype "light"
   :paramtype2 "facedir"

   :drawtype "nodebox"
   :node_box switch-box
   :selection_box switch-box

   :on_rightclick
     (fn [pos node clicker itemstack pointed-thing]
       (let [meta (minetest.get_meta pos)]
         (swap_node pos "electricity:switch_on"))
       nil)})

(minetest.register_node "electricity:switch_on"
  {:description "Switch (active)"
   :tiles ["electricity_switch_top_on.png"
           "electricity_switch_bottom.png"
           "electricity_switch_side.png"
           "electricity_switch_side.png"
           "electricity_switch_connect_side.png"
           "electricity_switch_connect_side.png"]

   :drop "electricity:switch_off"
   :groups {:crumbly 3 :conductor 1 :not_in_creative_inventory 1}

   :paramtype "light"
   :paramtype2 "facedir"

   :drawtype "nodebox"
   :node_box switch-box
   :selection_box switch-box

   :on_destruct reset_current
   :on_rightclick
     (fn [pos node clicker itemstack pointed-thing]
       (let [meta (minetest.get_meta pos)]
         (meta:set_float :I 0)
         (meta:set_float :U 0)
         (reset_current pos)
         (swap_node pos "electricity:switch_off"))
       nil)})
(tset model "electricity:switch_on" (consumer switch-resis))