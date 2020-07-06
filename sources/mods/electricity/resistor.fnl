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

(fn number⇒name [x]
  (if (≥ x 1) (tostring x)
      (.. (tostring (/ 1 x)) "inv")))

(fn register-consumer [elem-name elem-model value desc color box tiles]
  (local name (string.format "electricity:%s_%s" elem-name (number⇒name value)))
  (minetest.register_node name
    {:description (string.format "%s (%s)" (capitalization elem-name) desc)
     :tiles
       [(string.format "%s^[colorize:%sf0" tiles.top-bottom color)
        (string.format "%s^[colorize:%sf0" tiles.top-bottom color)
        (string.format "%s^[colorize:%sf0" tiles.side color)
        (string.format "%s^[colorize:%sf0" tiles.side color)
        (string.format "%s^[colorize:%sf0" tiles.connector color)
        (string.format "%s^[colorize:%sf0" tiles.connector color)]
     :paramtype "light"
     :paramtype2 "facedir"

     :groups {:crumbly 3 :conductor 1}

     :drawtype "nodebox"
     :node_box box
     :selection_box box

     :on_construct (set_resis value)
     :on_destruct reset_current})
  (tset model name elem-model))

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
  ;; Resistors
  (register-consumer "resistor" resistor (math.pow 10 exp-power)
    (string.format "%s Ohm" conf.desc) conf.color resistor-box
    {:top-bottom "electricity_resistor.png"
     :side       "electricity_resistor_side.png"
     :connector  "electricity_resistor_connect_side.png"})
  ;; Capacitors
  (register-consumer "capacitor" capacitor (math.pow 10 (- exp-power 9))
    (string.format "%s nF" conf.desc) conf.color capacitor-box
    {:top-bottom "electricity_capacitor.png"
     :side       "electricity_capacitor_side.png"
     :connector  "electricity_capacitor_connect_side.png"}))