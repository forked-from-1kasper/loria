(require-macros :useful-macros)

(defun check_craft [inv craft]
  (∀ x ∈ craft.input (inv:contains_item "input" x)))

(defun get_craft [crafts inv]
  (∃ x ∈ crafts (check_craft inv x)))

(defun update_preview [player]
  (let [inv (player:get_inventory)
        recipe (get_craft inv_crafts inv)]
    ; clear first
    (inv:set_list "output" [])

    (when (≠ recipe nil)
      (each [_ result (ipairs recipe.output)]
        (inv:add_item "output" result)))))

(minetest.register_on_player_receive_fields (λ [player formname fields]
  (when (= fields.craft_it "Craft")
    (let [inv (player:get_inventory)
          pos (player:get_pos)
          recipe (get_craft inv_crafts inv)]
      (when (≠ recipe nil)
        (foreach (partial inv:remove_item "input") recipe.input)
        (foreach (λ [result] (add_or_drop inv "main" result pos))
                 recipe.output))))
  (update_preview player)))

(minetest.register_on_player_inventory_action
  (fn [player action inventory inventory_info]
    (update_preview player)))