(require-macros :infix)

(local multimeter-box
  {:type "fixed"
   :fixed
     [[(/ -1 2)  (/ -1 2)                (/ -1 2)
       (/  1 2)  (infix -1 / 2 + 1 / 16) (/  1 2)]
      [(/ -4 16) (infix -1 / 2 + 1 / 16) (infix -1 / 2 + 2 / 16)
       (/  4 16) (infix  1 / 2 - 2 / 16) (infix  1 / 2 - 2 / 16)]]})

(local multimeter-resis {:min 0.015 :max 1500})

(local k 10)
(fn multimeter-resis-step [R]
  (let [r (* k R)]
    (if (> r multimeter-resis.max)
        multimeter-resis.min r)))

(fn update-infotext [meta]
  (let [I (meta:get_float :I)
        U (meta:get_float :U)
        R (meta:get_float :resis)]
    (meta:set_string :infotext
      (string.format "I = %.1f A\nU = %.1f V\nR = %.3f Ohms" I U R))))

(core.register_node "electricity:multimeter"
  {:description "Multimeter"
   :tiles
     ["electricity_multimeter_top.png"
      "electricity_multimeter_bottom.png"
      "electricity_multimeter_front.png"
      "electricity_multimeter_back.png"
      "electricity_multimeter_side.png"
      "electricity_multimeter_side.png"]
   :paramtype "light"
   :paramtype2 "facedir"

   :drop "electricity:multimeter"
   :groups {:dig_immediate 3 :conductor 1}

   :on_construct (andthen
     (set_resis multimeter-resis.min)
     (comp update-infotext core.get_meta))
   :on_destruct reset_current

   :drawtype "nodebox" :use_texture_alpha "blend"
   :node_box multimeter-box :selection_box multimeter-box

   :on_rightclick (fn [pos node clicker itemstack pointed_thing]
       (let [meta (core.get_meta pos)]
         (->> (meta:get_float :resis)
               multimeter-resis-step
              (meta:set_float :resis))
         (update-infotext meta)))})

(tset model "electricity:multimeter" vconsumer)
(tset on_circuit_tick "electricity:multimeter" update-infotext)

(core.register_craftitem "electricity:multimeter_debug"
  {:inventory_image "electricity_multimeter.png"
   :description "Multimeter (debug tool)"
   :stack_max 1
   :liquids_pointable true
   :on_use (fn [itemstack user pointed_thing]
     (when (= pointed_thing.type :node)
       (let [meta (core.get_meta pointed_thing.under)
             I  (meta:get_float :I)
             φᵢ (math.deg (meta:get_float :φᵢ))
             U  (meta:get_float :U)
             φᵤ (math.deg (meta:get_float :φᵤ))]
         (core.chat_send_player (user:get_player_name)
           (string.format "I = %f A, φᵢ = %f°, U = %f V, φᵤ = %f°" I φᵢ U φᵤ)))))})