(minetest.register_chatcommand "greet"
  {:params "<text>"
   :description "Sends “hello world”"
   :func
     (λ [name text]
       (minetest.chat_send_player name (.. "Hello, " text "!")))})