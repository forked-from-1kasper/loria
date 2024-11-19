(require-macros :useful-macros)

;; https://github.com/minetest/minetest_game
;; From: Minetest 0.4 mod: player
(global player_api {})

;; Player animation blending
;; Note: This is currently broken due to a bug in Irrlicht, leave at 0
(local animation-blend 0)

(local models {})
(fn player_api.register_model [name def]
  (tset models name def))

;; Player stats and animations
(local player-model    {})
(local player-anim     {})
(local player-sneak    {})

(local textures-count 7)

(fn get-texture-conf [n]
  {:head "head.png" :body "body.png"
   :mark (.. "mark_" (tostring n) ".png")
   :hand {:left "left_hand.png" :right "right_hand.png"}
   :leg  {:left "left_leg.png"  :right "right_leg.png"}})

(fn get-nth-texture [n]
  (let [conf (get-texture-conf n)]
    (table.concat [conf.head conf.body conf.hand.left conf.hand.right
                   conf.leg.left conf.leg.right conf.mark] "^")))

(fn mod-count [n] (+ (% n textures-count) 1))

(fn get-texture [name]
  (var hash 0)
  (name:gsub "." (fn [ch]
    (set hash (+ (string.byte ch) hash))))
  (get-nth-texture (mod-count hash)))

(fn player_api.set_animation [player anim-name speed]
  (let [name (player:get_player_name)]
    (when (≠ (. player-anim name) anim-name)
      (let [model (∧ (. player-model name) (. models (. player-model name)))]
        (when (∧ model (∈ anim-name model.animations))
          (let [anim (. model.animations anim-name)]
            (tset name player-anim anim-name)
            (player:set_animation anim (∨ speed model.animation_speed)
                                  animation-blend)))))))

;; Localize for better performance.
(local set-animation player_api.set_animation)

;; Called when a player’s appearance needs to be updated
(fn player_api.set_model [player model-name]
  (let [name  (player:get_player_name)
        model (. models model-name)]
    (player:set_properties
      {:mesh         model-name
       :textures     [(get-texture name)]
       :visual       "mesh"
       :visual_size  (∨ model.visual_size {:x 1 :y 1})
       :collisionbox (∨ model.collisionbox [-0.3 0.0 -0.3 0.3 1.7 0.3])
       :stepheight   (∨ model.stepheight 0.6)
       :eye_height   (∨ model.eye_height 1.47)})
    (set-animation player "stand")))

(on-leaveplayer [player]
  (let [name (player:get_player_name)]
    (tset player-model name nil)
    (tset player-anim  name nil)))

;; Check each player and apply animations
(def-globalstep [_]
  (each [_ player (pairs (core.get_connected_players))]
    (let [name       (player:get_player_name)
          model-name (. player-model name)
          model      (∧ model-name (. models model-name))]
      (when model
        (let [controls (player:get_player_control)]
          (var walking false)
          (var animation-speed-mod (∨ model.animation_speed 30))

          ;; Determine if the player is walking
          (when (∨ controls.up controls.down controls.left controls.right)
            (set walking true))

          ;; Determine if the player is sneaking, and reduce animation speed if so
          (when controls.sneak (set animation-speed-mod (/ animation-speed-mod 2)))

          ;; Apply animations based on what the player is doing
          (if (= (player:get_hp) 0) (set-animation player "lay")
              walking
              (do (when (≠ (. player-sneak name) controls.sneak)
                    (tset player-anim  name nil)
                    (tset player-sneak name controls.sneak))
                  (set-animation player (if controls.LMB "walk_mine" "walk")
                    animation-speed-mod))
              controls.LMB (set-animation player "mine")
              (set-animation player "stand" animation-speed-mod)))))))