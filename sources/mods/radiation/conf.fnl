(require-macros :useful-macros)

(local cid minetest.get_content_id)

;;; First define some helpful types
;; activity-table
(define-type activity-table nope)
(fn activity-table.update [self tbl]
  (each [name val (pairs tbl)]
    (if (pcall (fn [] (tset self (cid name) val)))
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
     "default:thorium"           (α-β-γ 16 5 0)
     "default:thorium_ingot"     (α-β-γ 8  3 0)
     "electricity:thorium_cable" (α-β-γ 6  2 0)
     "default:thorium_iodide"    (α-β-γ 12 4 0)
     ;; Uranium
     "default:uranium"                     (α-β-γ 5 3   0)
     "default:uranium_ingot"               (α-β-γ 3 1   0)
     "electricity:uranium_cable"           (α-β-γ 2 0.6 0)
     "default:uranium_tetrachloride"       (α-β-γ 3 1   0)
     "default:uranium_tetrachloride_brick" (α-β-γ 2 1   0)
     ;; Plutonium
     "default:plutonium"               (α-β-γ 20 0 0)
     "default:plutonium_ingot"         (α-β-γ 5  0 0)
     "electricity:plutonium_cable"     (α-β-γ 7  0 0)
     "default:plutonium_trifluoride"   (α-β-γ 20 0 0)
     "default:plutonium_tetrafluoride" (α-β-γ 16 0 0)
     "default:plutonium_dioxide"       (α-β-γ 40 0 0)
     "default:plutonium_dioxide_brick" (α-β-γ 26 0 0)
     ;; Americium
     "default:americium_trifluoride" (α-β-γ 5 0 7)
     ;; Polluted mercury
     "default:bucket_polluted_mercury"  (α-β-γ 5 2.3 0)
     "default:polluted_mercury_source"  (α-β-γ 5 2.3 0)
     "default:polluted_mercury_flowing" (α-β-γ 5 2.3 0)
     ;; Technic
     "furnace:refiner_active" (α-β-γ 0 0 0.3)
     ;; Organic
     "default:periculum"   (α-β-γ 0 0 0.5)
     "default:imitationis" (α-β-γ 0 0 0.05)
     "default:nihil"       (α-β-γ 0 0 0.01)
     "default:lectica"     (α-β-γ 0 0 0.07)})

  (each [name params (pairs ores)]
    (when (∈ :radioactive params)
      (let [A₀ (. activity (cid (.. "default:" name)))
            A  (α-β-γ (/ A₀.alpha 5) (/ A₀.beta 3) (/ A₀.gamma 2))]
        (each [_ place (ipairs params.wherein)]
          (tset activity (cid (.. "default:" name "_" place)) A))))))

(global antiradiation_drugs 
  {"default:manganese_oxide" 0.5})

(global has_inventory (menge))

(local emits-rays
  ["default:lead_box" "default:silicon_box"
   "furnace:gas" "furnace:refiner" "furnace:electric"
   "electricity:riteg"])
(on-mods-loaded (has_inventory:join-array (map cid emits-rays)))