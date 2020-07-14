(require-macros :useful-macros)

(fn health [player]
  (.. "Health: " (player:get_hp)))

(fn space-suit [player]
  (let [meta (player:get_meta)]
    (.. "Space suit: " (meta:get_int "space_suit"))))

(fn gas [player]
  (let [pos (player:get_pos)
        name (or (get_gas (above pos)) (get_gas pos) "argon")]
    (.. "Gas: " name)))

(fn oxygen [player]
  (let [meta (player:get_meta)]
    (.. "Oxygen: " (meta:get_int "oxygen") "/" (meta:get_int "oxygen_max"))))

(fn gravity [player]
  (let [gravity (* (. (player:get_physics_override) :gravity) 100)]
    (string.format "Gravity: %.4f %%" gravity)))

(fn radiation [player]
  (let [meta (player:get_meta)]
    (.. (string.format "Radiation: %.3f CU/h" (meta:get_float "radiation")) "\n"
        (string.format "Received dose: %.3f mCU" (* (meta:get_float "received_dose") 1000)))))

(fn copyright [player]
  (join "\n" ""
             "Just Another Space Suit v15.0"
             "© 2073—2081 Skolkovo"))

(local hud-elems [health space-suit gas oxygen gravity radiation copyright])

(def-globalstep [_]
  (each [_ player (ipairs (minetest.get_connected_players))]
    (var text "")
    (each [_ func (ipairs hud-elems)]
        (set text (.. text "\n" (func player))))

    (let [hud (. oxygen_hud (player:get_player_name))]
      (player:hud_change hud "text" text))))