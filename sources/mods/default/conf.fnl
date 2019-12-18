(global liquids
  { "potassium_hydroxide"
    { :liquid_viscosity 1
      :damage 3
      :post_effect_color { :a 30 :r 255 :g 255 :b 255 }
      :alpha 50
      :texture "default_liquid.png"
      :animated_texture "default_liquid_source_animated.png"
      :animated_flowing_texture "default_liquid_flowing_animated.png"
      :bucket_image "bucket_potassium_hydroxide.png"
      :bucket_description "Potassium hydroxide (KOH)" }
    "trisilane"
    { :liquid_viscosity 1
      :post_effect_color { :a 70 :r 255 :g 255 :b 255 }
      :alpha 70
      :texture "default_liquid.png"
      :animated_texture "default_liquid_source_animated.png"
      :animated_flowing_texture "default_liquid_flowing_animated.png"
      :is_fuel true
      :bucket_image "bucket_trisilane.png"
      :bucket_description "Trisilane (Si3H8)" }
    "hydrochloric_acid"
    { :liquid_viscosity 1
      :post_effect_color { :a 30 :r 255 :g 255 :b 255 }
      :damage 10
      :alpha 30
      :texture "default_liquid.png"
      :animated_texture "default_liquid_source_animated.png"
      :animated_flowing_texture "default_liquid_flowing_animated.png"
      :bucket_image "bucket_hydrochloric_acid.png"
      :bucket_description "Hydrochloric acid (HCl)" }
    "sulfur_trioxide"
    { :liquid_viscosity 1
      :post_effect_color { :a 30 :r 255 :g 255 :b 255 }
      :alpha 100
      :damage 5
      :texture "default_liquid.png"
      :animated_texture "default_liquid_source_animated.png"
      :animated_flowing_texture "default_liquid_flowing_animated.png"
      :bucket_image "bucket_sulfur_trioxide.png"
      :bucket_description "Sulfur trioxide (SO3)" }
    "water"
    { :liquid_viscosity 2
      :post_effect_color { :a 103 :r 30 :g 60 :b 90 }
      :alpha 160
      :texture "default_water.png"
      :animated_texture "default_water_source_animated.png"
      :animated_flowing_texture "default_water_flowing_animated.png"
      :bucket_image "bucket_water.png"
      :bucket_description "Water (H2O)" }
    "mercury"
    { :damage_per_second 2
      :liquid_viscosity 7
      :post_effect_color { :a 252 :r 150 :g 150 :b 150 }
      :alpha 255
      :texture "default_mercury.png"
      :animated_texture "default_mercury_animated.png"
      :animated_flowing_texture "default_mercury_animated.png"
      :bucket_image "bucket_mercury.png"
      :bucket_description "Mercury (Hg)" }
    "polluted_mercury"
    { :damage_per_second 3
      :liquid_viscosity 7
      :post_effect_color { :a 252 :r 150 :g 150 :b 150 }
      :alpha 255
      :texture "default_mercury.png"
      :animated_texture "default_mercury_animated.png"
      :animated_flowing_texture "default_mercury_animated.png"
      :bucket_image "bucket_mercury.png"
      :bucket_description "Polluted (U, Th) mercury" }
    "potassium_permanganate"
    { :liquid_viscosity 1
      :post_effect_color { :a 100 :r 160 :g 0 :b 130 }
      :alpha 160
      :texture "default_potassium_permanganate.png"
      :animated_texture "default_potassium_permanganate_animated.png"
      :animated_flowing_texture "default_potassium_permanganate_animated.png"
      :bucket_image "bucket_potassium_permanganate.png"
      :bucket_description "Potassium permanganate (KMnO4)" }
    "lucidum"
    { :liquid_viscosity 3
      :post_effect_color { :a 150 :r 0 :g 128 :b 255 }
      :alpha 150
      :light_source 13
      :texture "default_liquid.png^[colorize:#0080ff"
      :animated_texture "default_liquid_source_animated.png^[colorize:#0080ff"
      :animated_flowing_texture "default_liquid_flowing_animated.png^[colorize:#0080ff"
      :bucket_image "bucket_lucidum.png"
      :bucket_description "Lucidum" }})

(global ores {
    "aluminium"
    { :formula "Al" :has_ingot true
      :wherein [ "cobalt_blue" "cinnabar" "chromia" ] }
    "potassium"
    { :formula "K" :has_ingot true
      :wherein [ "cobalt_blue" "cinnabar" ] }
    "zinc"
    { :formula "Zn" :has_ingot true
      :wherein [ "cobalt_blue" "cinnabar" ] }
    "calcium"
    { :formula "Ca" :has_ingot true
      :y_max -700 :y_min -1200
      :wherein [ "chromium_fluoride" ] }
    "copper"
    { :formula "Cu" :has_ingot true
      :wherein [ "cobalt_blue" "cinnabar" ] }
    "wolfram"
    { :formula "W" :has_ingot true
      :y_max -300 :y_min -1500
      :wherein [ "cobalt_blue" "cinnabar" ] }
    "magnesium"
    { :formula "Mg" :has_ingot true
      :y_max -600 :y_min -900
      :wherein [ "cobalt_blue" "cinnabar" "chromia" ] }
    "molybdenum"
    { :formula "Mo" :has_ingot true
      :y_max -500 :y_min -800
      :wherein [ "cobalt_blue" "cinnabar" ] }
    "cuprous_oxide"
    { :formula "Cu2O" :has_ingot false
      :wherein [ "cobalt_blue" "chromia" ]
      :y_min -70 :y_max 0 }
    "platinum"
    { :formula "Pt" :has_ingot true
      :wherein [ "cobalt_blue" "cinnabar" ]
      :y_min -300 :y_max -150 }
    "uranium_tetrachloride" ; 234
    { :formula "UCl4" :has_ingot false
      :wherein [ "cobalt_blue" "cinnabar" "chromium_fluoride" "chromia" ]
      :radioactive true }
    "thorium_iodide" ; 232
    { :formula "ThI4" :has_ingot false
      :wherein [ "cobalt_blue" "cinnabar" "chromium_fluoride" "chromia" ]
      :radioactive true }
    "plutonium_trifluoride" ; 238
    { :formula "PuF3" :has_ingot false
      :wherein [ "cobalt_blue" "cinnabar" "chromium_fluoride" ]
      :radioactive true }
    "americium_trifluoride" ; 243
    { :formula "AmF3" :has_ingot false
      :y_min -243 :light_source 10
      :wherein [ "cobalt_blue" "cinnabar" "chromium_fluoride" ]
      :radioactive true }
    "magnetite"
    { :formula "FeO * Fe2O3" :has_ingot false
      :y_max -200 :y_min -500
      :wherein [ "cobalt_blue" "cinnabar" "chromium_fluoride" ] }})

(global grasses
  { "rami"
    { :max_height 4
      :place_on "default:ammonium_manganese_pyrophosphate"
      :biomes "default:purple_swamp" }
    "spears"
    { :max_height 4
      :place_on "default:ammonium_manganese_pyrophosphate"
      :biomes "default:purple_swamp" }
    "cruento"
    { :max_height 6 :fill_ratio 0.001
      :place_on "default:ammonium_manganese_pyrophosphate"
      :biomes "default:purple_swamp" }
    "veteris"
    { :max_height 8
      :place_on "default:sodium_peroxide"
      :biomes "default:acidic_landscapes" }
    "lectica"
    { :max_height 5
      :place_on "default:sodium_peroxide"
      :biomes "default:acidic_landscapes" }
    "truncus"
    { :variants [ "hyacinthum" "viridi" "purpura" ]
      :max_height 7
      :place_on "default:copper_sulfate"
      :biomes "default:azure" }})

(global giant_mushrooms [ "viridi_petasum" "colossus" "turris" "rete" ])

(global cables
  [ { :name "copper"    :resis 0.0225 }
    { :name "aluminium" :resis 0.036  }
    { :name "wolfram"   :resis 0.055  }
    { :name "platinum"  :resis 0.098  }
    { :name "calcium"   :resis 0.046  }
    { :name "uranium"   :resis 0.295  }
    { :name "thorium"   :resis 0.1862 }
    { :name "plutonium" :resis 150    } ])

(global brickable
  { "default:cinnabar" { :crumbly true }
    "default:plutonium_dioxide" { :crumbly false }
    "default:uranium_tetrachloride" { :crumbly true }
    "default:ammonium_manganese_pyrophosphate" { :crumbly true }
    "default:mercury_oxide" { :crumbly true }
    "default:red_mercury_oxide" { :crumbly true }
    "default:lead_sulfate" { :crumbly true } })

(global small_mushrooms {
    "pusilli"
    { :damage 5
      :place_on
        [ "default:cinnabar"
          "default:red_mercury_oxide"
          "default:mercury_oxide" ]
      :optimal_light 11
      :fill_ratio 0.01
      :biomes "default:redland"
      :optimal_radiation 5
      :max_radiation 10 }
    "rosea"
    { :damage 4
      :place_on "default:copper_sulfate"
      :fill_ratio 0.05
      :biomes "default:azure" }
    "purpura"
    { :features { :light_source 5 }
      :place_on "default:copper_sulfate"
      :fill_ratio 0.05
      :biomes "default:azure" }
    "picea"
    { :damage 9
      :place_on "default:copper_sulfate"
      :fill_ratio 0.05
      :biomes "default:azure" }
    "caput"
    { :damage 15
      :place_on
        [ "default:cinnabar"
          "default:red_mercury_oxide"
          "default:mercury_oxide" ]
      :optimal_light 11
      :fill_ratio 0.01
      :biomes "default:redland"
      :optimal_radiation 5
      :max_radiation 10 }
    "periculum"
    { :features { :light_source 3 }
      :damage 18
      :place_on "default:ammonium_manganese_pyrophosphate"
      :fill_ratio 0.01
      :biomes "default:purple_swamp" }
    "vastatorem"
    { :features { :light_source 8 }
      :place_on "default:nickel_nitrate"
      :fill_ratio 0.005
      :biomes "default:reptile_house" }
    "quercu"
    { :damage 7
      :place_on
        [ "default:cinnabar"
          "default:red_mercury_oxide"
          "default:mercury_oxide" ]
      :optimal_light 11
      :biomes "default:redland" }
    "grebe"
    { :damage 11
      :place_on "default:ammonium_manganese_pyrophosphate"
      :fill_ratio 0.01
      :biomes "default:purple_swamp" }
    "secreta"
    { :damage 12
      :place_on "default:ammonium_manganese_pyrophosphate"
      :fill_ratio 0.01
      :biomes "default:purple_swamp" }
    "pulchram" { :damage 3 }
    "conc"
    { :damage 16
      :place_on "default:sodium_peroxide"
      :fill_ratio 0.01
      :biomes "default:acidic_landscapes" }})