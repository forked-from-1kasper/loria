(require-macros :useful-macros)

(global bucket {:is_bucket {} :liquids {}})

(minetest.register_craftitem "loria:bucket_empty"
  {:inventory_image "bucket.png"
   :description "Empty bucket"
   :stack_max 1
   :liquids_pointable true
   :on_use (λ [itemstack user pointed_thing]
       (when (= pointed_thing.type "node")
         (let [n (minetest.get_node pointed_thing.under)
               liquiddef (. bucket.liquids n.name)]
           (when (∧ (≠ liquiddef nil)
                    (= liquiddef.source n.name)
                    (∈ :itemname liquiddef))
             (minetest.add_node pointed_thing.under {:name "air"})
             {:name liquiddef.itemname :wear (itemstack:get_wear)}))))})

(each [name params (pairs liquids)]
  (let [source   (.. "loria:" name "_source")
        flowing  (.. "loria:" name "_flowing")
        itemname (.. "loria:bucket_" name)]
    (minetest.register_node source
      {:description (.. (capitalization name) " source")
       :drawtype "liquid"
       :tiles
         [{:name params.animated_texture
           :backface_culling false
           :animation
             {:type "vertical_frames"
              :aspect_w 16
              :aspect_h 16
              :length 2.0}}
          {:name params.animated_texture
           :backface_culling true
           :animation
             {:type "vertical_frames"
              :aspect_w 16
              :aspect_h 16
              :length 2.0}}]
       :alpha params.alpha
       :paramtype "light"
       :walkable false
       :pointable false
       :diggable false
       :buildable_to true
       :is_ground_content false
       :drop ""
       :drowning 1
       :light_source (or params.light_source 0)
       :liquidtype "source"
       :liquid_renewable false
       :liquid_alternative_flowing flowing
       :liquid_alternative_source source
       :liquid_viscosity params.liquid_viscosity
       :post_effect_color params.post_effect_color
       :damage_per_second (or params.damage_per_second 0)
       :groups {:liquid 3 :not_in_creative_inventory 1}})

    (minetest.register_node flowing
      {:description (.. "Flowing " name)
       :drawtype "flowingliquid"
       :tiles [params.texture]
       :special_tiles
         [{:name params.animated_flowing_texture
           :backface_culling false
           :animation
             {:type "vertical_frames"
              :aspect_w 16
              :aspect_h 16
              :length 0.8}}
          {:name params.animated_flowing_texture
           :backface_culling true
           :animation
             {:type "vertical_frames"
              :aspect_w 16
              :aspect_h 16
              :length 0.8}}]
       :alpha params.alpha
       :paramtype "light"
       :paramtype2 "flowingliquid"
       :walkable false
       :pointable false
       :diggable false
       :buildable_to true
       :is_ground_content false
       :drop ""
       :drowning 1
       :light_source (or params.light_source 0)
       :liquidtype "flowing"
       :liquid_renewable false
       :liquid_alternative_flowing flowing
       :liquid_alternative_source source
       :liquid_viscosity params.liquid_viscosity
       :post_effect_color params.post_effect_color
       :damage_per_second (or params.damage_per_second 0)
       :groups {:liquid 3 :not_in_creative_inventory 1}})

    (tset bucket.liquids source
      {:source source
       :flowing flowing
       :itemname itemname})
    (tset bucket.liquids flowing (. bucket.liquids source))
    (tset bucket.is_bucket itemname true)

    ((if params.is_fuel minetest.register_tool minetest.register_craftitem)
      itemname
      {:description params.bucket_description
       :inventory_image params.bucket_image
       :stack_max 1
       :liquids_pointable true
       :on_use
         (λ [itemstack user pointed_thing]
           (when (= pointed_thing.type "node")
             (let [n (minetest.get_node pointed_thing.under)]
               (if (∉ n.name bucket.liquids)
                   (minetest.add_node pointed_thing.above {:name source})
                   (≠ n.name source)
                   (minetest.add_node pointed_thing.under {:name source})
                   (nope))
               {:name "loria:bucket_empty" :wear (itemstack:get_wear)})))})))