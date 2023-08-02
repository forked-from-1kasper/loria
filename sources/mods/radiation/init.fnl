(require-macros :useful-macros)
(require-macros :infix)

(import :radiation "conf")

(local radiation-vect (vector.new 16 16 16))
(local radiation-effects-timeout 1)

(local maximum-dose 20)   ; Gy

(local height-coeff (/ 5 10000))

(fn cosmic-rays [height]
  (var res (null))
  (when (> height 0)
    (set res.X-ray (* height-coeff height)))
  res)

(fn get-activity [name]
  (or (if (∈ name minetest.registered_nodes)
          (. activity (minetest.get_content_id name))
          (. activity name))
      (null)))

(fn hypot-sqr [pos₁ pos₂]
  (+ (^ (- pos₁.x pos₂.x) 2)
     (^ (- pos₁.y pos₂.y) 2)
     (^ (- pos₁.z pos₂.z) 2)))

(fn radiation-summary [A source pos vm]
  (let [dist² (hypot-sqr source pos)]
    (var attenuation 0)
    (if (> dist² 0.5)
    (each [thing (Raycast source pos false true)]
      (when (= thing.type "node")
        (let [node (vm:get_node_at thing.under)]
        (var node_att (or (. node_attenuation node.name) 1.2e-3))
          (set+ attenuation (* node_att 0.5))
        )
      )
    )
    (set attenuation 0.01))
    (var res {})
    (each [kind handler (pairs ionizing)]
      (tset res kind (handler (. A kind) dist² attenuation)))
    res))

(fn add [A₁ A₂]
  (var res {})
  (each [kind _ (pairs ionizing)]
    (tset res kind (+ (. A₁ kind) (. A₂ kind))))
  res)

(fn mult [k A]
  (var res {})
  (each [kind _ (pairs ionizing)]
    (tset res kind (* (. A kind) k)))
  res)

; Give equivalent radiation dose relative to gamma
(global ionizing_power
  {
   "X-ray" 1
   "alpha" 10e+3
   "beta" 100
   "gamma" 1
  }
)
(defun total [A]
  (var res 0)
  (each [kind _ (pairs ionizing)]
    (set+ res (* (. A kind) (. ionizing_power kind))))
  res)

(fn calculate-inventory-radiation [inv]
  (var radiation (null))
  (each [listname lst (pairs (inv:get_lists))]
    (when (≠ listname "creative_inv")
      (each [_ stack (ipairs lst)]
        (let [A (get-activity (stack:get_name))
              stack-count (stack:get_count)]
          ;; no alpha here
          (each [kind _ (pairs ionizing)]
            (if (= kind "beta")
              (tset radiation kind
                (+ (. radiation kind)
                   (/ (* (. A kind) stack-count) 10)))
              (when (= kind "gamma")
                (tset radiation kind
                  (+ (. radiation kind)
                     (/ (* (. A kind) stack-count) 50))))
            )
          )))))
  radiation)

(defun calculate_radiation [vm pos]
  (var radiation (null))

  (local (minp maxp)
    (vm:read_from_map
      (vector.subtract pos radiation-vect)
      (vector.add pos radiation-vect)))

  (local area (VoxelArea:new {:MinEdge minp :MaxEdge maxp}))
  (local data (vm:get_data))

  (for [i 1 (length data)]
    (local cid (. data i)) (local A (. activity cid))
    (when A (let [source (area:position i)]
      (set radiation (add radiation (radiation-summary A source pos vm)))
      (set radiation (add radiation (radiation-summary A source (vector.add pos (vector.new 0 1 0)) vm)))
    ))
    (when (∈ cid has_inventory)
      (let [source (area:position i)
            inv (-> (minetest.get_meta source) (: :get_inventory))
            A (calculate-inventory-radiation inv)]
        (set radiation (add radiation
          (radiation-summary A
            source
            pos vm
          )))
        (set radiation (add radiation
          (radiation-summary A
            source
            (vector.add pos (vector.new 0 1 0)) vm
          )))
      )))
  (set radiation (add (cosmic-rays pos.y) radiation))
  radiation)

(fn calculate-player-radiation [player vm]
  (local pos (player:get_pos))
  (local objs (->> (vector.length radiation-vect)
                   (minetest.get_objects_inside_radius pos)))
  (var radiation (calculate_radiation vm pos))

  (each [_ obj (pairs objs)]
    (let [name (player:get_player_name)
          entity (obj:get_luaentity)]
      (when (∧ entity (= entity.name "__builtin:item"))
        (let [stack (ItemStack entity.itemstring)
              A (get-activity (stack:get_name))]
          (set radiation (add
            radiation
            (mult (stack:get_count)
                  (radiation-summary A (obj:get_pos) pos vm))))
          (set radiation (add
            radiation
            (mult (stack:get_count)
                  (radiation-summary A (obj:get_pos) (vector.add pos (vector.new 0 1 0)) vm))))
        ))))

  ;; wielded item alpha
  (let [wielded (player:get_wielded_item)]
    (tset radiation :alpha
      (+ radiation.alpha
        (*
          (/ (. (get-activity (wielded:get_name)) :alpha)
            (wielded:get_count))
          10)
      ))
    (set radiation (add radiation (calculate-inventory-radiation
                                    (player:get_inventory)))))
  radiation)

(fn reset-tint [player] (tint player transparent))
(local effect-list
  {"blindness"
    {:prob      0.05
     :min-dose  15
     :priority  ["semiblindness"]
     :action (fn [player] (tint player {:r 0 :g 0 :b 0 :a 255}))
     :revert reset-tint}
   "semiblindness"
    {:prob      0.1
     :min-dose  8
     :conflicts ["blindness"]
     :action (fn [player] (tint player {:r 0 :g 0 :b 0 :a 240}))
     :revert reset-tint}
   "weakness"
    {:prob      0.1
     :min-dose  3
     :conflicts []
     :action (fn [player] (player:set_physics_override {"speed" 0.3}))
     :revert (fn [player] (player:set_physics_override {"speed" 1}))}})

(fn applied? [meta name]
  (> (meta:get_int name) 0))

(fn drop-effect [player meta]
  (fn [name] (let [effect (. effect-list name)
                   revert (. effect :revert)]
              (meta:set_int name 0) (revert player))))

(minetest.register_on_respawnplayer (fn [player]
  (foreach2 (drop-effect player (player:get_meta)) effect-list)))

(minetest.register_on_joinplayer (fn [player]
  (let [meta (player:get_meta)]
    (each [name effect (pairs effect-list)]
      (when (applied? meta name)
        ;; https://github.com/minetest/minetest/issues/9024
        ;; https://github.com/minetest/minetest/issues/2862
        (effect.action player))))))

(fn radiation-effects [player radiation]
  (local meta (player:get_meta))
  (local dose₀ (meta:get_float :received_dose))
  (var dose (infix dose₀ + radiation-effects-timeout * radiation / 3600))
  (when (< dose 0) (set dose 0))

  (meta:set_float :received_dose dose)
  (local dose-damage-limit (meta:get_float :dose_damage_limit))

  ;; Consume anti-radiation drug
  (let [inv (player:get_inventory)
        drug-stack (. (inv:get_list :antiradiation) 1)
        drug-value (. antiradiation_drugs (drug-stack:get_name))]
    (when (∧ drug-value (≤ drug-value dose))
      (do (meta:set_float :received_dose (- dose drug-value))
        (drug-stack:set_count (- (drug-stack:get_count) 1))
        (inv:set_stack :antiradiation 1 drug-stack))))

  ;; Damage after receiving a critical dose *for a long time*
  (when (> dose dose-damage-limit)
    (player:set_hp (- (player:get_hp) (math.floor (/ dose 4)))))

  ;; Other effects
  (let [meta (player:get_meta)]
    (each [effect-name effect (pairs effect-list)]
      (if (≥ dose effect.min-dose)
        (when (≤ (math.random) effect.prob)
          (let [conflicts (∨ effect.conflicts [])
                priority  (∨ effect.priority [])]
            (when (∧ (∀ x ∈ conflicts (¬ applied? meta x))
                     (¬ applied? meta effect-name))
              (foreach (drop-effect player meta) priority)
              (meta:set_int effect-name 1) (effect.action player))))
        (when (≤ (math.random) (/ effect.prob 10))
          (meta:set_int effect-name 0) (effect.revert player)
)))))

(local special-inventory ["creative_inv" "oxygen"])

(fn drop-inventory [player]
  (let [inv (player:get_inventory)
        pos (player:get_pos)]
    (each [listname lst (pairs (inv:get_lists))]
      (when (¬ contains special-inventory listname)
        (each [_ stack (ipairs lst)]
          (minetest.add_item pos stack))
        (inv:set_list listname [])))))

(var radiation-timer 0)
(def-globalstep [Δt]
  (set radiation-timer (+ radiation-timer Δt))
  (let [vm (minetest.get_voxel_manip)]
    (each [_ player (ipairs (minetest.get_connected_players))]
      (let [meta (player:get_meta)
            radiation₀ (meta:get_float :radiation)
            radiation  (total (calculate-player-radiation player vm))
            ;; Quick and dirty conversion from Bq to Gy/h (activity to dose/time)
            ;; Good enough approximation for for X-rays, should be reasonable for others
            radiation_Gyh (math.min (* radiation 7e-17 3600) 1000)
            radiation′ (infix (radiation₀ + radiation_Gyh) / 2)]
        (meta:set_float :radiation radiation′)
        (when (> radiation-timer radiation-effects-timeout)
          ;; Other effects
          (radiation-effects player radiation_Gyh))))

    (when (> radiation-timer radiation-effects-timeout)
      (set radiation-timer 0))))

(fn get-danger-texture [color]
  (string.format "radiation_danger.png^[multiply:%s"
    (minetest.rgba color.r color.g color.b)))

(local danger-texture "radiation_danger.png")
(minetest.register_node "radiation:danger"
  {:description "Radiation source"
   :tiles [(get-danger-texture {:r 255 :g 0 :b 0})]
   :groups {:cracky 1}})

(let [texture (get-danger-texture {:r 232 :g 191 :b 40})]
  (minetest.register_node "radiation:sign"
    {:description "Radiation hazard warning sign"
     :drawtype "nodebox" :tiles [texture]
     :groups {:dig_immediate 3} :walkable false
     :paramtype "light" :paramtype2 "wallmounted"
     :sunlight_propagates true :is_ground_content false
     :inventory_image texture :wield_image texture
     ;; From MTG
     :node_box
       {:type "wallmounted"
        :wall_top    [-0.5000  0.4375 -0.5000  0.5000  0.5000 0.5000]
        :wall_bottom [-0.5000 -0.5000 -0.5000  0.5000 -0.4375 0.5000]
        :wall_side   [-0.5000 -0.5000 -0.5000 -0.4375  0.5000 0.5000]}}))
