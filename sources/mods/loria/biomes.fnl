(foreach2 core.register_alias
  {"mapgen_stone" "loria:cinnabar"
   "mapgen_dirt" "loria:mercury_oxide"
   "mapgen_dirt_with_grass" "loria:red_mercury_oxide"
   "mapgen_sand" "loria:lead_sulfate"
   "mapgen_water_source" "loria:polluted_mercury_source"
   "mapgen_river_water_source" "loria:polluted_mercury_source"
   "mapgen_lava_source" "loria:mercury_source"
   "mapgen_gravel" "loria:uranium_tetrachloride_cinnabar"
   "mapgen_tree" "loria:viridi_petasum_stem"
   "mapgen_leaves" "loria:viridi_petasum_body"
   "mapgen_apple" "loria:cinnabar"
   "mapgen_junglegrass" "loria:cinnabar"
   "mapgen_cobble" "loria:cinnabar"
   "mapgen_stair_cobble" "loria:cinnabar"
   "mapgen_mossycobble" "loria:cinnabar"})

(core.clear_registered_biomes)
(core.clear_registered_decorations)

(core.register_biome
  {:name "loria:redland"
   :node_top "loria:red_mercury_oxide"
   :depth_top 1
   :node_filler "loria:mercury_oxide"
   :depth_filler 1
   :y_min 5
   :y_max 31000
   :heat_point 50
   :humidity_point 50

   :node_riverbed "loria:lead_sulfate"
   :depth_riverbed 2})

(core.register_biome
  {:name "loria:reptile_house"
   :node_top "loria:nickel_nitrate"
   :depth_top 2
   :node_stone "loria:chromium_fluoride"
   :y_min -31000
   :y_max 31000
   :heat_point 90
   :humidity_point 50

   :node_riverbed "loria:lead_sulfate"
   :depth_riverbed 4})

(core.register_biome
  {:name "loria:acidic_landscapes"
   :node_top "loria:sodium_peroxide"
   :depth_top 5
   :node_stone "loria:chromia"
   :y_min -31000
   :y_max 31000
   :heat_point 60
   :humidity_point 50

   :node_riverbed "loria:lead_sulfate"
   :depth_riverbed 4})

(core.register_biome
  {:name "loria:azure"
   :node_top "loria:copper_sulfate"
   :depth_top 2
   :node_stone "loria:cobalt_blue"
   :y_min -10
   :y_max 31000
   :heat_point 30
   :humidity_point 50

   :node_riverbed "loria:lead_sulfate"
   :depth_riverbed 2})

(core.register_biome
  {:name "loria:azure_bottom"
   :node_top "loria:cobalt_blue"
   :depth_top 1
   :node_stone "loria:cobalt_blue"
   :y_min -31000
   :y_max -10
   :heat_point 30
   :humidity_point 50})

(core.register_biome
  {:name "loria:purple_swamp"
   :node_stone "loria:ammonium_manganese_pyrophosphate"
   :y_min -15
   :y_max 31000
   :heat_point 40
   :humidity_point 50})

(core.register_biome
  {:name "loria:swamp_connector"
   :node_stone "loria:ammonium_manganese_pyrophosphate"
   :node_top "loria:potassium_permanganate_source"
   :depth_top 7
   :node_cave_liquid "loria:potassium_permanganate_source"
   :node_water "loria:potassium_permanganate_source"
   :node_riverbed "loria:potassium_permanganate_source"
   :node_river_water "loria:potassium_permanganate_source"
   :node_water_top "loria:potassium_permanganate_source"
   :y_min -31000
   :y_max -15
   :heat_point 40
   :humidity_point 50})

(core.register_biome
  {:name "loria:mercury_ocean"
   :node_top "loria:lead_sulfate"
   :depth_top 1
   :node_filler "loria:lead_sulfate"
   :depth_filler 2
   :y_min -31000
   :y_max 4
   :heat_point 50
   :humidity_point 50})