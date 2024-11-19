(require-macros :useful-macros)

(local no-top-neighbors
  [(vector.new  1  0  0)
   (vector.new -1  0  0)
   (vector.new  0 -1  0)
   (vector.new  0  0  1)
   (vector.new  0  0 -1)])

(fn get-neighbors [pos heavy]
  (let [add-pos (partial vector.add pos)]
    (map add-pos (if heavy no-top-neighbors neighbors))))

(local heavy? {})
(defun detect_gas [name]
  (and (> (core.get_item_group name "gas") 0)
       (. core.registered_nodes name :description)))

(fn process-gas [gas pos]
  (let [node (core.get_node pos)]
    (var accepted [pos])
    (each [_ v (ipairs (get-neighbors pos (. heavy? gas.name)))]
      (let [neighbor (core.get_node v)
            reaction (. gas.reactions neighbor.name)]
        (if (≠ reaction nil)
            (do (core.swap_node v
                  {:name   reaction.result
                   :param1 neighbor.param1
                   :param2 neighbor.param2})
                (if reaction.gas
                    (core.swap_node pos
                      {:name   reaction.gas
                       :param1 node.param1
                       :param2 node.param2})
                    (core.set_node pos {:name "air"})))
            (or (= neighbor.name node.name)
                (= neighbor.name "air")
                (gas.destroys neighbor.name))
            (table.insert accepted v)
            _ (nope))))

    (tset node :param2 (- node.param2 (length accepted) -1))
    (if (≥ node.param2 128)
      (each [_ v (ipairs accepted)]
        (core.swap_node v node))
      (core.set_node pos {:name "air"}))))

(local gas-levels 255)
(defun register_gas [gas]
  (tset heavy? gas.name gas.heavy)
  (core.register_node (.. "loria:" gas.name)
    {:description gas.name
     :tiles [(.. "loria_gas.png^[opacity:" (or gas.alpha 128))]
     :drawtype (if gas.transparent "airlike" "glasslike")
     :paramtype "light"
     :paramtype2 "color"
     :palette gas.palette
     :damage_per_second gas.damage
     :sunlight_propagates true
     :use_texture_alpha "blend"
     :walkable false
     :post_effect_color gas.post_effect_color
     :drop []
     :pointable false
     :buildable_to true
     :light_source (or gas.light_source 0)
     :groups {:not_in_creative_inventory 1 :gas 1}})

    (core.register_abm
      {:nodenames [(.. "loria:" gas.name)]
       :interval 1
       :chance 2
       :action (partial process-gas gas)})

    (when (not gas.no_balloon)
      (core.register_tool (.. "loria:" gas.name "_balloon")
        {:inventory_image (.. "loria_empty_balloon.png^[combine:16x16:0,0=" gas.icon)
         :description (.. (capitalization gas.name) " balloon")
         :stack_max 1
         :on_use (fn [itemstack user pointed-thing]
            (when (= pointed-thing.type "node")
              (let [wear  (- 65535 (itemstack:get_wear))
                    value (math.ceil (* wear (/ 128 65535)))]
                (core.add_node pointed-thing.above
                  {:name (.. "loria:" gas.name)
                   :param2 (+ 127 value)})
                {:name "loria:empty_balloon"})))})))

(local attack-radius 30)
(local attack-step 10)
(core.register_chatcommand "chemical_attack"
  {:params "<gas>"
   :description "Sends gas"
   :privs {:debug true}
   :func (fn [name gas]
     (let [player (core.get_player_by_name name)]
       (when player
         (let [pos (player:get_pos)]
           (for [x (- pos.x attack-radius) (+ pos.x attack-radius) attack-step]
             (for [z (- pos.z attack-radius) (+ pos.z attack-radius) attack-step]
               (core.set_node
                 {:x x :y pos.y :z z}
                 {:name (.. "loria:" gas) :param2 gas-levels})))
           (core.chat_send_player name "Done")))))})

(local fill-radius 10)
(core.register_chatcommand "fill"
  {:params "<nodename>"
   :description (string.format "Fill %d × %d square" fill-radius fill-radius)
   :privs {:debug true}
   :func (fn [name nodename]
     (let [player (core.get_player_by_name name)]
       (when (∧ nodename player (∈ nodename core.registered_nodes))
         (let [pos (player:get_pos)]
           (for [x (- pos.x fill-radius) (+ pos.x fill-radius)]
             (for [z (- pos.z fill-radius) (+ pos.z fill-radius)]
               (core.set_node {:x x :y (- pos.y 1) :z z}
                                  {:name nodename})))
           (core.chat_send_player name "Done")))))})

(core.register_chatcommand "cid"
  {:params "<node>"
   :description "Returns content id."
   :privs {:debug true}
   :func (fn [name node]
           (let [(ok cid) (pcall (fn [] (core.get_content_id node)))]
             (when ok (core.chat_send_player name (tostring cid)))))})

(core.register_abm
  {:label "Chlorine source"
   :nodenames ["loria:test"]
   :interval 1 :chance 1
   :action (fn [pos]
     (let [pos′ (above pos)]
       (when (= (. (core.get_node pos′) :name) "air")
         (core.set_node pos′ {:name "loria:chlorine" :param2 gas-levels}))))})

(core.register_abm
  {:label "Oxygen source"
   :nodenames ["loria:infinite_oxygen"]
   :interval 1 :chance 1
   :action (fn [pos]
     (let [vects [(vector.new 0  1  0)
                  (vector.new 1  0  0)
                  (vector.new -1 0  0)
                  (vector.new 0  0  1)
                  (vector.new 0  0 -1)]]
       (each [_ vect (ipairs vects)]
         (let [v (vector.add pos vect)]
           (when (= (. (core.get_node v) :name) "air")
             (core.set_node v {:name "loria:oxygen" :param2 gas-levels}))))))})