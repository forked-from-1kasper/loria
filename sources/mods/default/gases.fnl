(require-macros :useful-macros)

(fn organic? [name]
  (or (∃ x ∈ ["default:pars"
              "default:truncus"
              "default:viriditas"
              "default:rami"
              "default:spears"
              "default:naga"
              "default:petite"]
         (starts_with name x))
      (ends_with name "_body")
      (∈ (name:sub (+ (length "default:") 1)) small_mushrooms)))

(fn heavy-organic? [name]
  (ends_with name "_stem"))

(fn fuel? [name]
  (∃ x ∈ ["default:potassium" "default:trisilane"]
     (starts_with name x)))

(local chlorine
  {:name "chlorine"
   :icon "default_chlorine_symbol.png"
   :palette "chlorine_palette.png"
   :post_effect_color {:a 50 :r 210 :g 255 :b 0}
   :destroys organic?
   :heavy true
   :damage 2
   :reactions
     {"default:mercury" {:result "default:mercury_chloride"}
      "default:mercury_source" {:result "default:mercury_chloride"}
      "default:mercury_flowing" {:result "default:mercury_chloride"}
      "default:glow_stick"
        {:result "default:blowed_out_glow_stick"
         :gas    "default:chlorine"}}})

(local oxygen
  {:name "oxygen"
   :icon "default_oxygen_symbol.png"
   :destroys (const false)
   :transparent true
   :damage 0
   :reactions
     {"default:cinnabar"
       {:result "default:mercury"
        :gas    "default:sulfur_dioxide"}
      "furnace:gas_active"
        {:result "furnace:gas_active"
         :gas    "default:fire"}}})

(local hydrogen
  {:name "hydrogen"
   :icon "default_hydrogen_symbol.png"
   :destroys (const false)
   :transparent true
   :damage 0
   :reactions
     {"furnace:gas_active"
       {:result "furnace:gas_active"
        :gas "default:fire"}}})

(local sulfur-dioxide
  {:name "sulfur_dioxide"
   :icon "default_sulfur_dioxide_symbol.png"
   :destroys (const false)
   :heavy true
   :transparent true
   :damage 1
   :reactions {}})

(local fluorine
  {:name "fluorine"
   :icon "default_fluorine_symbol.png"
   :post_effect_color { :a 50 :r 255 :g 251 :b 164}
   :palette "fluorine_palette.png"
   :destroys (fn [name] (or (organic? name) (heavy-organic? name)))
   :heavy true
   :damage 5
   :reactions
     {"default:mercury_oxide"
       {:result "default:mercury_fluoride"
        :gas    "default:oxygen"}
      "default:red_mercury_oxide"
        {:result "default:mercury_fluoride"
         :gas    "default:oxygen"}
      "default:glow_stick"
        {:result "default:blowed_out_glow_stick"
         :gas    "default:fluorine"}}})

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
  {"default:hydrogen"
     {:result "default:fire"
      :gas    "default:fire"}
   "default:oxygen"
     {:result "default:fire"
      :gas    "default:fire"}
   "default:trisilane_source"
     {:result "default:fire"
      :gas    "default:fire"}
   "default:trisilane_flowing"
     {:result "default:fire"
      :gas    "default:fire"}})

(local evaporates
  ["default:red_mercury_oxide"
   "default:mercury_oxide"
   "default:cinnabar"
   "default:copper_sulfate"
   "default:cobalt_blue"
   "default:ammonium_manganese_pyrophosphate"])

(local air {:result "air"})
(each [_ name (ipairs evaporates)]
  (tset fire.reactions name air))

(each [name _ (pairs ores)]
  (tset fire.reactions (.. "default:" name) air)
  (tset fire.reactions (.. "default:" name "_cinnabar") air)
  (tset fire.reactions (.. "default:" name "_azure") air))

(foreach register_gas [chlorine oxygen hydrogen sulfur-dioxide fluorine fire])