(require-macros :useful-macros)
(require-macros :infix)

(local cable {})

(set cable.top
  [(/ -1 16) (/ -1 2) (/ -1 16)
   (/  1 16) (/ 1 2)  (/  1 16)])

(set cable.core
  [(/ -1 16) (/ -1 2)                (/ -1 16)
   (/  1 16) (infix -1 / 2 + 1 / 16) (/  1 16)])

(set cable.front
  [(/ -1 16) (/ -1 2)                (/ -1 2)
   (/  1 16) (infix -1 / 2 + 1 / 16) (/  1 16)])

(set cable.back
  [(/ -1 16) (/ -1 2)                (/ -1 16)
   (/  1 16) (infix -1 / 2 + 1 / 16) (/  1 2)])

(set cable.left
  [(/ -1 2)  (/ -1 2)                (/ -1 16)
   (/  1 16) (infix -1 / 2 + 1 / 16) (/  1 16)])

(set cable.right
  [(/ -1 16) (/ -1 2)                (/ -1 16)
   (/  1 2)  (infix -1 / 2 + 1 / 16) (/  1 16)])

(local cable-box
  {:type "connected" :fixed cable.core
   :connect_top   cable.top   :connect_bottom cable.core
   :connect_front cable.front :connect_back   cable.back
   :connect_left  cable.left  :connect_right  cable.right })

(local cable-overlap-box
  {:type "fixed"
   :fixed
     [cable.left cable.right
      [(/ -1 16) (/ -1 2)                (/ -1 2)
       (/  1 16) (infix -1 / 2 + 1 / 16) (/ -4 16)]
      [(/  1 16) (/ -1 2)                (/  1 2)
       (/ -1 16) (infix -1 / 2 + 1 / 16) (/  4 16)]
      [(/  1 16) (/ -1 16) (/ -4 16)
       (/ -1 16) 0         (/  4 16)]
      [(/ -1 16) (/ -1 2) (/ -3 16)
       (/  1 16) 0        (/ -4 16)]
      [(/  1 16) (/ -1 2) (/  3 16)
       (/ -1 16) 0        (/  4 16)]]})

(fn cable-model [conf]
  (fn [pos id]
    (let [center (hash_node_pos pos)]
      (var res [])
      (each [idx vect (ipairs neighbors)]
        (table.insert res
          {:type :consumer :name (.. id "-" idx)
           :value conf.resis :pos-node center
           :neg-node (hash_node_connect pos (vector.add pos vect))}))
      (values {} res))))

(fn cable-overlap-model [conf]
  (fn [pos id]
    (let [conn (twoport pos)]
      (values {} (define-circuit
        :consumer (.. id "-fst") conn.prim₁ conn.sec₁ conf.resis
        :consumer (.. id "-snd") conn.prim₂ conn.sec₂ conf.resis)))))

(fn register-cable [conf]
  (local tiles
    (map (partial .. "electricity_" conf.name)
       ["_cable.png" "_cable.png"
        "_cable_side.png" "_cable_side.png"
        "_cable_side.png" "_cable_side.png"]))

  (local inv-image (.. "electricity_" conf.name "_cable_item.png"))

  (minetest.register_node (.. "electricity:" conf.name "_cable")
    {:description (.. (capitalization conf.name) " cable")
     :drawtype "nodebox" :tiles tiles
     :inventory_image inv-image :wield_image inv-image
     :is_ground_content false :sunlight_propagates true :paramtype "light"
     :groups {:crumbly 3 :dig_immediate 3 :conductor 1 :cable 1}
     :selection_box cable-box :node_box cable-box
     :connects_to
       ["group:source"
        "group:conductor"
        "group:disabled_electric_tool"]
     :on_destruct reset_current})

  (minetest.register_node (.. "electricity:" conf.name "_cable_overlap")
    {:description (.. (capitalization conf.name) " cable (overlap)")
     :drawtype "nodebox" :tiles tiles
    ;:inventory_image inv-image :wield_image inv-image
     :is_ground_content false :sunlight_propagates true :paramtype "light"
     :groups {:crumbly 3 :dig_immediate 3 :conductor 1 :cable 1}
     :selection_box cable-overlap-box :node_box cable-overlap-box
     :on_destruct reset_current})

  (tset model (.. "electricity:" conf.name "_cable") (cable-model conf))
  (tset model (.. "electricity:" conf.name "_cable_overlap")
              (cable-overlap-model conf)))

(foreach register-cable cables)