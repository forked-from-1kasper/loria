(require-macros :useful-macros)
(require-macros :infix)

(local creative? (core.settings:get_bool "creative_mode"))

(var craft-list-formspec "")

(local special-names
  {"furnace:gas"      "Gas powered furnace (lead)"
   "furnace:thorium"  "Gas powered furnace (thorium)"
   "furnace:electric" "Electric furnace"})

(fn process-content-name [name]
  (∨ (. special-names name) (capitalization (name:gsub "^%a+:" ""))))

(fn process-stack-list [stack-list]
  (map (fn [stack]
    (string.format "%s,%d" (process-content-name stack.name)
                           (∨ stack.count 1)))
    stack-list))

(fn process-craft [id craft]
  (let [in  (process-stack-list craft.input)
        out (process-stack-list craft.output)
        N   (math.max (length in) (length out))]
    (var res (string.format "%d,Input,N,Output,N" id))
    (for [idx 1 N]
      (let [in′  (∨ (. in  idx) ",")
            out′ (∨ (. out idx) ",")]
        (set res (table.concat [res "-" in′ out′] ","))))
    res))

(on-mods-loaded
  (fn craft-list-append [s]
    (set craft-list-formspec (.. craft-list-formspec s)))

  (fn append-table [name tbl]
    (craft-list-append (string.format ",%s,,,," name))
    (craft-list-append (table.concat (imap process-craft tbl) ",")))

  (fn sep [] (craft-list-append ","))

  (craft-list-append "size[10,10]button[4,9;2,1;go_to_survival;Back]")
  (craft-list-append "tablecolumns[text;text;text;text;text]")
  (craft-list-append "table[0.5,0.5;9,8.5;craft_list;")
  (append-table "Inventory"            inv_crafts) (sep)
  (append-table "Furnace"              furnace_crafts) (sep)
  (append-table "Furnace (high temp.)" high_temperature_crafts) (sep)
  (append-table "Refiner"              refiner_crafts)
  (craft-list-append ";1]"))

(fn player-formspec []
  (let [str (.. "size[9,10.5]"
                "label[0,0.5;Oxygen]"
                "list[context;oxygen;0,1;1,1;]"
                "label[0,2.5;Drugs]"
                "list[context;antiradiation;0,3;1,1;]"
                "label[2,0.5;Input]"
                "image[5,2;1,1;gui_arrow.png^[transformR270]"
                "button[5,3;1,1;craft_it;Craft]"
                "list[context;input;2,1;3,3;]"
                "label[6,0.5;Output]"
                "list[context;output;6,1;3,3;]"
                "list[context;main;0.5,6;8,1;]"
                "list[context;main;0.5,7.5;8,3;8]"
                "button[0.5,4.5;2,1;go_to_recipes;Recipes]")]
    (if creative? (.. str "button[3.5,4.5;2,1;go_to_creative;Creative]") str)))

(local (creative-formspec-width creative-formspec-height)
       (values 8 4))

(var creative-inv [])

(local shift-min 1)
(var shift-max nil)

(on-mods-loaded
  (each [name params (pairs core.registered_items)]
    (when (not params.groups.not_in_creative_inventory)
      (table.insert creative-inv name)))
  (let [pages (math.floor (/ (length creative-inv) creative-formspec-width))]
  (set shift-max (infix 1 + (pages - creative-formspec-height + 1) * creative-formspec-width))))

(fn creative-formspec [shift]
  (.. "size[9,10.5]"
      "list[context;creative_inv;0.5,0.5;"
      creative-formspec-width ","
      creative-formspec-height ";" shift "]"
      "button[2.5,4.5;1,1;creative_up;Up]"
      "button[5.5,4.5;1,1;creative_down;Down]"
      "button[3.5,4.5;2,1;go_to_survival;Survival]"
      "list[context;main;0.5,6;8,1;]"
      "list[context;main;0.5,7.5;8,3;8]"))

(core.register_on_player_receive_fields (fn [player formname fields]
  (let [inv (player:get_inventory)
        meta (player:get_meta)]
    (if fields.go_to_creative
        (player:set_inventory_formspec
          (creative-formspec (meta:get_int "creative_shift")))
        fields.go_to_survival
        (player:set_inventory_formspec (player-formspec))
        fields.go_to_recipes
        (player:set_inventory_formspec craft-list-formspec)
        fields.creative_down
        (do (let [shift  (meta:get_int "creative_shift")
                  shift′ (+ shift 8)
                  shift″ (if (> shift′ shift-max) shift-max shift′)]
              (meta:set_int "creative_shift" shift″)
              (player:set_inventory_formspec (creative-formspec shift″))))
        fields.creative_up
        (do (let [shift  (meta:get_int "creative_shift")
                  shift′ (- shift 8)
                  shift″ (if (< shift′ shift-min) shift-min shift′)]
              (meta:set_int "creative_shift" shift″)
              (player:set_inventory_formspec (creative-formspec shift″)))))
    (inv:set_list "creative_inv" creative-inv))))

(core.register_privilege "creative"
  {:description "Creative game mode"
   :give_to_singleplayer false
   :give_to_admin false})

(local creative-privs ["fly" "fast" "give" "noclip" "settime" "teleport" "creative"])

(on-joinplayer [player]
  (let [meta (player:get_meta)
        inv (player:get_inventory)
        name (player:get_player_name)]
    (meta:set_int "creative_shift" 1)
    (inv:set_size "creative_inv" (length creative-inv))
    (inv:set_list "creative_inv" creative-inv)

    (player:set_inventory_formspec (player-formspec))

    (let [privs    (core.get_player_privs name)
          granted? (∨ creative? nil)]
      (foreach (fn [priv] (tset privs priv granted?)) creative-privs)
      (core.set_player_privs name privs))))

(fn is-valid-balloon? [name]
  (= name "loria:oxygen_balloon"))

(core.register_allow_player_inventory_action
  (fn [player action inventory inventory_info]
    (if (= action "move")
        (let [inv (player:get_inventory)
              stack (inv:get_stack inventory_info.from_list inventory_info.from_index)]
          (if (= inventory_info.from_list "output") 0
              (= inventory_info.from_list "creative_inv")
              (do (stack:set_count (+ (stack:get_count) inventory_info.count))
                  (inv:set_stack "creative_inv" inventory_info.from_index stack)
                  inventory_info.count)
              (= inventory_info.to_list "oxygen")
              (if (is-valid-balloon? (stack:get_name))
                  (stack:get_count) 0)
              (or (= inventory_info.to_list "output")
                  (= inventory_info.to_list "creative_inv")) 0
              (stack:get_count)))
        (= action "put")
        (if (= inventory_info.listname "oxygen")
            (if (is-valid-balloon? (inventory_info.stack:get_name))
                (inventory_info.stack:get_count) 0)
            (or (= inventory_info.listname "output")
                (= inventory_info.listname "creative_inv")) 0
            (inventory_info.stack:get_count))
        (= action "take")
        (if (= inventory_info.listname "output") 0
            (= inventory_info.listname "creative_inv") -1
            (inventory_info.stack:get_count)))))