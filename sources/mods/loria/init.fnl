(require-macros :useful-macros)
(require-macros :infix)

(global loria {})
(dofile (.. (minetest.get_modpath :loria) "/" "basic.lua"))
(dofile (.. (minetest.get_modpath :loria) "/" "prelude.lua"))

(import :loria
  "greet" "conf" "inv_crafts" "creative" "tint" "biomes" "ores" "mushrooms_nodes"
  "small_mushrooms" "mapgen" "liquids" "nodes" "gases_arch" "gases" "items"
  "craft" "mushrooms" "hud" "sky" "player" "compatibility" "pickaxe" "radio" "mold")

;; Minetest devs sometimes do *very* strange things
;; https://github.com/minetest/minetest/issues/6711
(local start-items-default
  (.. "furnace:refiner_item 1,loria:oxygen_balloon 1,"
      "loria:empty_balloon 1,loria:bucket_empty 2,"
      "loria:silicon_box 1,radiation:sign 15"))
(local start-items {})

(let [words (or (minetest.settings:get "start_items") start-items-default)]
  (each [word (string.gmatch words "([^,]+)")]
    (table.insert start-items (ItemStack word))))

(local max-height 31000)
(local space-suit-strength 20)

(player_api.register_model "player.b3d"
  {:animation_speed 30
   :animations
     {:stand     {:x   0 :y  79}
      :lay       {:x 162 :y 166}
      :walk      {:x 168 :y 187}
      :mine      {:x 189 :y 198}
      :walk_mine {:x 200 :y 219}
      :sit       {:x  81 :y 160}}
   :collisionbox [-0.3 0.0 -0.3 0.3 1.7 0.3]
   :stepheight 0.6
   :eye_height 1.47})

(global oxygen_hud {})

(minetest.register_on_joinplayer (fn [player]
  (let [name (player:get_player_name)]
    (player:hud_set_flags {:healthbar false})
    (tset oxygen_hud name (player:hud_add
      {:hud_elem_type "text"
       :position {:x 0 :y 0.87}
       :text "N/A"
       :number 0xFFFFFF
       :alignment "right"
       :offset {:x 150 :y 0}}))

    (player:set_clouds {:density 0})

    (player:set_sun   {:texture "star.png" :scale 0.5 :sunrise_visible false})
    (player:set_moon  {:scale 7 :texture "gas_giant.png"})
    (player:set_stars {:scale 0.25 :star_color "#ffffffff" :count 4500})

    (player_api.set_model player "player.b3d")
    (player:set_local_animation
      {:x   0 :y  79}
      {:x 168 :y 187}
      {:x 189 :y 198}
      {:x 200 :y 219}
      30)

    (minetest.chat_send_player name "Welcome to Loria!"))))

(minetest.register_on_player_hpchange
  (fn [player hp-change reason]
    (let [meta (player:get_meta)
          space-suit (meta:get_int "space_suit")]
      (if (= reason.type "set_hp") hp-change
          (> space-suit 0)
          (do (when (≠ reason.type "node_damage")
                (let [new (+ space-suit (math.floor (/ hp-change 2)))]
                  (if (> new 0) (meta:set_int "space_suit" new)
                      (meta:set_int "space_suit" 0)))) 0)
          hp-change)))
  true)

(fn init-inv [player]
  (let [name (player:get_player_name)
        inv (player:get_inventory)]
    (inv:set_size "oxygen" 1)
    (inv:set_size "antiradiation" 1)
    (inv:set_size "input" 9)
    (inv:set_size "output" 9)

    (inv:add_item "main" {:name "loria:drill" :count 1})
    (inv:add_item "oxygen" {:name "loria:oxygen_balloon"})

    (let [pos (player:get_pos)]
      (each [index stack (ipairs start-items)]
        (add_or_drop inv "main" stack pos)))))

(minetest.register_on_newplayer (fn [player]
  (init-inv player)
  (let [meta (player:get_meta)]
    (meta:set_int "oxygen" 0)
    (meta:set_float "radiation" 0)
    (meta:set_float "received_dose" 0)
    (meta:set_float "dose_damage_limit" 4) ; 4 Gy whole-body
    (meta:set_int "space_suit" space-suit-strength))))

(minetest.register_on_respawnplayer (fn [player]
  (let [meta (player:get_meta)]
    (player:set_hp 20)
    (meta:set_float "received_dose" 0)
    (meta:set_float "dose_damage_limit" 4) ; 4 Gy whole-body
    (meta:set_int "space_suit" space-suit-strength))))

(def-globalstep [_]
  (each [_ player (ipairs (minetest.get_connected_players))]
    (let [pos (player:get_pos)]
      (if (≠ pos.y (- max-height))
          (let [h (. (player:get_pos) :y)
                gravity (infix (max-height / (h + max-height)) ^ 2)]
            (player:set_physics_override {:gravity gravity}))
          (player:set_physics_override {:gravity 1})))))

(local clear-radius 500)
(minetest.register_chatcommand "clearitems"
  {:params ""
   :description (.. "Deletes all items in " clear-radius " meters")
   :privs []
   :func (fn [name]
     (let [player (minetest.get_player_by_name name)]
      (when player
        (let [pos (player:get_pos)
              name (player:get_player_name)
              objs (minetest.get_objects_inside_radius pos clear-radius)]
          (each [_ obj (pairs objs)]
            (let [entity (obj:get_luaentity)]
              (when (∧ entity (= entity.name "__builtin:item"))
                    (obj:remove))))))))})

(minetest.register_privilege "kill"
  {:description "Allow to use “/kill” command"})

(minetest.register_chatcommand "kill"
  {:params "[name]" :description "Kills player" :privs {"kill" true}
   :func (fn [name₁ name₂]
     (let [name (if (≠ name₁ "") name₁ name₂)
           player (minetest.get_player_by_name name)]
       (when player (player:set_hp 0))))})
