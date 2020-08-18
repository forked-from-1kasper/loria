(require-macros :useful-macros)
(require-macros :infix)

(local relay-box
  {:type "fixed"
   :fixed
     [[(/ -1 2) (/ -1 2)                (/ -1 2)
       (/  1 2) (infix -1 / 2 + 2 / 16) (/  1 2)]
      [(/ -5 16) (infix -1 / 2 + 2 / 16) (/ -6 16)
       (/  5 16) (/ 1 2)                 (/  6 16)]]})

(minetest.register_node "electricity:relay"
  {:description "Relay"
   :tiles ["electricity_relay.png"
           "electricity_relay_bottom.png"
           "electricity_relay_back_side.png"
           "electricity_relay_control_side.png"
           "electricity_relay_connect_side.png"
           "electricity_relay_connect_side.png"]
   :paramtype "light" :paramtype2 "facedir" :drawtype "nodebox"
   :node_box relay-box :selection_box relay-box
   :groups {:crumbly 3 :conductor 1}})

(local relay-resis 0.01)
(local Uₘᵢₙ 1)

(fn get-sec-resis [U]
  (real (if (≥ (math.abs U) Uₘᵢₙ) relay-resis break)))

(tset model "electricity:relay" (fn [pos id]
  (let [meta (minetest.get_meta pos)
        U (meta:get_float :U)
        (input output control) (dirtwopole pos)]
    (values {:pos control :neg ground}
      (define-circuit
        :consumer id input output (get-sec-resis U)
        :consumer (.. id "-in") input control break
        :consumer (.. id "-out") output control break)))))