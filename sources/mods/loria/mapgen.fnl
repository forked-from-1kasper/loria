(require-macros :useful-macros)

(each [i _ (ipairs pars_names)]
  (core.register_decoration
    {:deco_type "simple"
     :place_on "loria:copper_sulfate"
     :sidelen 16
     :fill_ratio 0.1
     :biomes "loria:azure"
     :decoration (.. "loria:pars_" i)
     :height 1
     :y_min -20}))

(each [i _ (ipairs odorantur_names)]
  (core.register_decoration
    {:deco_type "simple"
     :place_on "loria:sodium_peroxide"
     :sidelen 16
     :fill_ratio 0.1
     :biomes "loria:acidic_landscapes"
     :decoration (.. "loria:odorantur_" i)
     :height 1
     :y_min -20}))

(each [i _ (ipairs qui_lucem_names)]
  (core.register_decoration
    {:deco_type "simple"
     :place_on "loria:nickel_nitrate"
     :sidelen 16
     :fill_ratio 0.05
     :biomes "loria:reptile_house"
     :decoration (.. "loria:qui_lucem_" i)
     :height 1
     :y_min -20}))

(each [i _ (ipairs petite_names)]
  (core.register_decoration
    {:deco_type "simple"
     :place_on "loria:ammonium_manganese_pyrophosphate"
     :sidelen 16
     :fill_ratio 0.05
     :biomes "loria:purple_swamp"
     :decoration (.. "loria:petite_" i)
     :height 1
     :y_min -20}))

(on_grasses
  (λ [name _ params]
    (core.register_decoration
      {:deco_type "simple"
       :place_on params.place_on
       :sidelen (or params.sidelen 16)
       :fill_ratio (or params.fill_ratio 0.05)
       :biomes params.biomes
       :decoration (.. "loria:" name)
       :height (or params.min_height 1)
       :height_max params.max_height
       :y_min (or params.y_min -20)})))

(local noise-params-default
  {:offset 0.5
   :scale 0.2
   :spread {:x 3 :y 3 :z 3}
   :seed 17676
   :octaves 1
   :persist 0.0})

(each [name params (pairs ores)]
  (each [_ place (ipairs params.wherein)]
    (core.register_ore
      {:ore_type        (∨ params.ore-type "blob")
       :ore             (.. "loria:" name "_" place)
       :wherein         (.. "loria:" place)
       :clust_scarcity  (∨ params.clust-scarcity (* 16 16 16))
       :clust_num_ores  (∨ params.clust-num-ores 5)
       :clust_size      (∨ params.clust-size 3)
       :y_min           (∨ params.y_min -60)
       :y_max           (∨ params.y_max 60)
       :noise_threshold (∨ params.noise-threshold 0.0)
       :noise_params    (∨ params.noise noise-params-default)})))

(core.register_decoration
  {:deco_type "simple"
   :place_on "loria:lead_sulfate"
   :sidelen 16
   :fill_ratio 0.01
   :biomes "loria:mercury_ocean"
   :decoration "loria:viriditas"
   :height 1
   :y_min -20})

(core.register_decoration
  {:deco_type "simple"
   :place_on "loria:sodium_peroxide"
   :sidelen 16
   :fill_ratio 0.1
   :biomes "loria:acidic_landscapes"
   :decoration "loria:imitationis"
   :height 1
   :y_min -20})

(core.register_decoration
  {:deco_type "simple"
   :place_on "loria:sodium_peroxide"
   :sidelen 16
   :fill_ratio 0.1
   :biomes "loria:acidic_landscapes"
   :decoration "loria:nihil"
   :height 1
   :y_min -20})