(require-macros :useful-macros)
(require-macros :infix)

(local gain 100)
(local amplifier-resis 0.01)

(local amplifier-box
  {:type "fixed"
   :fixed [[(/ -1 2) (/ -1 2) (/ -1 2) (/ 1 2) (infix -1 / 2 + 5 / 16) (/ 1 2)]]})

(core.register_node "electricity:amplifier"
  {:description "Amplifier"
   :tiles ["electricity_amplifier_top.png"
           "electricity_amplifier_bottom.png"
           "electricity_amplifier_side.png"
           "electricity_amplifier_out.png"
           "electricity_amplifier_plus.png"
           "electricity_amplifier_minus.png"]
   :paramtype "light" :paramtype2 "facedir" :drawtype "nodebox"
   :node_box amplifier-box :selection_box amplifier-box
   :use_texture_alpha "blend" :groups {:crumbly 3 :conductor 1}})

(tset model "electricity:amplifier" (fn [pos id]
  (let [meta (core.get_meta pos) U (meta:get_float :U)
        (minus plus out) (dirtwopole pos)]
    (values {:pos plus :neg minus}
      (define-circuit
        :consumer (.. id "-plus") out plus break
        :consumer (.. id "-minus") out minus break
        :consumer (.. id "-resis") plus minus amplifier-resis
        :voltage id ground out (* gain U))))))