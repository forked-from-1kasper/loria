(require-macros :useful-macros)

(core.register_node "loria:fingunt_pessima"
  {:description "Fingunt pessima"
   :tiles [{:name "loria_fingunt_pessima.png"
            :backface_culling false
            :animation
              {:type "vertical_frames"
              :aspect_w 16
              :aspect_h 16
              :length 2.0}}]})

(local neighbors
  [(vector.new  1  0  0)
   (vector.new -1  0  0)
   (vector.new  0  1  0)
   (vector.new  0 -1  0)
   (vector.new  0  0  1)
   (vector.new  0  0 -1)])

(fn mold-grow [pos direction]
  (let [node (core.get_node pos)]
    (each [_ Δpos (ipairs neighbors)]
      (let [dist (vector.distance pos direction)
            pos′ (vector.add pos Δpos)
            node′ (core.get_node pos′)
            dist′ (vector.distance pos′ direction)]
        (when (∧ (< dist′ dist) (= node′.name "air"))
          (core.set_node pos′ {:name node.name}))))))

(core.register_abm
  {:label "mold growing"
   :nodenames ["loria:fingunt_pessima"]
   :interval 5 :chance 20 :action
     (fn [pos] (each [_ player (ipairs (core.get_connected_players))]
       (mold-grow pos (player:get_pos))))})