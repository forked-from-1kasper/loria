(require-macros :useful-macros)
(require-macros :infix)

(local transformer-resis 1)

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
        (if (> (minetest.get_item_group (stack:get_name) "cable") 0)
            (stack:get_count) 0))

    :allow_metadata_inventory_move (fn [pos from-list from-index to-list to-index count player]
      (let [meta  (minetest.get_meta pos)
            inv   (meta:get_inventory)
            stack (inv:get_stack from-list from-index)]
        (if (∨ (= to-list "primary") (= to-list "secondary"))
            (if (> (minetest.get_item_group (stack:get_name) "cable") 0)
                (stack:get_count) 0)
            (stack:get_count))))})

(fn cable? [name] (≠ (minetest.get_item_group name "cable") 0))

(tset model "electricity:transformer" (fn [pos id]
  (let [meta (minetest.get_meta pos)
        inv (meta:get_inventory)
        prim-winding (inv:get_stack "primary" 1)
        sec-winding (inv:get_stack "secondary" 1)
        N1 (prim-winding:get_count)
        N2 (sec-winding:get_count)
        in-pin  (vector.new 1 0 0)
        out-pin (vector.new 0 0 1)
        prim₀ (vector.add pos in-pin)
        prim₁ (vector.add pos out-pin)
        sec₀ (vector.subtract pos in-pin)
        sec₁ (vector.subtract pos out-pin)]
    (when (and (≠ N1 0) (≠ N2 0)
               (cable? (prim-winding:get_name))
               (cable? (sec-winding:get_name)))
      [(join " " (.. "l" id "primary")
                 (hash_node_connect pos prim₀)
                 (hash_node_connect pos prim₁)
                 (^ N1 2))
       (join " " (.. "l" id "secondary")
                 (hash_node_connect pos sec₀)
                 (hash_node_connect pos sec₁)
                 (^ N2 2))
       (join " " (.. "k" id)
                 (.. "l" id "primary")
                 (.. "l" id "secondary")
                 0.999999)]))))