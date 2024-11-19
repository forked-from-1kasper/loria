(require-macros :useful-macros)

(local refiner-box
  {:type :fixed
   :fixed [[(/ -1 2) (/ -1 2) (/ -1 2) (/ 1 2) (/ 1 2) (/ 3 2)]]})

(core.register_node "furnace:barrier"
  {:description "Barrier"
   :groups {:cracky 2}
   :paramtype "light"
   :paramtype2 "facedir"
   :drawtype "airlike"
   :pointable false
   :groups {:not_in_creative_inventory 1}})

(local gases-list
  {"loria:oxygen_balloon" (* balloon_coeff 3)})

(fn furnace-ready? [pos]
  (let [meta (core.get_meta pos)
        inv  (meta:get_inventory)
        gas  (-> (inv:get_list :gas)  (. 1) (: :get_name))
        fuel (-> (inv:get_list :fuel) (. 1) (: :get_name))]
    (∧ (∈ gas gases-list) (∈ fuel fuel_list)
       (= (meta:get_int :switch) 1))))

(fn reset-sound [pos]
  (-> (core.get_meta pos) (: :get_int :sound) core.sound_stop)
  (-> (core.get_meta pos)
      (: :set_int "sound" (core.sound_play "refiner" {:pos pos}))))

(local conf
  {:name "refiner"
   :description "Refiner"
   :lists {:gas 1 :fuel 1}
   :on_tick
     [(update_fuel fuel_list) update_gas
      (andthen reset-sound (const true))]
   :use_texture_alpha "blend"

   :is_furnace_ready furnace-ready?
   :additional_formspec
     (fn [meta]
       (..
         "label[0,1.5;Gas]"
         "list[context;gas;0,2;1,1;]"
         "label[2,1.5;Fuel]"
         "list[context;fuel;2,2;1,1;]"
         "button[7,3;1,1;switch;On/off]"))

   :textures
     {:inactive ["furnace_refiner.png"]
      :active
        [{:image "furnace_refiner_active.png"
          :backface_culling false
          :animation
            {:type "vertical_frames"
             :aspect_w 64
             :aspect_h 64
             :length 1.5}}]}

    :groups {:not_in_creative_inventory 1 :cracky 2}
    :after_stop (fn [pos] (-> (core.get_meta pos) (: :set_float :cycle 0)))

    :paramtype "light"
    :drawtype "mesh" :mesh "doubled.obj"
    :collision_box refiner-box :selection_box refiner-box

    :on_destruct
      (fn [pos]
        (let [node (core.get_node pos)
              back (->> (core.facedir_to_dir node.param2) (vector.add pos))
              node′ (core.get_node back)]
          (when (∧ (= (. (core.get_node back) :name) "furnace:barrier")
                   (= node.param2 node′.param2))
            (core.set_node back {:name "air"}))))

    :after_stop
      (fn [pos]
        (-> (core.get_meta pos) (: :set_int :switch 0))
        (-> (core.get_meta pos) (: :get_int :sount) core.sound_stop))

    :drop "furnace:refiner_item"
    :crafts refiner_crafts})

(fn conf.on_receive_fields [pos formname fields sender]
  (when (∈ :switch fields)
    (let [meta   (core.get_meta pos)
          active (meta:get_int :switch)]
      (if (= active 1)
          (do (meta:set_int :switch 0)
              (check_and_stop_furnace conf pos))
          (do (meta:set_int :switch 1)
              (check_and_run_furnace conf pos))))))

(register_furnace conf)

(local rolled-refiner-box
  {:type :fixed
   :fixed [[(/ -7 16) (/ -1 2) (/ -7 16) (/ 7 16) (/ 6 16) (/ 7 16)]]})

(fn buildable? [pos]
  (let [name (-> (core.get_node pos) (. :name))]
    (or (∈ :buildable_to (. core.registered_nodes name))
        (= name "furnace:refiner_item"))))

(core.register_node "furnace:refiner_item"
  {:description "Refiner (rolled)"
   :tiles
     ["furnace_rolled_refiner_top.png" "furnace_rolled_refiner_top.png"
      "furnace_rolled_refiner.png"     "furnace_rolled_refiner.png"
      "furnace_rolled_refiner.png"     "furnace_rolled_refiner.png"]
   :groups {:cracky 2}
   :use_texture_alpha "blend"

   :paramtype "light"
   :drawtype "nodebox"
   :node_box rolled-refiner-box
   :selection_box rolled-refiner-box

   :on_construct
     (fn [pos] (-> (core.get_meta pos)
                   (: :set_string :infotext "Right click to unroll")))

   :on_rightclick
     (fn [pos node clicker itemstack pointed_thing]
       (when (∧ pointed_thing (= pointed_thing.type "node"))
         (let [param2 (-> (clicker:get_look_dir) core.dir_to_facedir)
               dir (core.facedir_to_dir param2)
               back (vector.add pos dir)]
           (when (∧ (buildable? pos) (buildable? back))
             (core.set_node pos  {:name "furnace:refiner" :param2 param2})
             (core.set_node back {:name "furnace:barrier" :param2 param2})))
         {}))})