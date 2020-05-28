(require-macros :useful-macros)
(require-macros :infix)

(local gases-list
  {"default:oxygen_balloon" (* balloon_coeff 3)})

(fn furnace-ready? [pos]
  (let [meta (minetest.get_meta pos)
        inv  (meta:get_inventory)
        gas  (: (first inv:get_list :gas)  :get_name)
        fuel (: (first inv:get_list :fuel) :get_name)]
    (∧ (∈ gas gases-list) (∈ fuel fuel_list))))

(defun update_gas [pos elapsed]
  (let [meta  (minetest.get_meta pos)
        inv   (meta:get_inventory)
        gas   (first inv:get_list :gas)
        Δwear (. gases-list (gas:get_name))
        wear  (+ (gas:get_wear) Δwear)]
    (if (≥ wear 65535)
      (do (inv:set_stack :gas 1 {:name "default:empty_balloon"})
          false)
      (do (gas:set_wear wear)
          (inv:set_stack :gas 1 gas)
          true))))

(fn process-liquid-fuel [pos meta inv fuel burning-time elapsed]
  (let [wear (fuel:get_wear)
        Δwear (infix (elapsed / burning-time) * 65535)]
    (if (≥ (+ wear Δwear) 65535)
      (do (add_or_drop
            inv "output"
            {:name "default:bucket_empty"}
            (vector.add pos (vector.new 0 1 0)))
          (inv:set_list "fuel" [])
          false)
      (do (fuel:add_wear Δwear) (inv:set_stack "fuel" 1 fuel)
          (meta:set_float :cycle (infix (1 - wear / 65535) * burning-time))
          true))))

(fn process-solid-fuel [pos meta inv fuel burning-time elapsed]
  (let [cycle (+ (meta:get_float :cycle) elapsed)]
    (if (> cycle burning-time)
      (let [count (- (fuel:get_count) 1)]
        (fuel:set_count count)
        (inv:set_stack "fuel" 1 fuel)
        (if (= count 0)
            false
            (do (meta:set_float :cycle 0) true)))
      (do (meta:set_float :cycle cycle) true))))

(defun update_fuel [fuel_list]
  (fn [pos elapsed]
    (let [meta (minetest.get_meta pos)
          inv (meta:get_inventory)
          fuel (first inv:get_list "fuel")
          fuel-name (fuel:get_name)
          burning-time (. fuel_list fuel-name)
          handler (if (∈ fuel-name bucket.is_bucket)
                      process-liquid-fuel process-solid-fuel)]
      (handler pos meta inv fuel burning-time elapsed))))

(register_furnace
  {:name "gas"
   :description "Gas furnace"
   :lists {:gas 1 :fuel 1}
   :on_tick [(update_fuel fuel_list) update_gas]
   :is_furnace_ready furnace-ready?
   :additional_formspec
     (fn [meta]
       (.. "label[0,1.5;Gas]"
           "list[context;gas;0,2;1,1;]"
           "label[2,1.5;Fuel]"
           "list[context;fuel;2,2;1,1;]"))
   :textures
     {:inactive
        ["furnace_side.png" "furnace_side.png"
         "furnace_side.png" "furnace_side.png"
         "furnace_side.png" "furnace_gas_front.png"]
      :active
        ["furnace_side.png" "furnace_side.png"
         "furnace_side.png" "furnace_side.png"
         "furnace_side.png"
         {:image "furnace_gas_front_active.png"
          :backface_culling false
          :animation
            {:type     "vertical_frames"
             :aspect_w 16
             :aspect_h 16
             :length   1.5}}]}
   :groups {:cracky 2} :light_source 10
   :after_stop (fn [pos] (-> (minetest.get_meta pos) (: :set_float :cycle 0)))
   :crafts furnace_crafts})