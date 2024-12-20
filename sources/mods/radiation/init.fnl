(require-macros :useful-macros)
(require-macros :infix)

(import :radiation "conf")

(local radiation-vect (vector.new 10 10 10))
(local radiation-effects-timeout 1.0)

(local maximum-dose 20) ; Sv

(local cosmic-rays-power-per-meter 1.4e-6)

(fn cosmic-rays [height]
  (var res (null))
  (when (> height 0)
    (set res.X (* cosmic-rays-power-per-meter height)))
  res)

(fn get-radiant-power [name]
  (or (if (∈ name core.registered_nodes)
          (. radiant-power (core.get_content_id name))
          (. radiant-power name))
      (null)))

(fn hypot-sqr [pos₁ pos₂]
  (+ (^ (- pos₁.x pos₂.x) 2)
     (^ (- pos₁.y pos₂.y) 2)
     (^ (- pos₁.z pos₂.z) 2)))

(local max-attenuation 10)
(fn get-flux [P source pos area data]
  (let [dist² (hypot-sqr source pos)]
    (var attenuation 0)
    (each [thing (Raycast source pos false true) &until (≥ attenuation max-attenuation)]
      (when (∧ (= thing.type "node"))
        (let [cid (. data (area:indexp thing.under))
              att (or (. node-attenuation cid) 1.2e-3)]
          (set+ attenuation
            (* 0.5 (if (> (hypot-sqr source thing.under) 0.5)
                       att (/ att 10000)))))))

    (var res {})
    (each [kind handler (pairs ionizing)]
      (tset res kind (handler (. P kind) dist² attenuation)))
    res))

(local radiation-weighting-factor {:X 1 :α 20 :β 1 :γ 1})

(defun EquivalentDose [E]
  (var retval 0)
  (each [kind _ (pairs ionizing)]
    (set+ retval (* (. E kind) (. radiation-weighting-factor kind))))
  retval)

(defun Total [E]
  (var retval 0)
  (each [kind _ (pairs ionizing)]
    (set+ retval (. E kind)))
  retval)

(local inventory-shielding-factor {:α 0 :β 0.1 :γ 0.5 :X 0.5})

(fn calculate-inventory-flux [inv]
  (var flux (null))

  (each [listname lst (pairs (inv:get_lists))]
    (when (≠ listname "creative_inv")
      (each [_ stack (ipairs lst)]
        (let [P (get-radiant-power (stack:get_name))
              stack-count (stack:get_count)]
          (each [kind _ (pairs ionizing)]
            (tset flux kind (+ (. flux kind)
                               (* (. P kind) stack-count
                                  (. inventory-shielding-factor kind)))))))))
  flux)

(defun getVoxelArea [vm pos]
  (local (minp maxp)
    (vm:read_from_map
      (vector.subtract pos radiation-vect)
      (vector.add      pos radiation-vect)))

  (VoxelArea:new {:MinEdge minp :MaxEdge maxp}))

(defun radiantFluxAtPos [area data pos]
  (var flux (null))

  (for [i 1 (length data)]
    (local cid (. data i)) (local P (. radiant-power cid))
    (when P (let [source (area:position i)]
      (Add flux (get-flux P source pos area data) flux)
      (Add flux (get-flux P source (vector.add pos (vector.new 0 1 0)) area data) flux)))

    (when (∈ cid has-inventory)
      (let [source (area:position i)
            inv (-> (core.get_meta source) (: :get_inventory))
            P (calculate-inventory-flux inv)]
        (Add flux (get-flux P source pos area data) flux)
        (Add flux (get-flux P source (vector.add pos (vector.new 0 1 0)) area data) flux))))

  (Add flux (cosmic-rays pos.y) flux)
  flux)

(fn radiant-flux-at-player [vm player]
  (local pos (player:get_pos))
  (local objs (->> (vector.length radiation-vect)
                   (core.get_objects_inside_radius pos)))

  (local area (getVoxelArea vm pos))
  (local data (vm:get_data))

  (var flux (radiantFluxAtPos area data pos))

  (each [_ obj (pairs objs)]
    (let [name (player:get_player_name)
          entity (obj:get_luaentity)]
      (when (∧ entity (= entity.name "__builtin:item"))
        (let [stack (ItemStack entity.itemstring)
              P     (get-radiant-power (stack:get_name))]
          ;; TODO: remove code duplication
          (Add flux (Mult (stack:get_count) (get-flux P (obj:get_pos) pos area data)) flux)
          (Add flux (Mult (stack:get_count) (get-flux P (obj:get_pos) (vector.add pos (vector.new 0 1 0)) area data)) flux)))))

  ;; wielded item alpha
  (let [wielded (player:get_wielded_item)]
    (set+ flux.α (/ (* (. (get-radiant-power (wielded:get_name)) :α) (wielded:get_count)) 10))
    (Add flux (calculate-inventory-flux (player:get_inventory)) flux))

  flux)

(fn reset-tint [player] (tint player transparent))
(local effect-list
  {"blindness"
    {:prob      0.05
     :min-dose  3.5
     :priority  ["semiblindness"]
     :action (fn [player] (tint player {:r 0 :g 0 :b 0 :a 255}))
     :revert reset-tint}
   "semiblindness"
    {:prob      0.1
     :min-dose  3
     :conflicts ["blindness"]
     :action (fn [player] (tint player {:r 0 :g 0 :b 0 :a 240}))
     :revert reset-tint}
   "weakness"
    {:prob      0.1
     :min-dose  2.5
     :conflicts []
     :action (fn [player] (player:set_physics_override {"speed" 0.3}))
     :revert (fn [player] (player:set_physics_override {"speed" 1.0}))}})

(fn applied? [meta name]
  (> (meta:get_int name) 0))

(fn drop-effect [player meta]
  (fn [name] (let [effect (. effect-list name)
                   revert (. effect :revert)]
              (meta:set_int name 0) (revert player))))

(core.register_on_respawnplayer (fn [player]
  (foreach2 (drop-effect player (player:get_meta)) effect-list)))

(core.register_on_joinplayer (fn [player]
  (let [meta (player:get_meta)]
    (each [name effect (pairs effect-list)]
      (when (applied? meta name)
        ;; https://github.com/minetest/minetest/issues/9024
        ;; https://github.com/minetest/minetest/issues/2862
        (effect.action player))))))

(fn radiation-effects [player]
  (local meta (player:get_meta))
  (local dose (meta:get_float :received_dose))
  (local dose-damage-limit (meta:get_float :dose_damage_limit))

  ;; Consume anti-radiation drug
  (let [inv (player:get_inventory)
        drug-stack (. (inv:get_list :antiradiation) 1)
        drug-value (. antiradiation-drugs (drug-stack:get_name))]
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
          (meta:set_int effect-name 0) (effect.revert player))))))

(local special-inventory ["creative_inv" "oxygen"])

(fn drop-inventory [player]
  (let [inv (player:get_inventory)
        pos (player:get_pos)]
    (each [listname lst (pairs (inv:get_lists))]
      (when (¬ contains special-inventory listname)
        (each [_ stack (ipairs lst)]
          (core.add_item pos stack))
        (inv:set_list listname [])))))

(fn mean [A B] (/ (+ A B) 2))

(var radiation-timer 0)
(def-globalstep [Δt]
  (set radiation-timer (+ radiation-timer Δt))
  (let [vm (core.get_voxel_manip)]
    (each [_ player (ipairs (core.get_connected_players))]
      (let [meta (player:get_meta)
            m     75.0                               ; Player mass, kg
            flux  (radiant-flux-at-player vm player) ; Radiant flux, W
            E     (Mult Δt flux)                     ; Radiant energy, J
            D     (Div E m)                          ; Absorbed dose, Gy
            H     (EquivalentDose D)                 ; Equivalent dose, Sv
            H₀    (meta:get_float :received_dose)    ; Sv
            rate₀ (meta:get_float :radiation)        ; Gy/s
            rate  (/ (Total flux) m)                 ; Gy/s
            rate′ (mean rate₀ rate)]
        (meta:set_float :radiation rate′)
        (meta:set_float :received_dose (+ H₀ H))

        (when (> radiation-timer radiation-effects-timeout)
          (radiation-effects player))))

    (when (> radiation-timer radiation-effects-timeout)
      (set radiation-timer 0))))

(fn get-danger-texture [color]
  (string.format "radiation_danger.png^[multiply:%s"
    (core.rgba color.r color.g color.b)))

(local danger-texture "radiation_danger.png")
(core.register_node "radiation:danger"
  {:description "Radiation source"
   :tiles [(get-danger-texture {:r 255 :g 0 :b 0})]
   :groups {:cracky 1}})

(let [texture (get-danger-texture {:r 232 :g 191 :b 40})]
  (core.register_node "radiation:sign"
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

(core.register_chatcommand "reset-dose"
  {:description "Resets player received dose."
   :privs {:debug true}
   :func (fn [name]
           (let [player (core.get_player_by_name name)]
            (when player
              (let [meta (player:get_meta)]
                (meta:set_float :radiation 0)
                (meta:set_float :received_dose 0)))))})
