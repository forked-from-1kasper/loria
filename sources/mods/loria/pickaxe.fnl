(require-macros :useful-macros)

(each [material tool-capabilities (pairs pickaxes)]
  (let [texture (.. "loria_" material "_pickaxe.png")
        tool-capabilities-default
          {:full_punch_interval 1.5 :max_drop_level 1
           :groupcaps [] :damage_groups {:fleshy 2}}]
    (core.register_tool (.. "loria:" material "_pickaxe")
      {:description (.. (capitalization material) " pickaxe")
       :stack_max 1 :liquids_pointable false :range 2.0
       :inventory_image texture :wield_image texture
       :tool_capabilities (union tool-capabilities-default tool-capabilities)})))