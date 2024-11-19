(require-macros :useful-macros)
(require-macros :infix)

(local switch-box
  {:type :fixed
   :fixed [(/ -1 2) (/ -1 2)                (/ -1 2)
           (/  1 2) (infix -1 / 2 + 4 / 16) (/  1 2)]})

(local ground-connect-resis 0.1)

(core.register_node "electricity:ground"
  {:description "Ground"
   :tiles
     ["electricity_ground_top.png"
      "electricity_ground_bottom.png"
      "electricity_ground_side.png"
      "electricity_ground_side.png"
      "electricity_ground_side.png"
      "electricity_ground_connect_side.png"]
   :groups {:crumbly 3 :conductor 1}
   :drawtype "nodebox"
   :paramtype "light"   :paramtype2 "facedir"
   :node_box switch-box :selection_box switch-box
   :on_destruct reset_current
   :use_texture_alpha "blend"})

(tset model "electricity:ground" (fn [pos id]
  (let [dir   (-> (core.get_node pos) (. :param2) core.facedir_to_dir)
        input (->> (vector.subtract pos dir) (hash_node_connect pos))]
    (values {} (define-circuit :consumer id input :gnd ground-connect-resis)))))