(require-macros :useful-macros)

(local default-color {:r 140 :g 186 :b 250})
(local night-color   {:r 0 :g 0 :b 16})

(local change-distance (or (minetest.settings:get "sky_color_change_distance") 4))
(local area-side (+ (* change-distance 2) 1))
(local area-volume (^ area-side 3))

(local biome-id minetest.get_biome_id)

(local colors
  {(biome-id "loria:redland")           {:r 255 :g 200 :b 150}
   (biome-id "loria:purple_swamp")      {:r 190 :g 155 :b 255}
   (biome-id "loria:swamp_connector")   {:r 190 :g 155 :b 255}
   (biome-id "loria:acidic_landscapes") {:r 255 :g 255 :b 100}
   (biome-id "loria:reptile_house")     {:r 200 :g 255 :b 100}})

(local sunrise {:start (/ 4500  24000) :finish (/ 5751  24000)})
(local sunset  {:start (/ 18600 24000) :finish (/ 19502 24000)})

(fn brightness [color x]
  {:r (* x color.r)
   :g (* x color.g)
   :b (* x color.b)})

(fn addition [c1 c2]
  {:r (math.min (+ c1.r c2.r) 255)
   :g (math.min (+ c1.g c2.g) 255)
   :b (math.min (+ c1.b c2.b) 255)})

(fn get-sky-color [color timeofday]
  (if (< timeofday sunrise.start)
      (brightness color 0)
      (∧ (≥ timeofday sunrise.start) (< timeofday sunrise.finish))
      (brightness color
        (/ (- timeofday sunrise.start) (- sunrise.finish sunrise.start)))
      (∧ (≥ timeofday sunrise.finish) (< timeofday sunset.start))
      (brightness color 1)
      (∧ (≥ timeofday sunset.start) (< timeofday sunset.finish))
      (brightness color
        (/ (- sunset.finish timeofday) (- sunset.finish sunset.start)))
      (≥ timeofday sunset.finish)
      (brightness color 0)))

(fn get-color-at-pos [pos]
  (or (. colors (. (minetest.get_biome_data pos) :biome)) default-color))

(fn calc-color [pos]
  (var color {:r 0 :g 0 :b 0})
  (for [x (- pos.x change-distance) (+ pos.x change-distance)]
    (for [y (- pos.y change-distance) (+ pos.y change-distance)]
      (for [z (- pos.z change-distance) (+ pos.z change-distance)]
        (let [color′ (get-color-at-pos {:x x :y y :z z})]
          (tset color :r (+ color.r color′.r))
          (tset color :g (+ color.g color′.g))
          (tset color :b (+ color.b color′.b))))))
  (brightness color (/ 1 area-volume)))

(def-globalstep [_]
  (let [timeofday (minetest.get_timeofday)]
    (each [_ player (ipairs (minetest.get_connected_players))]
      (let [pos (player:get_pos)
            color′ (calc-color pos)
            color (addition (get-sky-color color′ timeofday) night-color)]
        (player:set_sky {:base_color color :type "plain"})))))