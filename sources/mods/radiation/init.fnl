(require-macros :useful-macros)
(import :radiation "conf")

(local radiation-vect (vector.new 16 16 16))
(local radiation-effects-timeout 1)

(fn null [] { :alpha 0 :beta 0 :gamma 0 })

(fn get-activity [name]
  (let [cid (minetest.get_content_id name)]
    (or (. activity (if (≠ cid 127) cid name)) (null))))

(fn hypot-sqr [pos₁ pos₂]
  (+ (^ (- pos₁.x pos₂.x) 2)
     (^ (- pos₁.y pos₂.y) 2)
     (^ (- pos₁.z pos₂.z) 2)))

(fn alpha [A source pos]
  (* A (math.exp (- (hypot-sqr source pos)))))

(fn beta [A source pos]
  (let [dist² (hypot-sqr source pos)]
    (if (≠ dist² 0) (/ (* A (math.exp (- (math.sqrt dist²)))) dist²) A)))

(fn gamma [A source pos]
  (let [dist² (hypot-sqr source pos) ]
    (if (≠ dist² 0) (/ A dist²) A)))

(fn radiation-summary [A source pos]
  { :alpha (alpha A.alpha source pos)
    :beta  (beta  A.beta  source pos)
    :gamma (gamma A.gamma source pos) })

(fn add [A₁ A₂]
  { :alpha (+ A₁.alpha A₂.alpha)
    :beta  (+ A₁.beta  A₂.beta)
    :gamma (+ A₁.gamma A₂.gamma) })

(fn mult [k A]
  { :alpha  (* k A.alpha)
    :beta   (* k A.beta)
    :gamma  (* k A.gamma) })

(defun total [A]
  (+ A.alpha A.beta A.gamma))

(fn calculate-inventory-radiation [inv]
  (var radiation { :alpha 0 :beta 0 :gamma 0 })
  (each [listname lst (pairs (inv:get_lists))]
    (when (≠ listname "creative_inv")
      (each [_ stack (ipairs lst)]
        (let [A (get-activity (stack:get_name))
              stack-count (stack:get_count)]
          ;; no alpha here
          (tset radiation :beta (+ radiation.beta (* A.beta stack-count)))
          (tset radiation :gamma (+ radiation.gamma (* A.gamma stack-count)))))))
  radiation)

(defun calculate_radiation [vm pos]
  (var radiation (null))

  (local (minp maxp)
    (vm:read_from_map
      (vector.subtract pos radiation-vect)
      (vector.add pos radiation-vect)))

  (local area (VoxelArea:new { :MinEdge minp :MaxEdge maxp }))
  (local data (vm:get_data))

  (for [i 1 (length data)]
    (local cid (. data i)) (local A (. activity cid))
    (when A (let [source (vector.add (area:position i) (vector.new 0 (/ -1 2) 0))]
      (set radiation (add radiation (radiation-summary A pos source)))))
    (when (∈ cid has_inventory)
      (let [source (area:position i)
            inv (-> (minetest.get_meta source) (: :get_inventory))
            A (calculate-inventory-radiation inv) ]
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

(local maximum-dose 5)

(fn radiation-effects [player radiation]
  (local meta (player:get_meta))
  (var dose
    (+ (meta:get_float :received_dose)
       (* (/ radiation 3600) radiation-effects-timeout)))
  (when (< dose 0) (set dose 0))

  (meta:set_float :received_dose dose)
  (local dose-damage-limit (meta:get_float :dose_damage_limit))

  (when (> dose dose-damage-limit)
    (let [inv (player:get_inventory)
          drug-stack (. (inv:get_list :antiradiation) 1)
          drug-value (. antiradiation_drugs (drug-stack:get_name))]
      (if (∧ drug-value (≤ dose maximum-dose))
        (do
          (meta:set_float :dose_damage_limit (+ dose-damage-limit drug-value))
          (drug-stack:set_count (- (drug-stack:get_count) 1))
          (inv:set_stack :antiradiation 1 drug-stack))
        (player:set_hp (- (player:get_hp) (math.floor dose)))))))

(var radiation-timer 0)
(def-globalstep [Δt]
  (set radiation-timer (+ radiation-timer Δt))
  (let [vm (minetest.get_voxel_manip)]
    (each [_ player (ipairs (minetest.get_connected_players))]
      (let [radiation (total (calculate-player-radiation player vm))
            meta (player:get_meta)
            radiation′ (/ (+ (meta:get_float :radiation) radiation) 2)]
        (meta:set_float :radiation radiation′)
        (when (> radiation-timer radiation-effects-timeout)
          (radiation-effects player radiation))))

    (when (> radiation-timer radiation-effects-timeout)
      (set radiation-timer 0))))