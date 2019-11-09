(each [i _ (ipairs pars_names)]
  (minetest.register_decoration
    { :deco_type "simple"
      :place_on "default:copper_sulfate"
      :sidelen 16
      :fill_ratio 0.1
      :biomes "default:azure"
      :decoration (.. "default:pars_" i)
      :height 1
      :y_min -20 }))

(each [i _ (ipairs odorantur_names)]
  (minetest.register_decoration
    { :deco_type "simple"
      :place_on "default:sodium_peroxide"
      :sidelen 16
      :fill_ratio 0.1
      :biomes "default:acidic_landscapes"
      :decoration (.. "default:odorantur_" i)
      :height 1
      :y_min -20 }))

(each [i _ (ipairs qui_lucem_names)]
  (minetest.register_decoration
    { :deco_type "simple"
      :place_on "default:nickel_nitrate"
      :sidelen 16
      :fill_ratio 0.05
      :biomes "default:reptile_house"
      :decoration (.. "default:qui_lucem_" i)
      :height 1
      :y_min -20 }))

(each [i _ (ipairs petite_names)]
  (minetest.register_decoration
    { :deco_type "simple"
      :place_on "default:ammonium_manganese_pyrophosphate"
      :sidelen 16
      :fill_ratio 0.05
      :biomes "default:purple_swamp"
      :decoration (.. "default:petite_" i)
      :height 1
      :y_min -20 }))

(on_grasses
  (λ [name _ params]
    (minetest.register_decoration
      { :deco_type "simple"
        :place_on params.place_on
        :sidelen (or params.sidelen 16)
        :fill_ratio (or params.fill_ratio 0.05)
        :biomes params.biomes
        :decoration (.. "default:" name)
        :height (or params.min_height 1)
        :height_max params.max_height
        :y_min (or params.y_min -20) })))

(each [name params (pairs ores)]
  (each [_ place (ipairs params.wherein)]
    (minetest.register_ore
      { :ore_type       "blob"
        :ore            (.. "default:" name "_" place)
        :wherein        (.. "default:" place)
        :clust_scarcity (* 16 16 16)
        :clust_num_ores 5
        :clust_size     3
        :y_min          (or params.y_min -60)
        :y_max          (or params.y_max 60)
        :noise_threshold 0.0
        :noise_params
          { :offset 0.5
            :scale 0.2
            :spread { :x 3 :y 3 :z 3 }
            :seed 17676
            :octaves 1
            :persist 0.0 }})))

(minetest.register_decoration
  { :deco_type "simple"
    :place_on "default:lead_sulfate"
    :sidelen 16
    :fill_ratio 0.01
    :biomes "default:mercury_ocean"
    :decoration "default:viriditas"
    :height 1
    :y_min -20 })

(minetest.register_decoration
  { :deco_type "simple"
    :place_on "default:sodium_peroxide"
    :sidelen 16
    :fill_ratio 0.1
    :biomes "default:acidic_landscapes"
    :decoration "default:imitationis"
    :height 1
    :y_min -20 })

(minetest.register_decoration
  { :deco_type "simple"
    :place_on "default:sodium_peroxide"
    :sidelen 16
    :fill_ratio 0.1
    :biomes "default:acidic_landscapes"
    :decoration "default:nihil"
    :height 1
    :y_min -20 })