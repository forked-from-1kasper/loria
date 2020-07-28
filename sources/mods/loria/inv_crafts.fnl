(require-macros :useful-macros)

(defun on_grasses [func]
  (each [grass params (pairs grasses)]
    (if params.variants
      (each [id variant (ipairs params.variants)]
          (func (.. grass "_" id)
                (.. grass " " variant)
                params))
      (func grass grass params))))

(global inv_crafts
  [{:input  [{:name "loria:lead"                       :count 1}
             {:name "loria:copper_sulfate"             :count 1}]
    :output [{:name "loria:copper"                     :count 1}
             {:name "loria:lead_sulfate"               :count 1}]}
   {:input  [{:name "loria:naga"                       :count 25}
             {:name "loria:bucket_empty"               :count 1}]
    :output [{:name "loria:bucket_lucidum"             :count 1}]}
   {:input  [{:name "loria:purpura"                    :count 30}
             {:name "loria:bucket_empty"               :count 1}]
    :output [{:name "loria:bucket_lucidum"             :count 1}]}
   {:input  [{:name "loria:vastatorem"                 :count 20}
             {:name "loria:bucket_empty"               :count 1}]
    :output [{:name "loria:bucket_lucidum"             :count 1}]}
   {:input  [{:name "loria:deus"                       :count 40}
             {:name "loria:bucket_empty"               :count 1}]
    :output [{:name "loria:bucket_lucidum"             :count 1}]}
   {:input  [{:name "loria:vult"                       :count 50}
             {:name "loria:bucket_empty"               :count 1}]
    :output [{:name "loria:bucket_lucidum"             :count 1}]}
   {:input  [{:name "loria:infernum"                   :count 40}
             {:name "loria:bucket_empty"               :count 1}]
    :output [{:name "loria:bucket_lucidum"             :count 1}]}
   {:input  [{:name "loria:periculum"                  :count 25}
             {:name "loria:bucket_empty"               :count 1}]
    :output [{:name "loria:bucket_lucidum"             :count 1}]}
   {:input  [{:name "loria:viridi_petasum_body"        :count 40}
             {:name "loria:bucket_empty"               :count 1}]
    :output [{:name "loria:bucket_lucidum"             :count 1}]}
   {:input  [{:name "loria:potassium_ingot"            :count 2}
             {:name "loria:bucket_water"               :count 2}
             {:name "loria:empty_balloon"              :count 1}]
    :output [{:name "loria:bucket_potassium_hydroxide" :count 2}
             {:name "loria:hydrogen_balloon"           :count 2}]}
   {:input  [{:name "loria:broken_drill"               :count 1}
             {:name "loria:battery"                    :count 1}]
    :output [{:name "loria:drill"                      :count 1}]}
   {:input  [{:name "electricity:aluminium_wire"       :count 10}
             {:name "loria:lead_case"                  :count 1}]
    :output [{:name "electricity:battery_box"          :count 1}]}
   {:input  [{:name "loria:uranium_tetrachloride"      :count 1}
             {:name "loria:potassium_ingot"            :count 1}]
    :output [{:name "loria:uranium"                    :count 1}
             {:name "loria:potassium_chloride"         :count 4}]}
   {:input  [{:name "loria:lead"                       :count 4}]
    :output [{:name "loria:lead_case"                  :count 1}]}
   {:input  [{:name "loria:lead_selenide"              :count 3}]
    :output [{:name "furnace:gas"                      :count 1}]}
   {:input  [{:name "loria:thorium_dioxide"            :count 3}]
    :output [{:name "furnace:thorium"                  :count 1}]}
   {:input  [{:name "loria:lead_case"                  :count 1}
             {:name "loria:lead"                       :count 1}]
    :output [{:name "loria:lead_box"                   :count 1}]}
   {:input  [{:name "loria:silicon"                    :count 3}]
    :output [{:name "loria:silicon_box"                :count 1}]}
   {:input  [{:name "loria:stick"                      :count 1}
             {:name "loria:copper_hammer_head"         :count 1}]
    :output [{:name "loria:copper_hammer"              :count 1}]}
   {:input  [{:name "loria:zinc_ingot"                 :count 1}
             {:name "loria:bucket_hydrochloric_acid"   :count 2}
             {:name "loria:empty_balloon"              :count 1}]
    :output [{:name "loria:zinc_chloride"              :count 1}
             {:name "loria:bucket_empty"               :count 2}
             {:name "loria:hydrogen_balloon"           :count 1}]}
   {:input  [{:name "loria:aluminium_ingot"            :count 1}
             {:name "loria:bucket_hydrochloric_acid"   :count 3}
             {:name "loria:empty_balloon"              :count 1}]
    :output [{:name "loria:aluminium_chloride"         :count 1}
             {:name "loria:bucket_empty"               :count 3}
             {:name "loria:hydrogen_balloon"           :count 1}]}
   {:input  [{:name "loria:potassium_ingot"            :count 2}
             {:name "loria:bucket_hydrochloric_acid"   :count 2}
             {:name "loria:empty_balloon"              :count 1}]
    :output [{:name "loria:potassium_chloride"         :count 2}
             {:name "loria:bucket_empty"               :count 2}
             {:name "loria:hydrogen_balloon"           :count 1}]}
   {:input  [{:name "loria:lead_case"                  :count 1}
             {:name "loria:wolfram_filament"           :count 1}
             {:name "loria:fused_quartz"               :count 1}
             {:name "electricity:aluminium_wire"       :count 1}]
    :output [{:name "electricity:lamp_off"             :count 1}]}
   {:input  [{:name "electricity:lamp_broken"          :count 1}]
    :output [{:name "loria:lead"                       :count 1}]}
   {:input  [{:name "loria:chromia"                    :count 1}
             {:name "loria:bucket_hydrochloric_acid"   :count 6}]
    :output [{:name "loria:chromic_chloride"           :count 2}
             {:name "loria:bucket_water"               :count 3}
             {:name "loria:bucket_empty"               :count 3}]}])

(each [name params (opairs small_mushrooms)]
  (table.insert inv_crafts
    {:input  [{:name (.. "loria:" name)    :count 20}]
     :output [{:name "loria:mushroom_mass" :count 1}]}))

(each [_ conf (ipairs wires)]
  (table.insert inv_crafts
    {:input  [{:name (.. "loria:" conf.name "_ingot")      :count 1}]
     :output [{:name (.. "electricity:" conf.name "_wire") :count 15}]}))

(each [_ mushroom (ipairs giant_mushrooms)]
  (table.insert inv_crafts
    {:input  [{:name (.. "loria:" mushroom "_stem") :count 1}]
     :output [{:name "loria:stick"                  :count 6}]}))

(each [grass params (opairs grasses)]
  (if params.variants
    (each [id _ (ipairs params.variants)]
      (table.insert inv_crafts
        {:input  [{:name (.. "loria:" grass "_" id)            :count 20}]
         :output [{:name (.. "loria:" grass "_" id "_pressed") :count 1}]}))
    (table.insert inv_crafts
      {:input  [{:name (.. "loria:" grass) :count 20}]
       :output [{:name (.. "loria:" grass "_pressed") :count 1}]})))