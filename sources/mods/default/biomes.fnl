(foreach2 minetest.register_alias
  {"mapgen_stone" "default:cinnabar"
   "mapgen_dirt" "default:mercury_oxide"
   "mapgen_dirt_with_grass" "default:red_mercury_oxide"
   "mapgen_sand" "default:lead_sulfate"
   "mapgen_water_source" "default:polluted_mercury_source"
   "mapgen_river_water_source" "default:polluted_mercury_source"
   "mapgen_lava_source" "default:mercury_source"
   "mapgen_gravel" "default:uranium_tetrachloride_cinnabar"
   "mapgen_tree" "default:viridi_petasum_stem"
   "mapgen_leaves" "default:viridi_petasum_body"
   "mapgen_apple" "default:cinnabar"
   "mapgen_junglegrass" "default:cinnabar"
   "mapgen_cobble" "default:cinnabar"
   "mapgen_stair_cobble" "default:cinnabar"
   "mapgen_mossycobble" "default:cinnabar"})

(minetest.clear_registered_biomes)
(minetest.clear_registered_decorations)

(minetest.register_biome
  {:name "default:redland"
   :node_top "default:red_mercury_oxide"
   :depth_top 1
   :node_filler "default:mercury_oxide"
   :depth_filler 1
   :y_min 5
   :y_max 31000
   :heat_point 50
   :humidity_point 50

   :node_riverbed "default:lead_sulfate"
   :depth_riverbed 2})

(minetest.register_biome
  {:name "default:reptile_house"
   :node_top "default:nickel_nitrate"
   :depth_top 2
   :node_stone "default:chromium_fluoride"
   :y_min -31000
   :y_max 31000
   :heat_point 90
   :humidity_point 50

   :node_riverbed "default:lead_sulfate"
   :depth_riverbed 4})

(minetest.register_biome
  {:name "default:acidic_landscapes"
   :node_top "default:sodium_peroxide"
   :depth_top 5
   :node_stone "default:chromia"
   :y_min -31000
   :y_max 31000
   :heat_point 60
   :humidity_point 50

   :node_riverbed "default:lead_sulfate"
   :depth_riverbed 4})

(minetest.register_biome
  {:name "default:azure"
   :node_top "default:copper_sulfate"
   :depth_top 2
   :node_stone "default:cobalt_blue"
   :y_min -10
   :y_max 31000
   :heat_point 30
   :humidity_point 50

   :node_riverbed "default:lead_sulfate"
   :depth_riverbed 2})

(minetest.register_biome
  {:name "default:azure_bottom"
   :node_top "default:cobalt_blue"
   :depth_top 1
   :node_stone "default:cobalt_blue"
   :y_min -31000
   :y_max -10
   :heat_point 30
   :humidity_point 50})

(minetest.register_biome
  {:name "default:purple_swamp"
   :node_stone "default:ammonium_manganese_pyrophosphate"
   :y_min -15
   :y_max 31000
   :heat_point 40
   :humidity_point 50})

(minetest.register_biome
  {:name "default:swamp_connector"
   :node_stone "default:ammonium_manganese_pyrophosphate"
   :node_top "default:potassium_permanganate_source"
   :depth_top 7
   :node_cave_liquid "default:potassium_permanganate_source"
   :node_water "default:potassium_permanganate_source"
   :node_riverbed "default:potassium_permanganate_source"
   :node_river_water "default:potassium_permanganate_source"
   :node_water_top "default:potassium_permanganate_source"
   :y_min -31000
   :y_max -15
   :heat_point 40
   :humidity_point 50})

(minetest.register_biome
  {:name "default:mercury_ocean"
   :node_top "default:lead_sulfate"
   :depth_top 1
   :node_filler "default:lead_sulfate"
   :depth_filler 2
   :y_min -31000
   :y_max 4
   :heat_point 50
   :humidity_point 50})