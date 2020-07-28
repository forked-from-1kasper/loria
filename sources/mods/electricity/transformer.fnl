(require-macros :useful-macros)
(require-macros :infix)

(local transformer-resis 0.0001)

(local transformer-box
  {:type "fixed"
   :fixed
     [;; Bottom
      [(/ -1 2)                (/ -1 2)
       (/ -1 2)                (/  1 2)
       (infix -1 / 2 + 2 / 16) (/  1 2)]
      ;; Core bottom
      [(infix -1 / 2 + 5 / 16) (infix -1 / 2 + 2 / 16)
       (infix -1 / 2 + 2 / 16) (infix  1 / 2 - 5 / 16)
       (infix -1 / 2 + 4 / 16) (infix  1 / 2 - 2 / 16)]
      ;; Core top
      [(infix -1 / 2 + 5 / 16) (infix  1 / 2 - 4 / 16)
       (infix -1 / 2 + 2 / 16) (infix  1 / 2 - 5 / 16)
       (infix  1 / 2 - 2 / 16) (infix  1 / 2 - 2 / 16)]
      ;; Core side
      [(infix -1 / 2 + 5 / 16) (infix -1 / 2 + 4 / 16)
       (infix -1 / 2 + 2 / 16) (infix  1 / 2 - 5 / 16)
       (infix  1 / 2 - 4 / 16) (infix -1 / 2 + 4 / 16)]
      ;; Core side
      [(infix -1 / 2 + 5 / 16) (infix -1 / 2 + 4 / 16)
       (infix  1 / 2 - 4 / 16) (infix  1 / 2 - 5 / 16)
       (infix  1 / 2 - 4 / 16) (infix  1 / 2 - 2 / 16)]
      ;; Inductor
      [(infix -1 / 2 + 4 / 16) (infix -1 / 2 + 5 / 16)
       (infix -1 / 2 + 1 / 16) (infix  1 / 2 - 4 / 16)
       (infix  1 / 2 - 5 / 16) (infix -1 / 2 + 5 / 16)]
      ;; Inductor
      [(infix -1 / 2 + 4 / 16) (infix -1 / 2 + 5 / 16)
       (infix  1 / 2 - 5 / 16) (infix  1 / 2 - 4 / 16)
       (infix  1 / 2 - 5 / 16) (infix  1 / 2 - 1 / 16)]]})

(fn setup-transformer-formspec [pos]
  (let [meta (minetest.get_meta pos)
        inv  (meta:get_inventory)]
    (inv:set_size "primary" 1)
    (inv:set_size "secondary" 1)
    (meta:set_string "formspec"
      (.. "size[8,6.5]"
          "label[2,0;Primary winding]"
          "list[context;primary;2,0.5;1,1;]"
          "label[5,0;Secondary winding]"
          "list[context;secondary;5,0.5;1,1;]"
          "list[current_player;main;0,2;8,1;]"
          "list[current_player;main;0,3.5;8,3;8]"))))

(fn wire? [name] (≠ (minetest.get_item_group name "wire") 0))

(minetest.register_node "electricity:transformer"
  {:description "Transformer"
   :tiles
     ["electricity_transformer_top.png"
      "electricity_transformer.png"
      "electricity_transformer_side_primary.png"
      "electricity_transformer_side_secondary.png"
      "electricity_transformer_front_primary.png"
      "electricity_transformer_front_secondary.png"]
   :groups {:crumbly 3 :conductor 1}

   :paramtype "light"        :drawtype "nodebox"
   :node_box transformer-box :selection_box transformer-box

    :on_construct
      (fn [pos]
        (setup-transformer-formspec pos)
        ((set_resis transformer-resis) pos))
    :on_destruct (andthen reset_current drop_everything)

    :allow_metadata_inventory_put (fn [pos listname index stack player]
        (if (wire? (stack:get_name)) (stack:get_count) 0))

    :allow_metadata_inventory_move (fn [pos from-list from-index to-list to-index count player]
      (let [meta  (minetest.get_meta pos)
            inv   (meta:get_inventory)
            stack (inv:get_stack from-list from-index)]
        (if (∨ (= to-list "primary") (= to-list "secondary"))
            (if (wire? (stack:get_name)) (stack:get_count) 0)
            (stack:get_count))))})

(tset model "electricity:transformer" (fn [pos id]
  (let [meta (minetest.get_meta pos)
        inv (meta:get_inventory)
        prim-winding (inv:get_stack "primary" 1)
        sec-winding (inv:get_stack "secondary" 1)
        N₁ (prim-winding:get_count)
        N₂ (sec-winding:get_count)
        conn (twoport pos)
        T (.. id "-zero")]
    (when (and (≠ N₁ 0) (≠ N₂ 0)
               (wire? (prim-winding:get_name))
               (wire? (sec-winding:get_name)))
      (if (≠ N₁ N₂)
        (let [L₁₂ (math.sqrt (* N₁ N₂))
              L₁  (- N₁ L₁₂)
              L₂  (- N₂ L₁₂)]
          (values {} (define-circuit
            :consumer (.. id "-prim")  conn.prim₁ T          (inductance L₁)
            :consumer (.. id "-sec")   T          conn.sec₁  (inductance L₂)
            :consumer (.. id "-T")     T          conn.prim₂ (inductance L₁₂)
            :consumer (.. id "-resis") conn.prim₂ conn.sec₂  (real transformer-resis))))
        (values {} (define-circuit
          :consumer (.. id "-fst") conn.prim₁ conn.sec₁ (real transformer-resis)
          :consumer (.. id "-snd") conn.prim₂ conn.sec₂ (real transformer-resis))))))))