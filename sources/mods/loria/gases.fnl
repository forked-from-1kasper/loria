(require-macros :useful-macros)

(fn organic? [name]
  (or (∃ x ∈ ["loria:pars"
              "loria:truncus"
              "loria:viriditas"
              "loria:avarum"
              "loria:rami"
              "loria:spears"
              "loria:naga"
              "loria:petite"]
         (starts_with name x))
      (ends_with name "_body")
      (∈ (name:sub (+ (length "loria:") 1)) small_mushrooms)))

(fn heavy-organic? [name]
  (ends_with name "_stem"))

(fn fuel? [name]
  (∃ x ∈ ["loria:potassium" "loria:trisilane"]
     (starts_with name x)))

(local chlorine
  {:name "chlorine"
   :icon "loria_chlorine_symbol.png"
   :palette "chlorine_palette.png"
   :post_effect_color {:a 50 :r 210 :g 255 :b 0}
   :destroys organic?
   :heavy true
   :damage 2
   :reactions
     {"loria:mercury" {:result "loria:mercury_chloride"}
      "loria:mercury_source" {:result "loria:mercury_chloride"}
      "loria:mercury_flowing" {:result "loria:mercury_chloride"}
      "loria:glow_stick"
        {:result "loria:blowed_out_glow_stick"
         :gas    "loria:chlorine"}}})

(local oxygen
  {:name "oxygen"
   :icon "loria_oxygen_symbol.png"
   :destroys (const false)
   :transparent true
   :damage 0
   :reactions
     {"loria:cinnabar"
       {:result "loria:mercury"
        :gas    "loria:sulfur_dioxide"}
      "furnace:gas_active"
        {:result "furnace:gas_active"
         :gas    "loria:fire"}}})

(local hydrogen
  {:name "hydrogen"
   :icon "loria_hydrogen_symbol.png"
   :destroys (const false)
   :transparent true
   :damage 0
   :reactions
     {"furnace:gas_active"
       {:result "furnace:gas_active"
        :gas "loria:fire"}}})

(local sulfur-dioxide
  {:name "sulfur_dioxide"
   :icon "loria_sulfur_dioxide_symbol.png"
   :destroys (const false)
   :heavy true
   :transparent true
   :damage 1
   :reactions {}})

(local fluorine
  {:name "fluorine"
   :icon "loria_fluorine_symbol.png"
   :post_effect_color { :a 50 :r 255 :g 251 :b 164}
   :palette "fluorine_palette.png"
   :destroys (fn [name] (or (organic? name) (heavy-organic? name)))
   :heavy true
   :damage 5
   :reactions
     {"loria:mercury_oxide"
       {:result "loria:mercury_fluoride"
        :gas    "loria:oxygen"}
      "loria:red_mercury_oxide"
        {:result "loria:mercury_fluoride"
         :gas    "loria:oxygen"}
      "loria:glow_stick"
        {:result "loria:blowed_out_glow_stick"
         :gas    "loria:fluorine"}}})

(local fire
  {:name "fire"
   :no_balloon true
   :post_effect_color {:a 150 :r 255 :g 255 :b 255}
   :palette "fire_palette.png"
   :destroys (fn [name]
     (or (organic? name)
         (heavy-organic? name)
         (fuel? name)))
   :damage 10
   :light_source 14
   :alpha 230})

(set fire.reactions
  {"loria:hydrogen"
     {:result "loria:fire"
      :gas    "loria:fire"}
   "loria:oxygen"
     {:result "loria:fire"
      :gas    "loria:fire"}
   "loria:trisilane_source"
     {:result "loria:fire"
      :gas    "loria:fire"}
   "loria:trisilane_flowing"
     {:result "loria:fire"
      :gas    "loria:fire"}})

(local evaporates
  ["loria:red_mercury_oxide"
   "loria:mercury_oxide"
   "loria:cinnabar"
   "loria:copper_sulfate"
   "loria:cobalt_blue"
   "loria:ammonium_manganese_pyrophosphate"])

(local air {:result "air"})
(each [_ name (ipairs evaporates)]
  (tset fire.reactions name air))

(each [name _ (pairs ores)]
  (tset fire.reactions (.. "loria:" name) air)
  (tset fire.reactions (.. "loria:" name "_cinnabar") air)
  (tset fire.reactions (.. "loria:" name "_azure") air))

(foreach register_gas [chlorine oxygen hydrogen sulfur-dioxide fluorine fire])