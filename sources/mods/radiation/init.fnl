(require-macros :useful-macros)
(require-macros :infix)

(import :radiation "conf")

(local radiation-vect (vector.new 16 16 16))
(local radiation-effects-timeout 1)

(local lethal-dose 1500) ; CU/h
(local maximum-dose 5)   ; CU

(fn get-activity [name]
  (or (if (∈ name minetest.registered_nodes)
          (. activity (minetest.get_content_id name))
          (. activity name))
      (null)))

(fn hypot-sqr [pos₁ pos₂]
  (+ (^ (- pos₁.x pos₂.x) 2)
     (^ (- pos₁.y pos₂.y) 2)
     (^ (- pos₁.z pos₂.z) 2)))

(fn alpha [A source pos]
  (infix A * (math.exp (− hypot-sqr source pos))))

(fn beta [A source pos]
  (let [dist² (hypot-sqr source pos)]
    (if (≠ dist² 0) (infix A * (math.exp (− math.sqrt dist²)) / dist²) A)))

(fn gamma [A source pos]
  (let [dist² (hypot-sqr source pos)]
    (if (≠ dist² 0) (/ A dist²) A)))

(fn radiation-summary [A source pos]
  {:alpha (alpha A.alpha source pos)
   :beta  (beta  A.beta  source pos)
   :gamma (gamma A.gamma source pos)})

(fn add [A₁ A₂]
  {:alpha (+ A₁.alpha A₂.alpha)
   :beta  (+ A₁.beta  A₂.beta)
   :gamma (+ A₁.gamma A₂.gamma)})

(fn mult [k A]
  {:alpha  (* k A.alpha)
   :beta   (* k A.beta)
   :gamma  (* k A.gamma)})

(defun total [A]
  (+ A.alpha A.beta A.gamma))

(fn calculate-inventory-radiation [inv]
  (var radiation {:alpha 0 :beta 0 :gamma 0})
  (each [listname lst (pairs (inv:get_lists))]
    (when (≠ listname "creative_inv")
      (each [_ stack (ipairs lst)]
        (let [A (get-activity (stack:get_name))
              stack-count (stack:get_count)]
          ;; no alpha here
          (tset radiation :beta  (+ radiation.beta  (* A.beta  stack-count)))
          (tset radiation :gamma (+ radiation.gamma (* A.gamma stack-count)))))))
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
    (when A (let [source (vector.add (area:position i) (vector.new 0 (/ -1 2) 0))]
      (set radiation (add radiation (radiation-summary A pos source)))))
    (when (∈ cid has_inventory)
      (let [source (area:position i)
            inv (-> (minetest.get_meta source) (: :get_inventory))
            A (calculate-inventory-radiation inv)]
        (set radiation (add radiation
          (radiation-summary A pos
            (vector.add source (vector.new 0 (/ -1 2) 0))))))))
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
                  (radiation-summary A pos (obj:get_pos)))))))))

  ;; wielded item alpha
  (let [wielded (player:get_wielded_item)]
    (tset radiation :alpha
      (+ radiation.alpha
        (* (. (get-activity (wielded:get_name)) :alpha)
           (wielded:get_count))))
    (set radiation (add radiation (calculate-inventory-radiation
                                    (player:get_inventory)))))
  radiation)

(fn reset-tint [player] (tint player transparent))
(local effect-list
  {"blindness"
    {:prob      0.05
     :min-dose  0.9
     :priority  ["semiblindness"]
     :action (fn [player] (tint player {:r 0 :g 0 :b 0 :a 255}))
     :revert reset-tint}
   "semiblindness"
    {:prob      0.1
     :min-dose  0.85
     :conflicts ["blindness"]
     :action (fn [player] (tint player {:r 0 :g 0 :b 0 :a 240}))
     :revert reset-tint}})

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

  ;; Damage after receiving a critical dose *for a long time*
  (when (> dose dose-damage-limit)
    (let [inv (player:get_inventory)
          drug-stack (. (inv:get_list :antiradiation) 1)
          drug-value (. antiradiation_drugs (drug-stack:get_name))]
      (if (∧ drug-value (≤ dose maximum-dose))
        (do (meta:set_float :dose_damage_limit (+ dose-damage-limit drug-value))
            (drug-stack:set_count (- (drug-stack:get_count) 1))
            (inv:set_stack :antiradiation 1 drug-stack))
        (player:set_hp (- (player:get_hp) (math.floor dose))))))

  ;; Other effects
  (let [meta (player:get_meta)]
    (each [effect-name effect (pairs effect-list)]
      (when (∧ (≥ dose effect.min-dose)
               (≤ (math.random) effect.prob))
        (let [conflicts (∨ effect.conflicts [])
              priority  (∨ effect.priority [])]
          (when (∧ (∀ x ∈ conflicts (¬ applied? meta x))
                   (¬ applied? meta effect-name))
            (foreach (drop-effect player meta) priority)
            (meta:set_int effect-name 1) (effect.action player)))))))

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
            radiation′ (infix (radiation₀ + radiation) / 2)]
        (meta:set_float :radiation radiation′)
        (when (> radiation-timer radiation-effects-timeout)
          ;; Lethal dose (immediate death)
          (when (> radiation lethal-dose)
            (drop-inventory player) (player:set_hp 0))
          ;; Other effects
          (radiation-effects player radiation))))

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