(require-macros :useful-macros)
(require-macros :infix)

(local cid minetest.get_content_id)

;;; First define some helpful types
;; activity-table
(define-type activity-table nope)
(fn activity-table.update [self tbl]
  (each [name val (pairs tbl)]
    (when (¬ pcall (fn [] (tset self (cid name) val)))
      (tset self name val))))

;; Handlers
(fn alpha [A dist² att] (/ (if (≠ dist² 0) (/ A dist²) A) (math.exp (* att 7e+3))))

(fn beta [A dist² att] (/ (if (≠ dist² 0) (/ A dist²) A) (math.exp (* att 700))))

(fn rays [A dist² att] (/ (if (≠ dist² 0) (/ A dist²) A) (math.exp (* att 180))))

(global ionizing {:alpha alpha :beta beta :gamma rays :X-ray rays})

;; Default radiation
(defun null []
  (var res {})
  (each [kind _ (pairs ionizing)]
    (tset res kind 0))
  res)

;; menge (set)
(define-type menge nope)
(fn menge.add [self name]
  (tset self name true))

(fn menge.join-array [self arr]
  (each [_ val (ipairs arr)]
    (tset self val true)))

;; Attenuation relative to water/live tissue
(global node_attenuation
  {
   "loria:ammonium_manganese_pyrophosphate" 3
   "loria:chromia" 5.22
   "loria:chromium_fluoride" 3.8
   "loria:cinnabar" 8.10
   "loria:cobalt_blue" 3.65
   "loria:copper_sulfate_pure" 3.60
   "loria:copper_sulfate" 2.29
   "loria:copper_sulfate" 2.29
   "loria:lead_sulfate" 6.29
   "loria:mercury" 13.5
   "loria:mercury_oxide" 11.14
   "loria:nickel_nitrate" 2.05
   "loria:polluted_mercury_source" 13.5
   "loria:polluted_mercury_flowing" 7.8
   "loria:red_mercury_oxide" 11.14
   "loria:sodium_peroxide" 2.80
   "loria:sulfur" 2
  }
)

;;; Then set up configuration tables
(global activity (activity-table))

(on-mods-loaded
  (var inh (null))
  (each [name _ (pairs minetest.registered_items)]
    (tset activity name inh))

  ;; Specific activity of each item in Bq
  ;; We consider that wires are 0.01 m³, ingots are 0.1 m³, pickaxes are 0.2 m³
  ;; Compounds are scaled by the relative molar mass of radioactive element
  (activity:update
    {;; Thorium
     "loria:thorium"               (α-β-γ 13e+9   0.0 0.0)
     "loria:thorium_ingot"         (α-β-γ 4.76e+9 0.0 0.0)
     "electricity:thorium_wire"    (α-β-γ 480e+6  0.0 0.0)
     "loria:thorium_iodide"        (α-β-γ 1.46e+9 0.0 0.0)
     "loria:thorium_dioxide"       (α-β-γ 40e+9   0.0 0.0)
     "loria:thorium_dioxide_brick" (α-β-γ 40e+9   0.0 0.0)
     "furnace:thorium"             (α-β-γ 13e+9   0.0 0.0)
     "furnace:thorium_active"      (α-β-γ 13e+9   0.0 0.0)
     ;; Uranium
     "loria:uranium"                     (α-β-γ 250e+9  0.0 0.0)
     "loria:uranium_ingot"               (α-β-γ 25e+9   0.0 0.0)
     "electricity:uranium_wire"          (α-β-γ 2.54e+9 0.0 0.0)
     "loria:uranium_tetrachloride"       (α-β-γ 160e+9  0.0 0.0)
     "loria:uranium_tetrachloride_brick" (α-β-γ 160e+9  0.0 0.0)
     ;; Plutonium
     "loria:plutonium"               (α-β-γ 0.0 774e+18 0.0)
     "loria:plutonium_ingot"         (α-β-γ 0.0 77e+18  0.0)
     "electricity:plutonium_wire"    (α-β-γ 0.0 7.7e+18 0.0)
     "loria:plutonium_trifluoride"   (α-β-γ 0.0 615e+18 0.0)
     "loria:plutonium_tetrafluoride" (α-β-γ 0.0 575e+18 0.0)
     "loria:plutonium_dioxide"       (α-β-γ 0.0 675e+18 0.0)
     "loria:plutonium_dioxide_brick" (α-β-γ 0.0 635e+18 0.0)
     ;; Americium
     "loria:americium_trifluoride" (α-β-γ 960e+15 0.0 960e+15)
     ;; Polluted mercury
     "loria:bucket_polluted_mercury"  (α-β-γ 1e+9 20e+12 25e+12)
     "loria:polluted_mercury_source"  (α-β-γ 2e+9 30e+12 50e+12)
     "loria:polluted_mercury_flowing" (α-β-γ 2e+9 30e+12 50e+12)
     ;; Technic
     "furnace:refiner_active" (α-β-γ 0.0 0.0 15e+12)
     ;; Organic
     "loria:periculum"   (α-β-γ 0.0 0.0 50e+12)
     "loria:imitationis" (α-β-γ 0.0 0.0 5e+12)
     "loria:nihil"       (α-β-γ 0.0 0.0 1e+12)
     "loria:lectica"     (α-β-γ 0.0 0.0 7e+12)
     ;; Pickaxes
     "loria:uranium_pickaxe"   (α-β-γ 50e+9 0.0 0.0)
     "loria:thorium_pickaxe"   (α-β-γ 9.52e+9 0.0 0.0)
     "loria:plutonium_pickaxe" (α-β-γ 0.0 154e+18 0.0)
     ;; Other
     "radiation:danger" (α-β-γ 7.5e+12 350e+12 7.5e+12)})

  (each [name params (pairs ores)]
    (when (∈ :radioactive params)
      (let [A₀ (. activity (cid (.. "loria:" name)))
            A  (α-β-γ (/ A₀.alpha 5) (/ A₀.beta 3) (/ A₀.gamma 2))]
        (each [_ place (ipairs params.wherein)]
          (tset activity (cid (.. "loria:" name "_" place)) A))))
    (each [_ place (ipairs params.wherein)]
        (tset node_attenuation (cid (.. "loria:" name "_" place)) (cid (.. "loria:" place)))
    )
  )
)

(global antiradiation_drugs
  {"loria:manganese_oxide" 0.5})

(global has_inventory (menge))

(local emits-rays
  ["loria:lead_box" "loria:silicon_box"
   "furnace:gas" "furnace:refiner" "furnace:electric"
   "electricity:riteg"])
(on-mods-loaded (has_inventory:join-array (map cid emits-rays)))
