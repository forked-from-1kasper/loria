(require-macros :useful-macros)

(local cid minetest.get_content_id)

;;; First define some helpful types
;; activity-table
(define-type activity-table nope)
(fn activity-table.update [self tbl]
  (each [name val (pairs tbl)]
    (when (¬ pcall (fn [] (tset self (cid name) val)))
      (tset self name val))))

;; Default radiation
(defun null [] {:alpha 0 :beta 0 :gamma 0})

;; menge (set)
(define-type menge nope)
(fn menge.add [self name]
  (tset self name true))

(fn menge.join-array [self arr]
  (each [_ val (ipairs arr)]
    (tset self val true)))

;;; Then set up configuration tables
(global activity (activity-table))

(on-mods-loaded
  (var inh (null))
  (each [name _ (pairs minetest.registered_items)]
    (tset activity name inh))

  (activity:update
    {;; Thorium
     "loria:thorium"               (α-β-γ 16 5   0)
     "loria:thorium_ingot"         (α-β-γ 8  3   0)
     "electricity:thorium_wire"    (α-β-γ 6  2   0)
     "loria:thorium_iodide"        (α-β-γ 12 4   0)
     "loria:thorium_dioxide"       (α-β-γ 14 4.5 0)
     "loria:thorium_dioxide_brick" (α-β-γ 10 3   0)
     "furnace:thorium"             (α-β-γ 13 4   0)
     "furnace:thorium_active"      (α-β-γ 13 4   0)
     ;; Uranium
     "loria:uranium"                     (α-β-γ 5 3   0)
     "loria:uranium_ingot"               (α-β-γ 3 1   0)
     "electricity:uranium_wire"          (α-β-γ 2 0.6 0)
     "loria:uranium_tetrachloride"       (α-β-γ 3 1   0)
     "loria:uranium_tetrachloride_brick" (α-β-γ 2 1   0)
     ;; Plutonium
     "loria:plutonium"               (α-β-γ 20 0 0)
     "loria:plutonium_ingot"         (α-β-γ 5  0 0)
     "electricity:plutonium_wire"    (α-β-γ 7  0 0)
     "loria:plutonium_trifluoride"   (α-β-γ 20 0 0)
     "loria:plutonium_tetrafluoride" (α-β-γ 16 0 0)
     "loria:plutonium_dioxide"       (α-β-γ 40 0 0)
     "loria:plutonium_dioxide_brick" (α-β-γ 26 0 0)
     ;; Americium
     "loria:americium_trifluoride" (α-β-γ 5 0 7)
     ;; Polluted mercury
     "loria:bucket_polluted_mercury"  (α-β-γ 5 2.3 0)
     "loria:polluted_mercury_source"  (α-β-γ 5 2.3 0)
     "loria:polluted_mercury_flowing" (α-β-γ 5 2.3 0)
     ;; Technic
     "furnace:refiner_active" (α-β-γ 0 0 0.3)
     ;; Organic
     "loria:periculum"   (α-β-γ 0 0 0.5)
     "loria:imitationis" (α-β-γ 0 0 0.05)
     "loria:nihil"       (α-β-γ 0 0 0.01)
     "loria:lectica"     (α-β-γ 0 0 0.07)
     ;; Pickaxes
     "loria:uranium_pickaxe"   (α-β-γ 3 2 0)
     "loria:thorium_pickaxe"   (α-β-γ 5 2 0)
     "loria:plutonium_pickaxe" (α-β-γ 8 0 0)
     ;; Other
     "radiation:danger" (α-β-γ 300 150 50)})

  (each [name params (pairs ores)]
    (when (∈ :radioactive params)
      (let [A₀ (. activity (cid (.. "loria:" name)))
            A  (α-β-γ (/ A₀.alpha 5) (/ A₀.beta 3) (/ A₀.gamma 2))]
        (each [_ place (ipairs params.wherein)]
          (tset activity (cid (.. "loria:" name "_" place)) A))))))

(global antiradiation_drugs 
  {"loria:manganese_oxide" 0.5})

(global has_inventory (menge))

(local emits-rays
  ["loria:lead_box" "loria:silicon_box"
   "furnace:gas" "furnace:refiner" "furnace:electric"
   "electricity:riteg"])
(on-mods-loaded (has_inventory:join-array (map cid emits-rays)))