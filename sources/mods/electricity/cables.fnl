(require-macros :infix)

(local cable-box
  {:type "connected"
   :fixed          [(/ -1 16) (/ -1 2)                (/ -1 16)
                    (/ 1 16)  (infix -1 / 2 + 1 / 16) (/ 1 16)]
   :connect_top    [(/ -1 16) (/ -1 2)                (/ -1 16)
                    (/ 1 16)  (/ 1 2)                 (/ 1 16)]
   :connect_bottom [(/ -1 16) (/ -1 2)                (/ -1 16)
                    (/ 1 16)  (infix -1 / 2 + 1 / 16) (/ 1 16)]
   :connect_front  [(/ -1 16) (/ -1 2)                (/ -1 2)
                    (/ 1 16)  (infix -1 / 2 + 1 / 16) (/ 1 16)]
   :connect_left   [(/ -1 2)  (/ -1 2)                (/ -1 16)
                    (/ 1 16)  (infix -1 / 2 + 1 / 16) (/ 1 16)]
   :connect_back   [(/ -1 16) (/ -1 2)                (/ -1 16)
                    (/ 1 16)  (infix -1 / 2 + 1 / 16) (/ 1 2)]
   :connect_right  [(/ -1 16) (/ -1 2)                (/ -1 16)
                    (/ 1 2)   (infix -1 / 2 + 1 / 16) (/ 1 16)]})

(fn register-cable [conf]
  (minetest.register_node (.. "electricity:" conf.name "_cable")
    {:description (.. (capitalization conf.name) " cable")
     :drawtype "nodebox"
     :tiles (map (partial .. "electricity_" conf.name)
       ["_cable.png"
        "_cable.png"
        "_cable_side.png"
        "_cable_side.png"
        "_cable_side.png"
        "_cable_side.png"])
     :inventory_image (.. "electricity_" conf.name "_cable_item.png")
     :wield_image (.. "electricity_" conf.name "_cable_item.png")
     :is_ground_content false
     :sunlight_propagates true
     :paramtype "light"
     :drop (.. "electricity:" conf.name "_cable")
     :groups {:crumbly 3 :dig_immediate 3 :conductor 1 :cable 1}
     :selection_box cable-box :node_box cable-box
     :connects_to
       ["group:source"
        "group:conductor"
        "group:disabled_electric_tool"]
     :on_destruct reset_current})

  (tset model (.. "electricity:" conf.name "_cable")
    (fn [pos id]
      (let [center (hash_node_pos pos)]
        (var res [])
        (each [idx vect (ipairs neighbors)]
          (table.insert res
            (join " " (.. "r" id "-" idx) center
                      (hash_node_connect pos (vector.add pos vect))
                      conf.resis)))
        res))))

(foreach register-cable cables)