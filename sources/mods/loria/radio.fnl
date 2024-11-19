(require-macros :useful-macros)

(fn get-number [src patt]
  (tonumber (string.match src patt)))

(fn get-spawnpoint [player name]
  (let [meta (player:get_meta)]
    (core.string_to_pos (meta:get_string "spawnpoint"))))

(fn teleport-to-spawnpoint [name]
  (let [player (core.get_player_by_name name)]
    (when player (let [pos (get-spawnpoint player name)]
      (if pos (player:setpos pos)
        (core.chat_send_player name "You do not have a spawnpoint."))))))

(fn set-spawnpoint [name]
  (let [player (core.get_player_by_name name)]
    (when player (let [meta (player:get_meta) pos (player:get_pos)
                       spawnpoint (core.pos_to_string pos)]
      (meta:set_string "spawnpoint" spawnpoint)
      (core.chat_send_player name
        (string.format "%s’s spawnpaint was set to %s" name spawnpoint))))))

(core.register_chatcommand "setspawnpoint"
  {:params "" :description "Sets spawnpoint."
   :privs {:creative true} :func set-spawnpoint})

(core.register_chatcommand "tpspawnpoint"
  {:params "" :description "Teleports to spawnpoint."
   :privs {:creative true} :func teleport-to-spawnpoint})