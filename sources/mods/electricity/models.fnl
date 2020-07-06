(require-macros :useful-macros)

(defun hash_node_pos [pos]
  (string.format "%d#%d#%d" pos.x pos.y pos.z))

(defun hash_node_connect [A B]
  (let [[pos1 pos2] (if (or (< B.x A.x) (< B.y A.y) (< B.z A.z)) [B A] [A B])]
    (string.format "%s&%s" (hash_node_pos pos1) (hash_node_pos pos2))))

(defun twopole [device name pos value]
  (let [dir    (-> (minetest.get_node pos) (. :param2) minetest.facedir_to_dir)
        input  (->> (vector.subtract pos dir) (hash_node_connect pos))
        output (->> (vector.add pos dir) (hash_node_connect pos))]
    (values {:pos input :neg output :current (.. "v" name)}
      (define-circuit
        device name input (.. "hole-" name) value
        :voltage (.. "v" name) (.. "hole-" name) output (complex 0 0)))))

(fn consumer [ι]
  (fn [pos id]
    (let [meta (minetest.get_meta pos)]
      (->> (ι (meta:get_float :resis))
           (twopole :resistor id pos)))))

(global resistor  (consumer real))
(global capacitor (consumer capacitance))
(global inductor  (consumer inductance))

(defun vsource [pos id]
  (let [meta (minetest.get_meta pos)
        emf (meta:get_float :emf)

        resis (meta:get_float :resis)
        dir (-> (minetest.get_node pos) (. :param2) minetest.facedir_to_dir)

        input (->> (vector.subtract pos dir) (hash_node_connect pos))
        output (->> (vector.add pos dir) (hash_node_connect pos))]
    (values {:pos input :neg output :current id}
      (define-circuit
        :voltage id input (.. "hole-" id) (real emf)
        :resistor (.. "r" id) (.. "hole-" id) output (real resis)))))