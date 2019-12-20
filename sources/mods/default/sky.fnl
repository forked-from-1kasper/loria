(require-macros :useful-macroses)

(local default_color { :r 140 :g 186 :b 250 })
(local night_color { :r 0 :g 0 :b 16 })

(local colors
  { (minetest.get_biome_id "default:redland") { :r 255 :g 200 :b 150 }
    (minetest.get_biome_id "default:purple_swamp") { :r 190 :g 155 :b 255 }
    (minetest.get_biome_id "default:acidic_landscapes") { :r 255 :g 255 :b 100 }
    (minetest.get_biome_id "default:reptile_house") { :r 200 :g 255 :b 100 } })

(local sunrise { :start (/ 4500 24000) :finish (/ 5751 24000) })
(local sunset { :start (/ 18600 24000) :finish (/ 19502 24000) })

(fn brightness [color x]
  { :r (* x color.r)
    :g (* x color.g)
    :b (* x color.b)})

(fn addition [c1 c2]
  { :r (math.min (+ c1.r c2.r) 255)
    :g (math.min (+ c1.g c2.g) 255)
    :b (math.min (+ c1.b c2.b) 255)})

(fn get_sky_color [color timeofday]
  (if (< timeofday sunrise.start)
      (brightness color 0)
      (and (>= timeofday sunrise.start) (< timeofday sunrise.finish))
      (brightness color
        (/ (- timeofday sunrise.start) (- sunrise.finish sunrise.start)))
      (and (>= timeofday sunrise.finish) (< timeofday sunset.start))
      (brightness color 1)
      (and (>= timeofday sunset.start) (< timeofday sunset.finish))
      (brightness color
        (/ (- sunset.finish timeofday) (- sunset.finish sunset.start)))
      ; (>= timeofday >= sunset.finish)
      (brightness color 0)))

(def-globalstep [_]
  (let [timeofday (minetest.get_timeofday)]
    (each [_ player (ipairs (minetest.get_connected_players))]
      (let [pos (player:get_pos)
            color (or (. colors (. (minetest.get_biome_data pos) :biome)) default_color)]
        (player:set_sky (addition (get_sky_color color timeofday) night_color) "plain")))))