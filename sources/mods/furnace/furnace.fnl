(require-macros :useful-macros)

(fn furnace-formspec [conf craft-percent meta]
  (.. "size[11,9.5]"
      "label[4,0.5;Input]"
      "image[7,2;1,1;gui_arrow.png^[lowpart:" craft-percent ":gui_active_arrow.png^[transformR270]"
      "list[context;input;4,1;3,3;]"
      "label[8,0.5;Output]"
      "list[context;output;8,1;3,3;]"
      "list[current_player;main;2,5;8,1;]"
      "list[current_player;main;2,6.5;8,3;8]"
      (conf.additional_formspec meta)))

(defun run_furnace [conf pos]
  (when conf.before_run (conf.before_run pos))
  (: (core.get_node_timer pos) :start 0.3)
  (swap_node pos (.. "furnace:" conf.name "_active")))

(defun stop_furnace [conf pos]
  (let [meta (core.get_meta pos)]
    (swap_node pos (.. "furnace:" conf.name))

    (meta:set_string "formspec" (furnace-formspec conf 0 meta))
    (meta:set_float "cooking" 0)

    (: (core.get_node_timer pos) :stop)

    (when conf.after_stop (conf.after_stop pos))))

(defun check_and_run_furnace [conf pos]
  (when (conf.is_furnace_ready pos)
    (run_furnace conf pos)))

(defun check_and_stop_furnace [conf pos]
  (when (¬ conf.is_furnace_ready pos)
    (stop_furnace conf pos)))

(defun furnace_on_timer [conf]
  (fn [pos elapsed]
    (let [meta (core.get_meta pos)
          inv  (meta:get_inventory)]
      (each [_ func (ipairs conf.on_tick)]
        (when (¬ func pos elapsed)
          (stop_furnace conf pos)
          (return! true)))

      (var cooking (+ (meta:get_float "cooking") elapsed))
      (local recipe (get_craft conf.crafts inv))

      (when (∧ (≠ recipe nil) (≥ cooking recipe.time))
        (set cooking 0)

        (each [_ reagent (ipairs recipe.input)]
          (inv:remove_item "input" reagent))

        (each [_ result (ipairs recipe.output)]
          (add_or_drop inv "output" result (above pos))))

      (if (= recipe nil)
        (do (set cooking 0) (meta:set_string "formspec" (furnace-formspec conf 0 meta)))
        (meta:set_string "formspec" (furnace-formspec conf
          (math.floor (* 100 (/ cooking recipe.time))) meta)))

      (meta:set_float "cooking" cooking)
      true)))

(fn construct-furnace [conf]
  (fn [pos]
    (let [meta (core.get_meta pos)
          inv  (meta:get_inventory)]
      (meta:set_string "formspec" (furnace-formspec conf 0 meta))
      (meta:set_float "cycle" 0)
      (meta:set_float "cooking" 0)

      (inv:set_size "input"  9)
      (inv:set_size "output" 9)

      (each [name size (pairs conf.lists)]
        (inv:set_size name size))

      (when conf.on_construct
        (conf.on_construct pos)))))

(defun register_furnace [conf]
  (core.register_node (.. "furnace:" conf.name)
    {:description conf.description
     :drop (or conf.drop (.. "furnace:" conf.name))
     :tiles conf.textures.inactive

     :on_destruct (andthen (or conf.on_destruct nope) drop_everything)
     :on_construct (construct-furnace conf)

     :paramtype2 "facedir"
     :legacy_facedir_simple true
     :groups (or conf.groups {})

     :paramtype     conf.paramtype
     :drawtype      conf.drawtype
     :mesh          conf.mesh
     :collision_box conf.collision_box
     :selection_box conf.selection_box

     :use_texture_alpha conf.use_texture_alpha

     :allow_metadata_inventory_put
      (fn [pos listname index stack player]
        (if (= listname "output") 0
            (stack:get_count)))

     :on_metadata_inventory_move
      (fn [pos from-list from-index to-list to-index count player]
        (check_and_run_furnace conf pos))
     :on_metadata_inventory_put
      (fn [pos listname index stack player]
        (check_and_run_furnace conf pos))
     :on_metadata_inventory_take
      (fn [pos listname index stack player]
        (check_and_run_furnace conf pos))

     :on_receive_fields conf.on_receive_fields})

  (core.register_node (.. "furnace:" conf.name "_active")
    {:description (.. conf.description " (active)")
     :drop (or conf.drop (.. "furnace:" conf.name))
     :tiles conf.textures.active

     :light_source conf.light_source
     :paramtype2 "facedir"
     :legacy_facedir_simple true
     :groups (union (or conf.groups {}) {:not_in_creative_inventory 1})

     :paramtype     conf.paramtype
     :drawtype      conf.drawtype
     :mesh          conf.mesh
     :collision_box conf.collision_box
     :selection_box conf.selection_box

     :use_texture_alpha conf.use_texture_alpha

     :allow_metadata_inventory_put
      (fn [pos listname index stack player]
        (if (= listname "output") 0
            (stack:get_count)))

     :allow_metadata_inventory_move
      (fn [pos from-list from-index to-list to-index count player]
        (if (= to-list "input") 0
          (let [meta  (core.get_meta pos)
                inv   (meta:get_inventory)
                stack (inv:get_stack from-list from-index)]
            (stack:get_count))))

     :allow_metadata_inventory_take
      (fn [pos listname index stack player]
        (stack:get_count))

     :on_metadata_inventory_move
      (fn [pos from-list from-index to-list to-index count player]
        (check_and_stop_furnace conf pos))
     :on_metadata_inventory_put
      (fn [pos listname index stack player]
        (check_and_stop_furnace conf pos))
     :on_metadata_inventory_take
      (fn [pos listname index stack player]
        (check_and_stop_furnace conf pos))

     :on_destruct (andthen (or conf.on_destruct nope) drop_everything)
     :on_timer (furnace_on_timer conf)

     :on_receive_fields conf.on_receive_fields}))