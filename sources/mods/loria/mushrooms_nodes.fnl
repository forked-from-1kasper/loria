(require-macros :useful-macros)

(core.register_node "loria:viridi_petasum_stem"
  {:description "Viridi petasum stem"
   :tiles ["loria_viridi_petasum_stem.png"]
   :groups {:choppy 2}})

(core.register_node "loria:viridi_petasum_body"
  {:description "Viridi petasum body"
   :light_source 3
   :tiles ["loria_viridi_petasum_body.png"]
   :groups {:crumbly 1 :choppy 2 :leaves 1}})

(core.register_node "loria:colossus_stem"
  {:description "Colossus stem"
   :tiles ["loria_colossus_stem.png"]
   :groups {:cracky 2}})

(core.register_node "loria:colossus_body"
  {:description "Colossus body"
   :tiles ["loria_colossus_body.png"]
   :groups {:cracky 2}})

(core.register_node "loria:altitudo_stem"
  {:description "Altitudo stem"
   :tiles ["loria_altitudo_stem.png"]
   :groups {:cracky 1}})

(core.register_node "loria:altitudo_body"
  {:description "Altitudo body"
   :tiles ["loria_altitudo_body.png"]
   :groups {:cracky 1}})

(core.register_node "loria:timor_stem"
  {:description "Timor stem"
   :tiles
     ["loria_timor_stem_slice.png"
      "loria_timor_stem_slice.png"
      "loria_timor_stem.png"
      "loria_timor_stem.png"
      "loria_timor_stem.png"
      "loria_timor_stem.png"]
   :groups {:cracky 2}})

(each [idx name (ipairs timor.body-names)]
  (core.register_node (.. "loria:timor_body_" idx)
    {:description (string.format "Timor body (%s)" name)
     :tiles [(string.format "loria_timor_body_%d.png" idx)]
     :groups {:cracky 2}}))
(core.register_alias "loria:timor_body" "loria:timor_body_1")

(local timor-cids (map core.get_content_id timor.body-nodes))
(defun randtimor []
  (let [idx (math.random 1 timor.colours)]
    (. timor-cids idx)))

(core.register_node "loria:turris_stem"
  {:description "Turris stem"
   :tiles ["loria_turris_stem.png"]
   :groups {:choppy 2}})

(core.register_node "loria:turris_body"
  {:description "Turris body"
   :tiles ["loria_turris_body.png"]
   :groups {:choppy 2}})

(core.register_node "loria:rete_stem"
  {:description "Rete stem"
   :tiles ["loria_rete_stem.png"]
   :groups {:choppy 2}})

(core.register_node "loria:rete_body"
  {:description "Rete body"
   :tiles ["loria_rete_body.png"]
   :groups {:crumbly 1 :choppy 2 :leaves 1}})