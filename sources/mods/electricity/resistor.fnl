(require-macros :infix)

(local resistor-box
  {:type "fixed"
   :fixed
     [[(/ -3 16) (/ -1 2)                (/ -1 2)
       (/  3 16) (infix -1 / 2 + 6 / 16) (/  1 2)]]})

(fn register-resistor [resis desc color]
  (minetest.register_node (.. "electricity:resistor_" resis)
    {:description (string.format "Resistor (%s)" desc)
     :tiles
       [(string.format "electricity_resistor.png^[colorize:%sf0" color)
        (string.format "electricity_resistor.png^[colorize:%sf0" color)
        (string.format "electricity_resistor_side.png^[colorize:%sf0" color)
        (string.format "electricity_resistor_side.png^[colorize:%sf0" color)
        (string.format "electricity_resistor_connect_side.png^[colorize:%sf0" color)
        (string.format "electricity_resistor_connect_side.png^[colorize:%sf0" color)]
     :paramtype "light"
     :paramtype2 "facedir"

     :drop (.. "electricity:resistor_" resis)
     :groups {:crumbly 3 :conductor 1}

     :drawtype "nodebox"
     :node_box resistor-box
     :selection_box resistor-box

     :on_construct (set_resis resis)
     :on_destruct reset_current})
  (tset model (.. "electricity:resistor_" resis) resistor))

(register_resistor 1        "1 Ohm"    "#3684ff")
(register_resistor 10       "10 Ohm"   "#663333")
(register_resistor 100      "100 Ohm"  "#ff0000")
(register_resistor 1000     "1K Ohm"   "#ff6600")
(register_resistor 10000    "10K Ohm"  "#ffff00")
(register_resistor 100000   "100K Ohm" "#33cc33")
(register_resistor 1000000  "1M Ohm"   "#6666ff")
(register_resistor 10000000 "10M Ohm"  "#cc66ff")