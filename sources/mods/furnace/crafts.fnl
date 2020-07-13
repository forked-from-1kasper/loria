(require-macros :useful-macros)

(global refiner_crafts
  [{:input  [{:name "default:copper_sulfate_pure"    :count 2}
             {:name "default:empty_balloon"          :count 3}]
    :output [{:name "default:copper_oxide"           :count 2}
             {:name "default:sulfur_dioxide_balloon" :count 2}
             {:name "default:oxygen_balloon"         :count 1}]
    :time 4}
   {:input  [{:name "default:cuprous_oxide"  :count 2}
             {:name "default:empty_balloon"  :count 1}]
    :output [{:name "default:copper"         :count 4}
             {:name "default:oxygen_balloon" :count 1}]
    :time 2}
   {:input  [{:name "default:copper"        :count 1}
             {:name "default:copper_oxide"  :count 1}]
    :output [{:name "default:cuprous_oxide" :count 1}]
    :time 4}
   {:input  [{:name "default:mercury_oxide"  :count 2}
             {:name "default:empty_balloon"  :count 1}
             {:name "default:bucket_empty"   :count 2}]
    :output [{:name "default:oxygen_balloon" :count 1}
             {:name "default:bucket_mercury" :count 2}]
    :time 3}
   {:input  [{:name "default:cinnabar"       :count 1}
             {:name "default:bucket_empty"   :count 1}]
    :output [{:name "default:sulfur"         :count 1}
             {:name "default:bucket_mercury" :count 1}]
    :time 5}
   {:input  [{:name "default:red_mercury_oxide" :count 2}
             {:name "default:empty_balloon"     :count 1}
             {:name "default:bucket_empty"      :count 2}]
    :output [{:name "default:oxygen_balloon"    :count 1}
             {:name "default:bucket_mercury"    :count 2}]
    :time 3}
   {:input  [{:name "default:copper_sulfate"      :count 1}
             {:name "default:bucket_empty"        :count 5}]
    :output [{:name "default:copper_sulfate_pure" :count 1}
             {:name "default:bucket_water"        :count 5}]
    :time 5}
   {:input  [{:name "default:aluminium_ore"   :count 1}]
    :output [{:name "default:aluminium_ingot" :count 1}
             {:name "default:cinnabar"        :count 1}]
    :time 3}
   {:input  [{:name "default:mercury_oxide"              :count 1}
             {:name "default:bucket_potassium_hydroxide" :count 1}
             {:name "default:zinc_ingot"                 :count 1}
             {:name "default:aluminium_case"             :count 1}]
    :output [{:name "default:battery"                    :count 1}
             {:name "default:bucket_empty"               :count 1}]
    :time 2}
   {:input  [{:name "default:red_mercury_oxide"          :count 1}
             {:name "default:bucket_potassium_hydroxide" :count 1}
             {:name "default:zinc_ingot"                 :count 1}
             {:name "default:aluminium_case"             :count 1}]
    :output [{:name "default:battery"                    :count 1}
             {:name "default:bucket_empty"               :count 1}]
    :time 2}
   {:input  [{:name "default:silicon_dioxide" :count 9}]
    :output [{:name "default:fused_quartz"    :count 1}]
    :time 3}
   {:input  [{:name "default:plutonium_trifluoride"   :count 4}
             {:name "default:oxygen_balloon"          :count 1}]
    :output [{:name "default:plutonium_tetrafluoride" :count 3}
             {:name "default:plutonium_dioxide"       :count 1}
             {:name "default:empty_balloon"           :count 1}]
    :time 3}
   {:input  [{:name "default:lead_sulfate"           :count 1}
             {:name "default:bucket_empty"           :count 1}]
    :output [{:name "default:lead_oxide"             :count 1}
             {:name "default:bucket_sulfur_trioxide" :count 1}]
    :time 4}
   {:input  [{:name "default:lead_oxide"       :count 1}
             {:name "default:hydrogen_balloon" :count 1}
             {:name "default:bucket_empty"     :count 1}]
    :output [{:name "default:lead"             :count 1}
             {:name "default:empty_balloon"    :count 1}
             {:name "default:bucket_water"     :count 1}]
    :time 2}
   {:input  [{:name "default:bucket_potassium_permanganate" :count 2}
             {:name "default:empty_balloon"                 :count 1}]
    :output [{:name "default:potassium_manganate"           :count 1}
             {:name "default:manganese_dioxide"             :count 1}
             {:name "default:oxygen_balloon"                :count 1}
             {:name "default:bucket_empty"                  :count 2}]
    :time 2}
   {:input  [{:name "default:manganese_dioxide" :count 1}
             {:name "default:bucket_empty"      :count 1}
             {:name "default:hydrogen_balloon"  :count 1}]
    :output [{:name "default:manganese_oxide"   :count 1}
             {:name "default:bucket_water"      :count 1}
             {:name "default:empty_balloon"     :count 1}]
    :time 3}
   {:input  [{:name "default:aluminium"       :count 4}
             {:name "default:oxygen_balloon"  :count 1}]
    :output [{:name "default:aluminium_oxide" :count 2}
             {:name "default:empty_balloon"   :count 1}]
    :time 3}
   {:input  [{:name "default:wolfram_ingot"    :count 1}]
    :output [{:name "default:wolfram_filament" :count 15}]
    :time 25}
   {:input  [{:name "default:silicon_dioxide"  :count 1}
             {:name "default:hydrogen_balloon" :count 2}
             {:name "default:bucket_empty"     :count 2}]
    :output [{:name "default:silicon"          :count 1}
             {:name "default:bucket_water"     :count 2}
             {:name "default:empty_balloon"    :count 2}]
    :time 2}
   {:input  [{:name "default:silicon_dioxide" :count 1}
             {:name "default:magnesium"       :count 2}]
    :output [{:name "default:silicon"         :count 1}
             {:name "default:magnesium_oxide" :count 2}]
    :time 5}
   {:input  [{:name "default:silicon_dioxide" :count 3}
             {:name "default:aluminium"       :count 4}]
    :output [{:name "default:silicon"         :count 3}
             {:name "default:aluminium_oxide" :count 2}]
    :time 6}
   {:input  [{:name "default:thorium_iodide" :count 1}]
    :output [{:name "default:thorium"        :count 1}
             {:name "default:iodine"         :count 2}]
    :time 3}
   {:input  [{:name "default:plutonium_tetrafluoride" :count 3}]
    :output [{:name "default:plutonium_trifluoride"   :count 2}
             {:name "default:plutonium_hexafluoride"  :count 1}]
    :time 6}
   {:input  [{:name "default:plutonium_trifluoride" :count 2}
             {:name "default:calcium"               :count 3}]
    :output [{:name "default:plutonium"             :count 2}
             {:name "default:calcium_fluoride"      :count 3}]
    :time 6}
   {:input  [{:name "default:humus"           :count 2}]
    :output [{:name "default:silicon_dioxide" :count 1}]
    :time 10}])

(global furnace_crafts
  [{:input [{:name "default:mushroom_mass"    :count 1}]
    :output [{:name "default:silicon_dioxide" :count 1}]
    :time 7}
   {:input  [{:name "default:aluminium_ingot" :count 5}]
    :output [{:name "default:bucket_empty"    :count 1}]
    :time 8}
   {:input  [{:name "default:zinc_ingot"   :count 4}]
    :output [{:name "default:bucket_empty" :count 1}]
    :time 10}
   {:input  [{:name "default:aluminium_ingot" :count 3}]
    :output [{:name "default:empty_balloon"   :count 1}]
    :time 3}
   {:input  [{:name "default:aluminium_ingot"      :count 2}]
    :output [{:name "default:aluminium_brick_mold" :count 1}]
    :time 3}
   {:input  [{:name "default:copper_ingot"       :count 3}]
    :output [{:name "default:copper_hammer_head" :count 1}]
    :time 3}
   {:input  [{:name "default:aluminium_ingot" :count 1}]
    :output [{:name "default:aluminium_case"  :count 1}]
    :time 3}
   {:input  [{:name "default:bucket_empty"   :count 1}
             {:name "default:mercury"        :count 1}]
    :output [{:name "default:bucket_mercury" :count 1}]
    :time 5}
   {:input  [{:name "default:bucket_lucidum" :count 1}]
    :output [{:name "default:bucket_empty"   :count 1}
             {:name "default:glow_stick"     :count 12}]
    :time 1}
   {:input  [{:name "default:aluminium_oxide" :count 4}
             {:name "default:silicon_dioxide" :count 4}
             {:name "default:bucket_water"    :count 1}]
    :output [{:name "default:brick"           :count 4}
             {:name "default:bucket_empty"    :count 1}]
    :time 2}
   {:input  [{:name "default:thorium_ingot" :count 9}]
    :output [{:name "default:thorium"       :count 1}]
    :time 4}
   {:input  [{:name "default:thorium"       :count 1}]
    :output [{:name "default:thorium_ingot" :count 9}]
    :time 4}
   {:input  [{:name "default:uranium_ingot" :count 9}]
    :output [{:name "default:uranium"       :count 1}]
    :time 4}
   {:input  [{:name "default:uranium"       :count 1}]
    :output [{:name "default:uranium_ingot" :count 9}]
    :time 4}
   {:input  [{:name "default:plutonium_ingot" :count 9}]
    :output [{:name "default:plutonium"       :count 1}]
    :time 4}
   {:input  [{:name "default:plutonium"       :count 1}]
    :output [{:name "default:plutonium_ingot" :count 9}]
    :time 4}])

(each [name params (opairs ores)]
  (local ingot-or-node
    (if params.has_ingot
      {:name (.. "default:" name "_ingot") :count 1}
      {:name (.. "default:" name)          :count 1}))

  (table.insert refiner_crafts
   {:input  [{:name (.. "default:" name "_cinnabar") :count 1}]
    :output [ingot-or-node {:name "default:cinnabar" :count 1}]
    :time 3})

  (table.insert refiner_crafts
   {:input  [{:name (.. "default:" name "_cobalt_blue") :count 1}]
    :output [ingot-or-node {:name "default:cobalt_blue" :count 1}]
    :time 3})

  (if params.has_ingot
    (table.insert refiner_crafts
      {:input  [{:name (.. "default:" name "_ingot") :count 9}]
       :output [{:name (.. "default:" name)          :count 1}]
       :time 4})
    (table.insert refiner_crafts
      {:input  [{:name (.. "default:" name)          :count 1}]
       :output [{:name (.. "default:" name "_ingot") :count 9}]
       :time 4})))

(each [_ mushroom (ipairs giant_mushrooms)]
  (if (≠ mushroom "timor")
    (table.insert furnace_crafts
     {:input  [{:name (.. "default:" mushroom "_body") :count 3}]
      :output [{:name "default:silicon_dioxide"        :count 1}]
      :time 5})
    ;; Exception
    (each [_ name (ipairs timor.body-nodes)]
      (table.insert furnace_crafts
       {:input  [{:name name                      :count 3}]
        :output [{:name "default:silicon_dioxide" :count 1}]
        :time 5})))

  (table.insert furnace_crafts
   {:input  [{:name (.. "default:" mushroom "_stem") :count 5}]
    :output [{:name "default:silicon_dioxide"        :count 1}]
    :time 8}))

(each [name params (opairs brickable)]
  (when (not params.crumbly)
    (table.insert furnace_crafts
      {:input  [{:name name               :count 1}]
       :output [{:name (.. name "_brick") :count 2}]
       :time 3})))

(global fuel_list
  {"default:cinnabar"              1
   "default:potassium"             2
   "default:potassium_cobalt_blue" 3
   "default:potassium_cinnabar"    3
   "default:potassium_azure"       4
   "default:potassium_ingot"       5
   "default:bucket_trisilane"      20})