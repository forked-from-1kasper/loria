(require-macros :useful-macros)

(global refiner_crafts
  [{:input  [{:name "loria:copper_sulfate_pure"    :count 2}
             {:name "loria:empty_balloon"          :count 3}]
    :output [{:name "loria:copper_oxide"           :count 2}
             {:name "loria:sulfur_dioxide_balloon" :count 2}
             {:name "loria:oxygen_balloon"         :count 1}]
    :time 4}
   {:input  [{:name "loria:cuprous_oxide"  :count 2}
             {:name "loria:empty_balloon"  :count 1}]
    :output [{:name "loria:copper"         :count 4}
             {:name "loria:oxygen_balloon" :count 1}]
    :time 2}
   {:input  [{:name "loria:copper"        :count 1}
             {:name "loria:copper_oxide"  :count 1}]
    :output [{:name "loria:cuprous_oxide" :count 1}]
    :time 4}
   {:input  [{:name "loria:mercury_oxide"  :count 2}
             {:name "loria:empty_balloon"  :count 1}
             {:name "loria:bucket_empty"   :count 2}]
    :output [{:name "loria:oxygen_balloon" :count 1}
             {:name "loria:bucket_mercury" :count 2}]
    :time 3}
   {:input  [{:name "loria:cinnabar"       :count 1}
             {:name "loria:bucket_empty"   :count 1}]
    :output [{:name "loria:sulfur"         :count 1}
             {:name "loria:bucket_mercury" :count 1}]
    :time 5}
   {:input  [{:name "loria:red_mercury_oxide" :count 2}
             {:name "loria:empty_balloon"     :count 1}
             {:name "loria:bucket_empty"      :count 2}]
    :output [{:name "loria:oxygen_balloon"    :count 1}
             {:name "loria:bucket_mercury"    :count 2}]
    :time 3}
   {:input  [{:name "loria:copper_sulfate"      :count 1}
             {:name "loria:bucket_empty"        :count 5}]
    :output [{:name "loria:copper_sulfate_pure" :count 1}
             {:name "loria:bucket_water"        :count 5}]
    :time 5}
   {:input  [{:name "loria:aluminium_ore"   :count 1}]
    :output [{:name "loria:aluminium_ingot" :count 1}
             {:name "loria:cinnabar"        :count 1}]
    :time 3}
   {:input  [{:name "loria:mercury_oxide"              :count 1}
             {:name "loria:bucket_potassium_hydroxide" :count 1}
             {:name "loria:zinc_ingot"                 :count 1}
             {:name "loria:aluminium_case"             :count 1}]
    :output [{:name "loria:battery"                    :count 1}
             {:name "loria:bucket_empty"               :count 1}]
    :time 2}
   {:input  [{:name "loria:red_mercury_oxide"          :count 1}
             {:name "loria:bucket_potassium_hydroxide" :count 1}
             {:name "loria:zinc_ingot"                 :count 1}
             {:name "loria:aluminium_case"             :count 1}]
    :output [{:name "loria:battery"                    :count 1}
             {:name "loria:bucket_empty"               :count 1}]
    :time 2}
   {:input  [{:name "loria:silicon_dioxide" :count 9}]
    :output [{:name "loria:fused_quartz"    :count 1}]
    :time 3}
   {:input  [{:name "loria:plutonium_trifluoride"   :count 4}
             {:name "loria:oxygen_balloon"          :count 1}]
    :output [{:name "loria:plutonium_tetrafluoride" :count 3}
             {:name "loria:plutonium_dioxide"       :count 1}
             {:name "loria:empty_balloon"           :count 1}]
    :time 3}
   {:input  [{:name "loria:lead_sulfate"           :count 1}
             {:name "loria:bucket_empty"           :count 1}]
    :output [{:name "loria:lead_oxide"             :count 1}
             {:name "loria:bucket_sulfur_trioxide" :count 1}]
    :time 4}
   {:input  [{:name "loria:lead_oxide"       :count 1}
             {:name "loria:hydrogen_balloon" :count 1}
             {:name "loria:bucket_empty"     :count 1}]
    :output [{:name "loria:lead"             :count 1}
             {:name "loria:empty_balloon"    :count 1}
             {:name "loria:bucket_water"     :count 1}]
    :time 2}
   {:input  [{:name "loria:bucket_potassium_permanganate" :count 2}
             {:name "loria:empty_balloon"                 :count 1}]
    :output [{:name "loria:potassium_manganate"           :count 1}
             {:name "loria:manganese_dioxide"             :count 1}
             {:name "loria:oxygen_balloon"                :count 1}
             {:name "loria:bucket_empty"                  :count 2}]
    :time 2}
   {:input  [{:name "loria:manganese_dioxide" :count 1}
             {:name "loria:bucket_empty"      :count 1}
             {:name "loria:hydrogen_balloon"  :count 1}]
    :output [{:name "loria:manganese_oxide"   :count 1}
             {:name "loria:bucket_water"      :count 1}
             {:name "loria:empty_balloon"     :count 1}]
    :time 3}
   {:input  [{:name "loria:aluminium_ingot"       :count 4}
             {:name "loria:oxygen_balloon"  :count 1}]
    :output [{:name "loria:aluminium_oxide" :count 2}
             {:name "loria:empty_balloon"   :count 1}]
    :time 3}
   {:input  [{:name "loria:wolfram_ingot"    :count 1}]
    :output [{:name "loria:wolfram_filament" :count 15}]
    :time 25}
   {:input  [{:name "loria:silicon_dioxide"  :count 1}
             {:name "loria:hydrogen_balloon" :count 2}
             {:name "loria:bucket_empty"     :count 2}]
    :output [{:name "loria:silicon"          :count 1}
             {:name "loria:bucket_water"     :count 2}
             {:name "loria:empty_balloon"    :count 2}]
    :time 2}
   {:input  [{:name "loria:silicon_dioxide" :count 1}
             {:name "loria:magnesium"       :count 2}]
    :output [{:name "loria:silicon"         :count 1}
             {:name "loria:magnesium_oxide" :count 2}]
    :time 5}
   {:input  [{:name "loria:silicon_dioxide" :count 3}
             {:name "loria:aluminium_ingot"       :count 4}]
    :output [{:name "loria:silicon"         :count 3}
             {:name "loria:aluminium_oxide" :count 2}]
    :time 6}
   {:input  [{:name "loria:thorium_iodide" :count 1}]
    :output [{:name "loria:thorium"        :count 1}
             {:name "loria:iodine"         :count 2}]
    :time 3}
   {:input  [{:name "loria:plutonium_tetrafluoride" :count 3}]
    :output [{:name "loria:plutonium_trifluoride"   :count 2}
             {:name "loria:plutonium_hexafluoride"  :count 1}]
    :time 6}
   {:input  [{:name "loria:plutonium_trifluoride" :count 2}
             {:name "loria:calcium"               :count 3}]
    :output [{:name "loria:plutonium"             :count 2}
             {:name "loria:calcium_fluoride"      :count 3}]
    :time 6}
   {:input  [{:name "loria:humus"           :count 2}]
    :output [{:name "loria:silicon_dioxide" :count 1}]
    :time 10}
   {:input  [{:name "loria:sodium_peroxide" :count 2}
             {:name "loria:empty_balloon"   :count 1}]
    :output [{:name "loria:sodium_oxide"    :count 2}
             {:name "loria:oxygen_balloon"  :count 1}]
    :time 5}
   {:input  [{:name "loria:chormium_trioxide" :count 4}
             {:name "loria:empty_balloon"     :count 3}]
    :output [{:name "loria:chromia"           :count 2}
             {:name "loria:oxygen_balloon"    :count 3}]
    :time 3}
   {:input  [{:name "loria:chromia"         :count 1}
             {:name "loria:aluminium_ingot" :count 2}]
    :output [{:name "loria:aluminium_oxide" :count 1}
             {:name "loria:chromium"        :count 2}]
    :time 5}
   {:input  [{:name "loria:silicon"          :count 3}]
    :output [{:name "electricity:transistor" :count 5}]
    :time 20}
   {:input  [{:name "loria:silicon"     :count 1}]
    :output [{:name "electricity:diode" :count 5}]
    :time 10}
   {:input  [{:name "loria:lead"          :count 1}
             {:name "loria:selenium"      :count 1}]
    :output [{:name "loria:lead_selenide" :count 1}]
    :time 5}
   {:input  [{:name "loria:thorium"         :count 1}
             {:name "loria:oxygen_balloon"  :count 1}]
    :output [{:name "loria:thorium_dioxide" :count 1}
             {:name "loria:empty_balloon"   :count 1}]
    :time 6}
   {:input  [{:name "loria:magnetite"     :count 2}]
    :output [{:name "loria:ferrous_oxide" :count 1}
             {:name "loria:ferric_oxide"  :count 1}]
    :time 3}])

(global furnace_crafts
  [{:input  [{:name "loria:mushroom_mass"   :count 1}]
    :output [{:name "loria:silicon_dioxide" :count 1}]
    :time 7}
   {:input  [{:name "loria:aluminium_ingot" :count 5}]
    :output [{:name "loria:bucket_empty"    :count 1}]
    :time 8}
   {:input  [{:name "loria:zinc_ingot"   :count 4}]
    :output [{:name "loria:bucket_empty" :count 1}]
    :time 10}
   {:input  [{:name "loria:aluminium_ingot" :count 3}]
    :output [{:name "loria:empty_balloon"   :count 1}]
    :time 3}
   {:input  [{:name "loria:aluminium_ingot"      :count 2}]
    :output [{:name "loria:aluminium_brick_mold" :count 1}]
    :time 3}
   {:input  [{:name "loria:aluminium_ingot" :count 1}]
    :output [{:name "loria:aluminium_case"  :count 1}]
    :time 3}
   {:input  [{:name "loria:bucket_empty"   :count 1}
             {:name "loria:mercury"        :count 1}]
    :output [{:name "loria:bucket_mercury" :count 1}]
    :time 5}
   {:input  [{:name "loria:bucket_lucidum" :count 1}]
    :output [{:name "loria:bucket_empty"   :count 1}
             {:name "loria:glow_stick"     :count 12}]
    :time 1}
   {:input  [{:name "loria:aluminium_oxide" :count 4}
             {:name "loria:silicon_dioxide" :count 4}
             {:name "loria:bucket_water"    :count 1}]
    :output [{:name "loria:brick"           :count 16}
             {:name "loria:bucket_empty"    :count 1}]
    :time 2}
   {:input  [{:name "loria:plutonium_ingot" :count 9}]
    :output [{:name "loria:plutonium"       :count 1}]
    :time 4}
   {:input  [{:name "loria:plutonium"       :count 1}]
    :output [{:name "loria:plutonium_ingot" :count 9}]
    :time 4}])

;; >1000 ℃
(global high_temperature_crafts
  [{:input  [{:name "loria:uranium"       :count 1}]
    :output [{:name "loria:uranium_ingot" :count 9}]
    :time 4}
   {:input  [{:name "loria:uranium_ingot" :count 9}]
    :output [{:name "loria:uranium"       :count 1}]
    :time 4}
   {:input  [{:name "loria:thorium_ingot" :count 9}]
    :output [{:name "loria:thorium"       :count 1}]
    :time 4}
   {:input  [{:name "loria:thorium"       :count 1}]
    :output [{:name "loria:thorium_ingot" :count 9}]
    :time 4}
   {:input  [{:name "loria:copper_ingot"       :count 3}]
    :output [{:name "loria:copper_hammer_head" :count 1}]
    :time 3}])

(each [name params (opairs ores)]
  (local ingot-or-node
    (if params.has_ingot
      {:name (.. "loria:" name "_ingot") :count 1}
      {:name (.. "loria:" name)          :count 1}))

  (each [_ place (ipairs params.wherein)]
    (table.insert refiner_crafts
      {:input [{:name (.. "loria:" name "_" place) :count 1}]
       :output [ingot-or-node {:name (.. "loria:" place) :count 1}]
       :time 3}))

  (when params.has_ingot
    (table.insert refiner_crafts
      {:input  [{:name (.. "loria:" name "_ingot") :count 9}]
       :output [{:name (.. "loria:" name)          :count 1}]
       :time 4})
    (table.insert refiner_crafts
      {:input  [{:name (.. "loria:" name)          :count 1}]
       :output [{:name (.. "loria:" name "_ingot") :count 9}]
       :time 4})))

(each [_ mushroom (ipairs giant_mushrooms)]
  (if (≠ mushroom "timor")
    (table.insert furnace_crafts
     {:input  [{:name (.. "loria:" mushroom "_body") :count 3}]
      :output [{:name "loria:silicon_dioxide"        :count 1}]
      :time 5})
    ;; Exception
    (each [_ name (ipairs timor.body-nodes)]
      (table.insert furnace_crafts
       {:input  [{:name name                      :count 3}]
        :output [{:name "loria:silicon_dioxide"   :count 1}]
        :time 5})))

  (table.insert furnace_crafts
   {:input  [{:name (.. "loria:" mushroom "_stem") :count 5}]
    :output [{:name "loria:silicon_dioxide"        :count 1}]
    :time 8}))

(each [name params (opairs brickable)]
  (if (not params.crumbly)
    (let [target-list (if params.refractory high_temperature_crafts
                                            furnace_crafts)]
      (table.insert target-list
        {:input  [{:name name               :count 1}]
         :output [{:name (.. name "_brick") :count 2}]
         :time 3}))
    (let [target-list (if params.refractory high_temperature_crafts
                                            furnace_crafts)]
      (table.insert target-list
        {:input  [{:name name                         :count 4}
                  {:name "loria:silicon_dioxide"      :count 4}
                  {:name "loria:aluminium_brick_mold" :count 1}
                  {:name "loria:bucket_water"         :count 1}]
         :output [{:name (.. name "_brick")           :count 4}
                  {:name "loria:aluminium_brick_mold" :count 1}
                  {:name "loria:bucket_empty"         :count 1}]
         :time 5}))))

(global fuel_list
  {"loria:cinnabar"                    1
   "loria:potassium"                   2
   "loria:potassium_cobalt_blue"       3
   "loria:potassium_cinnabar"          3
   "loria:potassium_cinnabar"          3
   "loria:potassium_azure"             4
   "loria:potassium_chromia"           5
   "loria:potassium_chromium_fluoride" 5
   "loria:potassium_ingot"             5
   "loria:bucket_trisilane"            20})

(global high_temperature_furnace_crafts [])
(append high_temperature_furnace_crafts furnace_crafts)
(append high_temperature_furnace_crafts high_temperature_crafts)

