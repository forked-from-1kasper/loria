(global default {})
(dofile (.. (minetest.get_modpath :default) "/" "basic.lua"))
(dofile (.. (minetest.get_modpath :default) "/" "prelude.lua"))

(import
  [ "greet.lua" "conf.lua" "inv_crafts.lua" "creative.lua" "biomes.lua"
    "ores.lua" "mushrooms_nodes.lua" "small_mushrooms.lua" "mapgen.lua"
    "liquids.lua" "nodes.lua" "gases.lua" "items.lua" "craft.lua"
    "mushrooms.lua" "hud.lua" "sky.lua" "player.lua" ])

(player_api.register_model "player.b3d"
  { :animation_speed 30
    :textures [ "player.png" ]
    :animations
      { :stand     { :x 0   :y 79  }
        :lay       { :x 162 :y 166 }
        :walk      { :x 168 :y 187 }
        :mine      { :x 189 :y 198 }
        :walk_mine { :x 200 :y 219 }
        :sit       { :x 81  :y 160 } }
    :collisionbox [ -0.3 0.0 -0.3 0.3 1.7 0.3 ]
    :stepheight 0.6
    :eye_height 1.47 })

(global oxygen_hud {})

(minetest.register_on_joinplayer (fn [player]
  (let [name (player:get_player_name)]
    (player:hud_set_flags {:healthbar false})
    (tset oxygen_hud name (player:hud_add
      { :hud_elem_type "text"
        :position { :x 0 :y 0.9 }
        :text "N/A"
        :number 0xFFFFFF
        :alignment "right"
        :offset { :x 150 :y 0 }}))
    (player:set_clouds {:density 0})

    (player_api.set_model player "player.b3d")
    (player:set_local_animation
      { :x 0   :y 79 }
      { :x 168 :y 187 }
      { :x 189 :y 198 }
      { :x 200 :y 219 }
      30)

    (minetest.chat_send_player name "Welcome to Loria!"))))

(global space_suit_strength 20)

(minetest.register_on_player_hpchange
  (fn [player hp-change reason]
    (let [meta (player:get_meta)
          space-suit (meta:get_int "space_suit")]
      (if (= reason.type "set_hp") hp-change
          (> space-suit 0)
          (do (when (~= reason.type "node_damage")
                (let [new (+ space-suit (math.floor (/ hp-change 2)))]
                  if (> new 0) (meta:set_int "space_suit" new)
                     (meta:set_int "space_suit" 0))) 0)
          hp-change)))
  true)

(global START_ITEMS
  { "furnace:refiner_item" 1
    "default:oxygen_balloon" 1
    "default:empty_balloon" 1
    "default:bucket_empty" 2 })

(global init_inv (fn [player]
  (let [name (player:get_player_name)
        inv (player:get_inventory)]

    (inv:set_size "oxygen" 1)
    (inv:set_size "antiradiation" 1)
    (inv:set_size "input" 9)
    (inv:set_size "output" 9)

    (inv:add_item "main" {:name "default:drill" :count 1})
    (inv:add_item "oxygen" {:name "default:oxygen_balloon"})

    (each [name count (pairs START_ITEMS)]
      (inv:add_item "main" {:name name :count count})))))

(minetest.register_on_newplayer (fn [player]
  (init_inv player)
  (let [meta (player:get_meta)]
    (meta:set_int "oxygen" 0)
    (meta:set_float "radiation" 0)
    (meta:set_float "received_dose" 0)
    (meta:set_float "dose_damage_limit" 1)
    (meta:set_int "space_suit" space_suit_strength))))

(minetest.register_on_respawnplayer (fn [player]
  (let [meta (player:get_meta)]
    (player:set_hp 20)
    (meta:set_float "received_dose" 0)
    (meta:set_float "dose_damage_limit" 1)
    (meta:set_int "space_suit" space_suit_strength))))

(global MAX_HEIGHT 31000)
(minetest.register_globalstep (fn [_]
  (each [_ player (ipairs (minetest.get_connected_players))]
    (let [pos (player:get_pos)]
      (if (~= pos.y (- MAX_HEIGHT))
          (let [gravity (^ (/ MAX_HEIGHT (+ (. (player:get_pos) :y) MAX_HEIGHT)) 2)]
            (player:set_physics_override {:gravity gravity}))
          (player:set_physics_override {:gravity 1}))))))

(local clear-radius 500)
(minetest.register_chatcommand "clearitems"
  { :params ""
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
               (when (and entity (= entity.name "__builtin:item"))
                     (obj:remove)))))))) })