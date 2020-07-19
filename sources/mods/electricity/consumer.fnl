(require-macros :useful-macros)
(require-macros :infix)

(local resistor-box
  {:type "fixed"
   :fixed
     [[(/ -3 16) (/ -1 2)                (/ -1 2)
       (/  3 16) (infix -1 / 2 + 6 / 16) (/  1 2)]]})

(local capacitor-box
  {:type "fixed"
   :fixed
     [[(/ -3 16) (/ -1 2) (/ -1 2)
       (/  3 16) (/  1 2) (/  1 2)]]})

(fn register-consumer [conf]
  (local name (string.format "electricity:%s_%s" conf.elem-name conf.idx))
  (minetest.register_node name
    {:description (string.format "%s (%s)" (capitalization conf.elem-name) conf.desc)
     :tiles
       [(string.format "%s^[colorize:%sf0" conf.tiles.top-bottom conf.color)
        (string.format "%s^[colorize:%sf0" conf.tiles.top-bottom conf.color)
        (string.format "%s^[colorize:%sf0" conf.tiles.side conf.color)
        (string.format "%s^[colorize:%sf0" conf.tiles.side conf.color)
        (string.format "%s^[colorize:%sf0" conf.tiles.connector conf.color)
        (string.format "%s^[colorize:%sf0" conf.tiles.connector conf.color)]
     :paramtype "light" :paramtype2 "facedir"

     :groups {:crumbly 3 :conductor 1} :drawtype "nodebox"
     :node_box conf.box :selection_box conf.box

     :on_construct (set_resis conf.R conf.X)
     :on_destruct reset_current})
  (tset model name consumer))

(local color-code
  {-2 {:color "#cccccc" :desc "0.01"}
   -1 {:color "#baa932" :desc "0.1" }
    0 {:color "#3684ff" :desc "1"   }
    1 {:color "#663333" :desc "10"  }
    2 {:color "#ff0000" :desc "100" }
    3 {:color "#ff6600" :desc "1K"  }
    4 {:color "#ffff00" :desc "10K" }
    5 {:color "#33cc33" :desc "100K"}
    6 {:color "#6666ff" :desc "1M"  }
    7 {:color "#cc66ff" :desc "10M" }})

(each [exp-power conf (pairs color-code)]
  (let [idx (+ exp-power 2)]
    ;; Resistors
    (register-consumer
      {:elem-name "resistor" :R (math.pow 10 exp-power)
       :desc (string.format "%s Ohm" conf.desc) :color conf.color
       :box resistor-box :idx idx
       :tiles {:top-bottom "electricity_resistor.png"
               :side       "electricity_resistor_side.png"
               :connector  "electricity_resistor_connect_side.png"}})
    ;; Capacitors
    (register-consumer
      {:elem-name "capacitor" :X (math.pow 10 (- exp-power 9))
       :desc (string.format "%s nF" conf.desc) :color conf.color
       :box capacitor-box :idx idx
       :tiles {:top-bottom "electricity_capacitor.png"
               :side       "electricity_capacitor_side.png"
               :connector  "electricity_capacitor_connect_side.png"}})))

(local heavy-inductance 1)
(local heavy-inductor-box
  (let [α (infix -1 / 2 + 2 / 16)
        β (infix  1 / 2 - 2 / 16)]
    {:type "fixed"
     :fixed [[(/ -1 2) (/ -1 2) (/ -1 2) (/ 1 2) α       (/ 1 2)]
             [(/ -1 2) β        (/ -1 2) (/ 1 2) (/ 1 2) (/ 1 2)]
             [α        α        α        β       β       β]]}))

(minetest.register_node "electricity:heavy_inductor"
  {:description "Heavy inductor (1 H)"
   :tiles ["electricity_heavy_inductor_top_bottom.png"
           "electricity_heavy_inductor_top_bottom.png"
           "electricity_heavy_inductor.png"
           "electricity_heavy_inductor.png"
           "electricity_heavy_inductor_connect_side.png"
           "electricity_heavy_inductor_connect_side.png"]
   :paramtype "light" :paramtype2 "facedir"
   :groups {:crumbly 3 :conductor 1} :drawtype "nodebox"
   :node_box heavy-inductor-box :selection_box heavy-inductor-box

   :on_construct (set_resis 0 1) :on_destruct reset_current})
(tset model "electricity:heavy_inductor" consumer)