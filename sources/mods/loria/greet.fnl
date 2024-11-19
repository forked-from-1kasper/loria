(core.register_chatcommand "greet"
  {:params "<text>"
   :description "Sends “hello world”"
   :privs {:debug true}
   :func (λ [name text] (core.chat_send_player name (.. "Hello, " text "!")))})