(require-macros :useful-macros)
(require-macros :infix)

(local cid minetest.get_content_id)

(defun Add [tbl₁ tbl₂ tbl₃]
  (var tbl (or tbl₃ {}))
  (each [k v (pairs tbl₁)]
    (tset tbl k (+ v (. tbl₂ k))))
  tbl)

(defun Mult [K tbl₁ tbl₂]
  (var tbl′ (or tbl₂ {}))
  (each [k v (pairs tbl₁)]
    (tset tbl′ k (* K v)))
  tbl′)

(defun Div [tbl₁ K tbl₂] (Mult (/ 1.0 K) tbl₁ tbl₂))

;;; First define some helpful types
;; radiant-power-table
(define-type radiant-power-table nope)
(fn radiant-power-table.update [self tbl]
  (each [name val (pairs tbl)]
    (when (¬ pcall (fn [] (tset self (cid name) val)))
      (tset self name val))))

(local π        math.pi)
(local Avogadro 6.022e+23)
(local year     (* 365 24 60 60))

(fn specific-activity [T½ M] (/ (* Avogadro (math.log 2)) (* T½ M)))

;; Handlers
(fn alpha [P dist² att] (/ (if (> dist² 0) (* P (/ 1.0 (* 4.0 π dist²))) P) (math.exp (* att 7e+3))))
(fn beta  [P dist² att] (/ (if (> dist² 0) (* P (/ 1.0 (* 4.0 π dist²))) P) (math.exp (* att 700))))
(fn rays  [P dist² att] (/ (if (> dist² 0) (* P (/ 1.0 (* 4.0 π dist²))) P) (math.exp (* att 180))))

(global ionizing {:α alpha :β beta :γ rays :X rays})

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
  {(cid "loria:ammonium_manganese_pyrophosphate") 03.00
   (cid "loria:chromia")                          05.22
   (cid "loria:chromium_fluoride")                03.80
   (cid "loria:cinnabar")                         08.10
   (cid "loria:cobalt_blue")                      03.65
   (cid "loria:copper_sulfate_pure")              03.60
   (cid "loria:copper_sulfate")                   02.29
   (cid "loria:copper_sulfate")                   02.29
   (cid "loria:lead_sulfate")                     06.29
   (cid "loria:mercury")                          13.50
   (cid "loria:mercury_oxide")                    11.14
   (cid "loria:nickel_nitrate")                   02.05
   (cid "loria:polluted_mercury_source")          13.50
   (cid "loria:polluted_mercury_flowing")         07.80
   (cid "loria:red_mercury_oxide")                11.14
   (cid "loria:sodium_peroxide")                  02.80
   (cid "loria:sulfur")                           02.00})

(local radiochem-table
;; Isotope  | Mass (Da) | Half-life (s)         | Decay energy (MeV)                                        |
  {"H"      {:M 001.008 :T½ math.huge                                                                       }
   "O"      {:M 015.999 :T½ math.huge                                                                       }
   "F"      {:M 018.999 :T½ math.huge                                                                       }
   "Cl-35"  {:M 034.969 :T½ math.huge                                                                       }
   "Cl-37"  {:M 036.966 :T½ math.huge                                                                       }
   "K-39"   {:M 038.964 :T½ math.huge                                                                       }
   "K-40"   {:M 039.964 :T½ (* 001.251e+9 year) :decay [{:ratio 0.8928 :α 0.000 :β 1.310 :γ 0.000 :X 0.000}
                                                        {:ratio 0.1072 :α 0.000 :β 0.000 :γ 1.505 :X 0.000}]}
   "K-41"   {:M 040.962 :T½ math.huge                                                                       }
   "Mn"     {:M 054.938 :T½ math.huge                                                                       }
   "I"      {:M 126.904 :T½ math.huge                                                                       }
   "Th-232" {:M 232.038 :T½ (* 014.000e+9 year) :decay [{:ratio 1.0000 :α 4.082 :β 0.000 :γ 0.000 :X 0.000}]}
   "Th-230" {:M 230.033 :T½ (* 075.400e+3 year) :decay [{:ratio 1.0000 :α 4.770 :β 0.000 :γ 0.000 :X 0.000}]}
   "Pu-241" {:M 241.057 :T½ (* 014.000e+0 year) :decay [{:ratio 1.0000 :α 0.000 :β 0.021 :γ 0.000 :X 0.000}]}
   "Pu-238" {:M 238.050 :T½ (* 087.700e+0 year) :decay [{:ratio 1.0000 :α 5.593 :β 0.000 :γ 0.000 :X 0.000}]}
   "U-234"  {:M 234.067 :T½ (* 246.000e+3 year) :decay [{:ratio 1.0000 :α 4.800 :β 0.000 :γ 0.000 :X 0.000}]}
   "U-235"  {:M 235.044 :T½ (* 703.800e+3 year) :decay [{:ratio 1.0000 :α 4.679 :β 0.000 :γ 0.000 :X 0.000}]}
   "U-238"  {:M 238.051 :T½ (* 004.468e+9 year) :decay [{:ratio 1.0000 :α 4.267 :β 0.000 :γ 0.000 :X 0.000}]}
   "Am-241" {:M 241.057 :T½ (* 432.200e+0 year) :decay [{:ratio 1.0000 :α 5.486 :β 0.000 :γ 0.060 :X 0.000}]}})

(local molecular-table
;; Molecule | Density (g/cm³) | Isotopes (relative amount)
  {"Th"     {:ρ 11.700        :iso {"Th-232" 0.99980 "Th-230" 0.00020                }}
   "ThI"    {:ρ 06.000        :iso {"Th-232" 0.99970 "Th-230" 0.00030 "I"     4.00000}}
   "ThO₂"   {:ρ 10.000        :iso {"Th-232" 0.99980 "Th-230" 0.00020 "O"     2.00000}}
   "U"      {:ρ 19.100        :iso {"U-234"  0.00005 "U-235"  0.00720 "U-238" 0.99275}}
   "UCl₄"   {:ρ 04.870        :iso {"U-234"  0.00005 "U-235"  0.00720 "U-238" 0.99275
                                    "Cl-35"  3.04000 "Cl-37"  0.96000                }}
   "Pu"     {:ρ 19.850        :iso {"Pu-238" 0.80000 "Pu-241" 0.20000                }}
   "PuF₃"   {:ρ 09.300        :iso {"Pu-238" 0.80000 "Pu-241" 0.20000 "F"     3.00000}}
   "PuF₄"   {:ρ 07.100        :iso {"Pu-238" 0.80000 "Pu-241" 0.20000 "F"     4.00000}}
   "PuO₂"   {:ρ 11.500        :iso {"Pu-238" 0.80000 "Pu-241" 0.20000 "O"     2.00000}}
   "AmF₃"   {:ρ 09.530        :iso {"Am-241" 1.00000 "F"      3.00000                }}
   "K"      {:ρ 00.890        :iso {"K-39"   0.92040 "K-40"   0.01230 "K-41"  0.06730}}
   "KMnO₄"  {:ρ 02.700        :iso {"K-39"   0.92040 "K-40"   0.01230 "K-41"  0.06730
                                    "Mn"     1.00000 "O"      4.00000}}
   "K₂MnO₄" {:ρ 02.780        :iso {"K-39"   1.84080 "K-40"   0.02460 "K-41"  0.13460
                                    "Mn"     1.00000 "O"      4.00000}}
   "KCl"    {:ρ 01.980        :iso {"K-39"   0.92040 "K-40"   0.01230 "K-41"  0.06730
                                    "Cl-35"  3.04000 "Cl-37"  0.96000}}
   "KOH"    {:ρ 02.120        :iso {"K-39"   0.92040 "K-40"   0.01230 "K-41"  0.06730
                                    "O"      1.00000 "H"      1.00000}}})

(local item-table
;; Item / node                            | Components (m³)
  {;; Thorium
   "loria:thorium"                        {"Th"     1.0000}
   "loria:thorium_ingot"                  {"Th"     0.1000}
   "electricity:thorium_wire"             {"Th"     0.0100}
   "loria:thorium_iodide"                 {"ThI"    1.0000}
   "loria:thorium_dioxide"                {"ThO₂"   1.0000}
   "loria:thorium_dioxide_brick"          {"ThO₂"   0.9800}
   "furnace:thorium"                      {"Th"     0.4000}
   "furnace:thorium_active"               {"Th"     0.4000}
   ;; Uranium
   "loria:uranium"                        {"U"      1.0000}
   "loria:uranium_ingot"                  {"U"      0.1000}
   "electricity:uranium_wire"             {"U"      0.0100}
   "loria:uranium_tetrachloride"          {"UCl₄"   1.0000}
   "loria:uranium_tetrachloride_brick"    {"UCl₄"   0.9800}
   ;; Plutonium
   "loria:plutonium"                      {"Pu"     1.0000}
   "loria:plutonium_ingot"                {"Pu"     0.1000}
   "electricity:plutonium_wire"           {"Pu"     0.0100}
   "loria:plutonium_trifluoride"          {"PuF₃"   1.0000}
   "loria:plutonium_tetrafluoride"        {"PuF₄"   1.0000}
   "loria:plutonium_dioxide"              {"PuO₂"   1.0000}
   "loria:plutonium_dioxide_brick"        {"PuO₂"   0.9800}
   ;; Americium
   "loria:americium_trifluoride"          {"AmF₃"   1.0000}
   ;; Potassium
   "loria:potassium"                      {"K"      1.0000}
   "loria:potassium_ingot"                {"K"      0.1000}
   "loria:potassium_chloride"             {"KCl"    1.0000}
   "loria:potassium_manganate"            {"K₂MnO₄" 1.0000}
   "loria:potassium_permanganate_source"  {"KMnO₄"  1.0000}
   "loria:potassium_permanganate_flowing" {"KMnO₄"  1.0000}
   "loria:bucket_potassium_permanganate"  {"KMnO₄"  1.0000}
   "loria:potassium_hydroxide_source"     {"KOH"    1.0000}
   "loria:potassium_hydroxide_flowing"    {"KOH"    1.0000}
   "loria:bucket_potassium_hydroxide"     {"KOH"    1.0000}
   ;; Polluted mercury
   "loria:polluted_mercury_source"        {"Th"     0.0800
                                           "ThI"    0.0300
                                           "ThO₂"   0.0200
                                           "PuF₄"   2.4e-6}
   "loria:polluted_mercury_flowing"       {"Th"     0.0800
                                           "ThI"    0.0300
                                           "ThO₂"   0.0200
                                           "PuF₄"   2.4e-6}
   "loria:bucket_polluted_mercury"        {"Th"     0.0400
                                           "ThI"    0.0150
                                           "ThO₂"   0.0100
                                           "PuF₄"   1.2e-6}
   ;; Pickaxes
   "loria:uranium_pickaxe"                {"U"      0.2000}
   "loria:thorium_pickaxe"                {"Th"     0.2000}
   "loria:plutonium_pickaxe"              {"Pu"     0.2000}
   "loria:potassium_pickaxe"              {"K"      0.2000}})

;;; Then set up configuration tables
(global radpower (radiant-power-table))

(on-mods-loaded
  (var inh (null))
  (each [name _ (pairs minetest.registered_items)]
    (tset radpower name inh))

  (each [isotope vals (pairs radiochem-table)]
    (when (∈ :decay vals)
      (let [a (specific-activity vals.T½ vals.M)]
        (var PWR (null)) ;; MeV/g

        (each [_ E (ipairs vals.decay)]
          (Add PWR (Mult (* a E.ratio) E) PWR))

        (tset vals :PWR (Mult 1.602e-13 PWR))))) ;; W/g

  (each [molecule vals (pairs molecular-table)]
    (var M 0.0) ;; Molecular mass (Da)
    (each [isotope ratio (pairs vals.iso)]
      (set+ M (* ratio (. radiochem-table isotope :M))))

    (var PWR (null))
    (each [isotope ratio (pairs vals.iso)]
      (when (∈ :PWR (. radiochem-table isotope))
        (let [m  (. radiochem-table isotope :M)
              Aᵣ (/ (* ratio m) M)]
          (Add PWR (Mult Aᵣ (. radiochem-table isotope :PWR)) PWR))))

    (tset vals :PWR PWR))

  (each [name vals (pairs item-table)]
    (var P (null)) ;; W

    (each [molecule V (pairs vals)]
      (let [ρ   (. molecular-table molecule :ρ)   ;; g/cm³
            PWR (. molecular-table molecule :PWR) ;; W/g
            m   (* ρ V 1e+6)]                     ;; g
        (Add P (Mult m PWR) P)))

    (tset vals :P P))

  ;; Set up radiant power of each item in W.
  ;; We consider that wires are 0.01 m³, ingots are 0.1 m³, pickaxes are 0.2 m³.
  ;; Compounds are scaled by the relative molar mass of radioactive element.
  (each [name vals (pairs item-table)]
    (radpower:update {name vals.P}))

  (radpower:update
    {;; Technic
     "furnace:refiner_active"            (α-β-γ 000.0e+00 000.0e+00 010.5e-04)
     ;; Organic
     "loria:periculum"                   (α-β-γ 000.0e+00 000.0e+00 003.5e-01)
     "loria:imitationis"                 (α-β-γ 000.0e+00 000.0e+00 003.5e-02)
     "loria:nihil"                       (α-β-γ 000.0e+00 000.0e+00 007.0e-03)
     "loria:lectica"                     (α-β-γ 000.0e+00 000.0e+00 004.9e-02)
     ;; Other
     "radiation:danger"                  (α-β-γ 052.5e+02 024.5e-03 003.0e+03)})

  (each [name params (pairs ores)]
    (when (∈ :radioactive params)
      (let [P₀ (. radpower (cid (.. "loria:" name)))
            P  (Mult params.ratio P₀)]
        (each [_ place (ipairs params.wherein)]
          (tset radpower (cid (.. "loria:" name "_" place)) P))))

    (each [_ place (ipairs params.wherein)]
      (tset node_attenuation (cid (.. "loria:" name "_" place))
        (. node_attenuation (cid (.. "loria:" place)))))))

(global antiradiation_drugs
  {"loria:manganese_oxide" 0.5})

(global has_inventory (menge))

(local emits-rays
  ["loria:lead_box" "loria:silicon_box"
   "furnace:gas" "furnace:refiner" "furnace:electric"
   "electricity:riteg"])
(on-mods-loaded (has_inventory:join-array (map cid emits-rays)))
