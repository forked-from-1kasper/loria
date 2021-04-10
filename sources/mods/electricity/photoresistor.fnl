(require-macros :useful-macros)

(local photoresistor-box
  {:type "fixed"
   :fixed [[(/ -1 2) (/ -1 2) (/ -1 2) (/ 1 2) 0 (/ 1 2)]]})

(fn log [b x] (/ (math.log x) (math.log b)))

(local Rₘᵢₙ     0.01)
(local Rₘₐₓ (^ 10 6))

(local γ (log 16 (/ Rₘᵢₙ Rₘₐₓ)))
(local R Rₘₐₓ)

(fn photoresistor-resis [L] (* R (^ (+ L 1) γ)))

(minetest.register_node "electricity:photoresistor"
  {:description "Photoresistor"
   :tiles ["electricity_photoresistor_top.png"
           "electricity_photoresistor_bottom.png"
           "electricity_photoresistor_side.png"
           "electricity_photoresistor_side.png"
           "electricity_photoresistor_connect_side.png"
           "electricity_photoresistor_connect_side.png"]
   :paramtype "light" :paramtype2 "facedir"
   :groups {:crumbly 3 :conductor 1} :drawtype "nodebox"
   :node_box photoresistor-box :selection_box photoresistor-box
   :use_texture_alpha "blend"

   :on_construct (set_resis 1 0) :on_destruct reset_current})

(tset model "electricity:photoresistor"
  (fn [pos id] (let [L (∨ (minetest.get_node_light pos) 0)
                     R (photoresistor-resis L)]
    (twopole :consumer id pos R))))