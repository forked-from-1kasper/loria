(require-macros :useful-macroses)

(local refiner-box
  { :type :fixed
    :fixed [ [ (/ -1 2) (/ -1 2) (/ -1 2) (/ 1 2) (/ 1 2) (/ 3 2) ] ] })

(minetest.register_node "furnace:barrier"
  { :description "Barrier"
    :groups { :cracky 2 }

    :paramtype "light"
    :paramtype2 "facedir"

    :drawtype "airlike"
    :pointable false

    :groups { :not_in_creative_inventory 1 } })

(local gases-list
  { "default:oxygen_balloon" (* balloon_coeff 3) })

(local fuel-list 
  { "default:cinnabar"           1
    "default:potassium"          2
    "default:potassium_cinnabar" 3
    "default:potassium_azure"    4
    "default:potassium_ingot"    5
    "default:bucket_trisilane"   10 })

(fn furnace-ready? [pos]
  (let [ meta (minetest.get_meta pos)
         inv (meta:get_inventory)
         gas (-> (inv:get_list :gas) (. 1) (: :get_name))
         fuel (-> (inv:get_list :fuel) (. 1) (: :get_name)) ]
    (and
      (∈ gas gases-list) (∈ fuel fuel-list)
      (= (meta:get_int :switch) 1))))

(fn reset-sound [pos]
    (-> (minetest.get_meta pos) (: :get_int :sound) minetest.sound_stop)
    (-> (minetest.get_meta pos)
        (: :set_int "sound" (minetest.sound_play "refiner" { :pos pos }))))

(local conf
  { :name "refiner"
    :description "Refiner"
    :lists { :gas 1 :fuel 1 }
    :on_tick
      [ update_fuel update_gas
        (andthen reset-sound (const true)) ]

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
      { :inactive [ "furnace_refiner.png" ]
        :active
          [ { :image "furnace_refiner_active.png"
              :backface_culling false
              :animation
                { :type "vertical_frames"
                  :aspect_w 64
                  :aspect_h 64
                  :length 1.5 } } ] }

    :groups { :not_in_creative_inventory 1 :cracky 2 }
    :after_stop (fn [pos] (-> (minetest.get_meta pos) (: :set_float :cycle 0)))

    :paramtype "light"
    :drawtype "mesh" :mesh "doubled.obj"
    :collision_box refiner-box :selection_box refiner-box

    :on_destruct
      (fn [pos]
        (let [ node (minetest.get_node pos)
               back (->> (minetest.facedir_to_dir node.param2) (vector.add pos))
               node′ (minetest.get_node back) ]
          (when (and (= (. (minetest.get_node back) :name) "furnace:barrier")
                     (= node.param2 node′.param2))
            (minetest.set_node back { :name "air" }))))

    :after_stop
      (fn [pos]
        (-> (minetest.get_meta pos) (: :set_int :switch 0))
        (-> (minetest.get_meta pos) (: :get_int :sount) minetest.sound_stop))

    :drop "furnace:refiner_item"
    :crafts refiner_crafts })

(fn conf.on_receive_fields [pos formname fields sender]
  (when (∈ :switch fields)
    (let [ meta (minetest.get_meta pos)
           active (meta:get_int :switch) ]
      (if (= active 1)
          (do (meta:set_int :switch 0)
              (check_and_stop_furnace conf pos))
          (do (meta:set_int :switch 1)
              (check_and_run_furnace conf pos))))))

(register_furnace conf)

(local rolled-refiner-box
  { :type :fixed
    :fixed [ [ (/ -7 16) (/ -1 2) (/ -7 16) (/ 7 16) (/ 6 16) (/ 7 16) ] ] })

(fn buildable? [pos]
  (let [ name (-> (minetest.get_node pos) (. :name)) ]
    (or (∈ :buildable_to (. minetest.registered_nodes name))
        (= name "furnace:refiner_item"))))

(minetest.register_node "furnace:refiner_item"
  { :description "Refiner (rolled)"
    :tiles
      [ "furnace_rolled_refiner_top.png" "furnace_rolled_refiner_top.png"
        "furnace_rolled_refiner.png"     "furnace_rolled_refiner.png"
        "furnace_rolled_refiner.png"     "furnace_rolled_refiner.png" ]
    :groups { :cracky 2 }

    :paramtype "light"
    :drawtype "nodebox"
    :node_box rolled-refiner-box
    :selection_box rolled-refiner-box

    :on_construct
      (fn [pos] (-> (minetest.get_meta pos)
                    (: :set_string :infotext "Right click to unroll")))

    :on_rightclick
      (fn [pos node clicker itemstack pointed_thing]
        (when (and pointed_thing (= pointed_thing.type "node"))
          (let [ param2 (-> (clicker:get_look_dir) minetest.dir_to_facedir)
                 dir (minetest.facedir_to_dir param2)
                 back (vector.add pos dir) ]
            (when (and (buildable? pos) (buildable? back))
              (minetest.set_node pos  { :name "furnace:refiner" :param2 param2 })
              (minetest.set_node back { :name "furnace:barrier" :param2 param2 })))
          {})) })