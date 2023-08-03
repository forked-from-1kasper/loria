(require-macros :useful-macros)

(fn get-tint-img [color]
  (string.format "blind.png^[colorize:%s:255^[opacity:%d"
    (minetest.rgba color.r color.g color.b) color.a))

(fn get-or-default [meta key default]
  (if (meta:contains key)
      (meta:get_string key)
      default))

(defun tint [player color]
  (let [meta        (player:get_meta)
        screen-tint (meta:get_int "tint")
        img         (get-tint-img color)]
    (meta:set_string "tint-image" img)
    (player:hud_change screen-tint "text" img)))

(global transparent {:r 255 :g 255 :b 255 :a 0})

(minetest.register_on_joinplayer (fn [player]
  (let [meta (player:get_meta)
        img  (get-or-default meta "tint-image" (get-tint-img transparent))]
    (meta:set_int "tint"
      (player:hud_add
        {:hud_elem_type "image"   :position {:x 0.5 :y 0.5}
         :scale {:x -101 :y -101} :text img :z_index -1000})))))