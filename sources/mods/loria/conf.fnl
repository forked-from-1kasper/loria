(global liquids
  {"potassium_hydroxide"
   {:liquid_viscosity 1
    :damage 3
    :post_effect_color {:a 30 :r 255 :g 255 :b 255}
    :alpha 50
    :texture "loria_liquid.png"
    :animated_texture "loria_liquid_source_animated.png"
    :animated_flowing_texture "loria_liquid_flowing_animated.png"
    :bucket_image "bucket_potassium_hydroxide.png"
    :bucket_description "Potassium hydroxide (KOH)"}
   "trisilane"
   {:liquid_viscosity 1
    :post_effect_color {:a 70 :r 255 :g 255 :b 255}
    :alpha 70
    :texture "loria_liquid.png"
    :animated_texture "loria_liquid_source_animated.png"
    :animated_flowing_texture "loria_liquid_flowing_animated.png"
    :is_fuel true
    :bucket_image "bucket_trisilane.png"
    :bucket_description "Trisilane (Si3H8)"}
   "hydrochloric_acid"
   {:liquid_viscosity 1
    :post_effect_color {:a 30 :r 255 :g 255 :b 255}
    :damage 10
    :alpha 30
    :texture "loria_liquid.png"
    :animated_texture "loria_liquid_source_animated.png"
    :animated_flowing_texture "loria_liquid_flowing_animated.png"
    :bucket_image "bucket_hydrochloric_acid.png"
    :bucket_description "Hydrochloric acid (HCl)"}
   "sulfur_trioxide"
   {:liquid_viscosity 1
    :post_effect_color {:a 30 :r 255 :g 255 :b 255}
    :alpha 100
    :damage 5
    :texture "loria_liquid.png"
    :animated_texture "loria_liquid_source_animated.png"
    :animated_flowing_texture "loria_liquid_flowing_animated.png"
    :bucket_image "bucket_sulfur_trioxide.png"
    :bucket_description "Sulfur trioxide (SO3)"}
   "water"
   {:liquid_viscosity 2
    :post_effect_color {:a 103 :r 30 :g 60 :b 90}
    :alpha 160
    :texture "loria_water.png"
    :animated_texture "loria_water_source_animated.png"
    :animated_flowing_texture "loria_water_flowing_animated.png"
    :bucket_image "bucket_water.png"
    :bucket_description "Water (H2O)"}
   "mercury"
   {:damage_per_second 2
    :liquid_viscosity 7
    :post_effect_color {:a 252 :r 150 :g 150 :b 150}
    :alpha 255
    :texture "loria_mercury.png"
    :animated_texture "loria_mercury_animated.png"
    :animated_flowing_texture "loria_mercury_animated.png"
    :bucket_image "bucket_mercury.png"
    :bucket_description "Mercury (Hg)"}
   "polluted_mercury"
   {:damage_per_second 3
    :liquid_viscosity 7
    :post_effect_color {:a 252 :r 150 :g 150 :b 150}
    :alpha 255
    :texture "loria_mercury.png"
    :animated_texture "loria_mercury_animated.png"
    :animated_flowing_texture "loria_mercury_animated.png"
    :bucket_image "bucket_mercury.png"
    :bucket_description "Polluted (U, Th) mercury"}
   "potassium_permanganate"
   {:liquid_viscosity 1
    :post_effect_color {:a 100 :r 160 :g 0 :b 130}
    :alpha 160
    :texture "loria_potassium_permanganate.png"
    :animated_texture "loria_potassium_permanganate_animated.png"
    :animated_flowing_texture "loria_potassium_permanganate_animated.png"
    :bucket_image "bucket_potassium_permanganate.png"
    :bucket_description "Potassium permanganate (KMnO4)"}
   "lucidum"
   {:liquid_viscosity 3
    :post_effect_color {:a 150 :r 0 :g 128 :b 255}
    :alpha 150
    :light_source 13
    :texture "loria_liquid.png^[colorize:#0080ff"
    :animated_texture "loria_liquid_source_animated.png^[colorize:#0080ff"
    :animated_flowing_texture "loria_liquid_flowing_animated.png^[colorize:#0080ff"
    :bucket_image "bucket_lucidum.png"
    :bucket_description "Lucidum"}})

(global ores {
    "aluminium"
    {:formula "Al" :has_ingot true
     :wherein ["cobalt_blue" "cinnabar" "chromia"]}
    "potassium"
    {:formula "K" :has_ingot true
     :wherein ["cobalt_blue" "cinnabar" "chromia" "chromium_fluoride"]}
    "zinc"
    {:formula "Zn" :has_ingot true
     :wherein ["cobalt_blue" "cinnabar"]}
    "calcium"
    {:formula "Ca" :has_ingot true
     :y_max -700 :y_min -1200
     :wherein ["chromium_fluoride"]}
    "copper"
    {:formula "Cu" :has_ingot true
     :wherein ["cobalt_blue" "cinnabar"]}
    "wolfram"
    {:formula "W" :has_ingot true
     :y_max -300 :y_min -1500
     :wherein ["cobalt_blue" "cinnabar"]}
    "magnesium"
    {:formula "Mg" :has_ingot true
     :y_max -600 :y_min -900
     :wherein ["cobalt_blue" "cinnabar" "chromia"]}
    "molybdenum"
    {:formula "Mo" :has_ingot true
     :y_max -500 :y_min -800
     :wherein ["cobalt_blue" "cinnabar"]}
    "cuprous_oxide"
    {:formula "Cu2O" :has_ingot false
     :wherein ["cobalt_blue" "chromia"]
     :y_min -70 :y_max 0}
    "platinum"
    {:formula "Pt" :has_ingot true
     :wherein ["cobalt_blue" "cinnabar"]
     :y_min -300 :y_max -150}
    "uranium_tetrachloride" ; 234
    {:formula "UCl4" :has_ingot false
     :wherein ["cobalt_blue" "cinnabar" "chromium_fluoride" "chromia"]
     :radioactive true}
    "thorium_iodide" ; 232
    {:formula "ThI4" :has_ingot false
     :wherein ["cobalt_blue" "cinnabar" "chromium_fluoride" "chromia"]
     :radioactive true}
    "plutonium_trifluoride" ; 238
    {:formula "PuF3" :has_ingot false
     :wherein ["cobalt_blue" "cinnabar" "chromium_fluoride"]
     :radioactive true}
    "americium_trifluoride" ; 243
    {:formula "AmF3" :has_ingot false
     :y_min -243 :light_source 10
     :wherein ["cobalt_blue" "cinnabar" "chromium_fluoride"]
     :radioactive true}
    "magnetite"
    {:formula "FeO * Fe2O3" :has_ingot false
     :y_max -200 :y_min -500
     :wherein ["cobalt_blue" "cinnabar" "chromium_fluoride"]}})

(global grasses
  {"rami"
    {:max_height 4
     :place_on "loria:ammonium_manganese_pyrophosphate"
     :biomes "loria:purple_swamp"}
    "spears"
    {:max_height 4
     :place_on "loria:ammonium_manganese_pyrophosphate"
     :biomes "loria:purple_swamp"}
    "avarum"
    {:max_height 4
     :place_on "loria:ammonium_manganese_pyrophosphate"
     :biomes "loria:purple_swamp"}
    "cruento"
    {:max_height 6 :fill_ratio 0.001
     :place_on "loria:ammonium_manganese_pyrophosphate"
     :biomes "loria:purple_swamp"}
    "veteris"
    {:max_height 8
     :place_on "loria:sodium_peroxide"
     :biomes "loria:acidic_landscapes"}
    "lectica"
    {:max_height 5
     :place_on "loria:sodium_peroxide"
     :biomes "loria:acidic_landscapes"}
    "truncus"
    {:variants ["hyacinthum" "viridi" "purpura"]
     :max_height 7
     :place_on "loria:copper_sulfate"
     :biomes "loria:azure"}})

(global giant_mushrooms ["viridi_petasum" "colossus" "column"
                         "turris" "rete" "timor"])

;; Timor configuration
(global timor {})
(set timor.body-names ["light green" "blue" "red" "green" "purple"])
(set timor.colours (length timor.body-names))

(set timor.body-nodes (map (fn [idx] (.. "loria:timor_body_" idx))
                           (range timor.colours)))

(global cables
  [{:name "copper"    :resis 0.0225}
   {:name "aluminium" :resis 0.036 }
   {:name "wolfram"   :resis 0.055 }
   {:name "platinum"  :resis 0.098 }
   {:name "calcium"   :resis 0.046 }
   {:name "uranium"   :resis 0.295 }
   {:name "thorium"   :resis 0.1862}
   {:name "plutonium" :resis 150   }])

(global brickable
  {"loria:cinnabar"                         {:crumbly true }
   "loria:plutonium_dioxide"                {:crumbly false}
   "loria:thorium_dioxide"                  {:crumbly true }
   "loria:uranium_tetrachloride"            {:crumbly true }
   "loria:ammonium_manganese_pyrophosphate" {:crumbly true }
   "loria:mercury_oxide"                    {:crumbly true }
   "loria:red_mercury_oxide"                {:crumbly true }
   "loria:lead_sulfate"                     {:crumbly true }})

(global small_mushrooms
  {"pusilli"
   {:damage 5
    :place_on
      ["loria:cinnabar"
       "loria:red_mercury_oxide"
       "loria:mercury_oxide"]
    :optimal_light 11
    :fill_ratio 0.01
    :biomes "loria:redland"
    :optimal_radiation 5
    :max_radiation 10}
   "deus"
   {:damage 20
    :y_max 0
    :y_min -31000
    :features {:light_source 6}
    :place_on "loria:cobalt_blue"
    :fill_ratio 0.1
    :biomes "loria:azure_bottom"}
   "vult"
   {:damage 10
    :y_max 0
    :y_min -31000
    :features {:light_source 6}
    :place_on "loria:cobalt_blue"
    :fill_ratio 0.1
    :biomes "loria:azure_bottom"}
   "infernum"
   {:damage 14
    :y_max 0
    :y_min -31000
    :features {:light_source 8}
    :place_on "loria:cobalt_blue"
    :fill_ratio 0.1
    :biomes "loria:azure_bottom"}
   "rosea"
   {:damage 4
    :place_on "loria:copper_sulfate"
    :fill_ratio 0.05
    :biomes "loria:azure"}
   "purpura"
   {:features {:light_source 5}
    :place_on "loria:copper_sulfate"
    :fill_ratio 0.05
    :biomes "loria:azure"}
   "picea"
   {:damage 9
    :place_on "loria:copper_sulfate"
    :fill_ratio 0.05
    :biomes "loria:azure"}
   "caput"
   {:damage 15
    :place_on
      ["loria:cinnabar"
        "loria:red_mercury_oxide"
        "loria:mercury_oxide"]
    :optimal_light 11
    :fill_ratio 0.01
    :biomes "loria:redland"
    :optimal_radiation 5
    :max_radiation 10}
   "periculum"
   {:features {:light_source 3}
    :damage 18
    :place_on "loria:ammonium_manganese_pyrophosphate"
    :fill_ratio 0.01
    :biomes "loria:purple_swamp"}
   "vastatorem"
   {:features {:light_source 8}
    :place_on "loria:nickel_nitrate"
    :fill_ratio 0.005
    :biomes "loria:reptile_house"}
   "quercu"
   {:damage 7
    :place_on
      ["loria:cinnabar"
        "loria:red_mercury_oxide"
        "loria:mercury_oxide"]
    :optimal_light 11
    :biomes "loria:redland"}
   "grebe"
   {:damage 11
    :place_on "loria:ammonium_manganese_pyrophosphate"
    :fill_ratio 0.01
    :biomes "loria:purple_swamp"}
   "secreta"
   {:damage 12
    :place_on "loria:ammonium_manganese_pyrophosphate"
    :fill_ratio 0.01
    :biomes "loria:purple_swamp"}
   "pulchram" {:damage 3}
   "conc"
   {:damage 16
    :place_on "loria:sodium_peroxide"
    :fill_ratio 0.01
    :biomes "loria:acidic_landscapes"}})