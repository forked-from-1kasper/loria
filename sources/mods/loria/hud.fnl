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

(fn clamp [min max value] (math.max min (math.min value max)))

(fn get-suitable-prefix [value]
  (local prefix-step 3)
  (let [exp    (math.floor (math.log10 value))
        N      (clamp -5 +5 (math.floor (/ exp prefix-step)))
        prefix (case N -1 :m -2 :μ -3 :n -4 :p -5 :f +0 ""
                       +1 :k +2 :M +3 :G +4 :T +5 :P)]
    (values prefix (* N prefix-step))))

(fn format-prefix [value unit]
  (let [(prefix exp) (get-suitable-prefix value)]
    (string.format "%.3f %s%s" (/ value (^ 10 exp)) prefix unit)))

(fn radiation [player]
  (let [meta (player:get_meta)
        flux (* (meta:get_float "radiation") 3600)
        dose (meta:get_float "received_dose")]
    (.. "Radiant flux: " (format-prefix flux "Gy/h") "\n"
        "Est. equiv. dose: " (format-prefix dose "Sv"))))

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
