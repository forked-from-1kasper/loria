(require-macros :useful-macros)

(minetest.register_node "loria:fingunt_pessima"
  {:description "Fingunt pessima"
   :tiles [{:name "loria_fingunt_pessima.png"
            :backface_culling false
            :animation
              {:type "vertical_frames"
              :aspect_w 16
              :aspect_h 16
              :length 2.0}}]})