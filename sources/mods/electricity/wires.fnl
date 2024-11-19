(require-macros :useful-macros)
(require-macros :infix)

(local node-coeff 100)
(local wire {})

(set wire.top
  [(/ -1 16) (/ -1 2) (/ -1 16)
   (/  1 16) (/ 1 2)  (/  1 16)])

(set wire.core
  [(/ -1 16) (/ -1 2)                (/ -1 16)
   (/  1 16) (infix -1 / 2 + 1 / 16) (/  1 16)])

(set wire.front
  [(/ -1 16) (/ -1 2)                (/ -1 2)
   (/  1 16) (infix -1 / 2 + 1 / 16) (/  1 16)])

(set wire.back
  [(/ -1 16) (/ -1 2)                (/ -1 16)
   (/  1 16) (infix -1 / 2 + 1 / 16) (/  1 2)])

(set wire.left
  [(/ -1 2)  (/ -1 2)                (/ -1 16)
   (/  1 16) (infix -1 / 2 + 1 / 16) (/  1 16)])

(set wire.right
  [(/ -1 16) (/ -1 2)                (/ -1 16)
   (/  1 2)  (infix -1 / 2 + 1 / 16) (/  1 16)])

(local wire-box
  {:type "connected"         :fixed wire.core
   :connect_top   wire.top   :connect_bottom wire.core
   :connect_front wire.front :connect_back   wire.back
   :connect_left  wire.left  :connect_right  wire.right })

(local wire-overlap-box
  {:type "fixed"
   :fixed
     [wire.left wire.right
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

(fn wire-model [resis]
  (fn [pos id]
    (let [center (hash_node_pos pos)]
      (var res [])
      (each [idx vect (ipairs neighbors)]
        (table.insert res
          {:type :consumer :name (.. id "-" idx) :value resis
           :pos center :neg (hash_node_connect pos (vector.add pos vect))}))
      (values {} res))))

(fn wire-overlap-model [resis]
  (fn [pos id]
    (let [conn (twoport pos)]
      (values {} (define-circuit
        :consumer (.. id "-fst") conn.prim₁ conn.sec₁ resis
        :consumer (.. id "-snd") conn.prim₂ conn.sec₂ resis)))))

(local insulator-textures
  ["electricity_insulator.png"      "electricity_insulator.png"
   "electricity_insulator_side.png" "electricity_insulator_side.png"
   "electricity_insulator_side.png" "electricity_insulator_side.png"])

(fn wire-textures [name]
  (map (partial .. "electricity_" name)
       ["_wire.png"      "_wire.png"
        "_wire_side.png" "_wire_side.png"
        "_wire_side.png" "_wire_side.png"]))

(fn register-wire [conf]
  (local tiles (wire-textures conf.name))
  (local inv-image (.. "electricity_" conf.name "_wire_item.png"))
  (local wire-name (.. (capitalization conf.name) " wire"))

  (local wire-desc
    {:drawtype "nodebox" :is_ground_content false
     :sunlight_propagates true :paramtype "light"
     :groups {:crumbly 3 :dig_immediate 3 :conductor 1 :wire 1}
     :selection_box wire-box :node_box wire-box :use_texture_alpha "blend"
     :connects_to
       ["group:source"
        "group:conductor"
        "group:disabled_electric_tool"]
     :on_destruct reset_current})

  (core.register_node (.. "electricity:" conf.name "_wire")
    (union wire-desc {:description wire-name
                      :tiles tiles :inventory_image inv-image
                      :wield_image inv-image}))
  (core.register_alias (.. "electricity:" conf.name "_cable")
                       (.. "electricity:" conf.name "_wire"))

  (let [insulated-inv-image (.. inv-image "^electricity_insulator_item.png")]
    (core.register_node (.. "electricity:" conf.name "_insulated_wire")
      (union wire-desc {:description (.. wire-name " (insulated)")
                        :tiles insulator-textures
                        :inventory_image insulated-inv-image
                        :wield_image insulated-inv-image})))

  (core.register_node (.. "electricity:" conf.name "_wire_overlap")
    {:description (.. (capitalization conf.name) " wire (overlap)")
     :drawtype "nodebox" :tiles tiles :use_texture_alpha "blend"
     :is_ground_content false :sunlight_propagates true :paramtype "light"
     :groups {:crumbly 3 :dig_immediate 3 :conductor 1 :wire 1}
     :selection_box wire-overlap-box :node_box wire-overlap-box
     :on_destruct reset_current})
  (core.register_alias (.. "electricity:" conf.name "_cable_overlap")
                       (.. "electricity:" conf.name "_wire_overlap"))

  (tset model (.. "electricity:" conf.name "_wire") (wire-model conf.resis))
  (tset model (.. "electricity:" conf.name "_insulated_wire") (wire-model conf.resis))
  (tset model (.. "electricity:" conf.name "_wire_overlap")
              (wire-overlap-model conf.resis))
  (tset model (.. "loria:" conf.name) (wire-model (* conf.resis node-coeff))))

(foreach register-wire wires)