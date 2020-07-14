(require-macros :useful-macros)

(defun hash_node_pos [pos]
  (string.format "%d#%d#%d" pos.x pos.y pos.z))

(defun hash_node_connect [A B]
  (let [[pos1 pos2] (if (or (< B.x A.x) (< B.y A.y) (< B.z A.z)) [B A] [A B])]
    (string.format "%s&%s" (hash_node_pos pos1) (hash_node_pos pos2))))

(defun dirtwopole [pos]
  (let [dir     (-> (minetest.get_node pos) (. :param2) minetest.facedir_to_dir)
        cross   (vector.cross dir k)
        input   (->> (vector.subtract pos dir) (hash_node_connect pos))
        output  (->> (vector.add pos dir) (hash_node_connect pos))
        control (->> (vector.add pos cross) (hash_node_connect pos))]
    (values input output control)))

(defun twopole [device name pos value]
  (let [(input output) (dirtwopole pos)]
    (values {:pos input :neg output :current (.. "v" name)}
      (define-circuit
        device name input (.. "hole-" name) value
        :voltage (.. "v" name) (.. "hole-" name) output (complex 0 0)))))

(defun consumer [pos id]
  (let [meta (minetest.get_meta pos)
        R  (real (∨ (meta:get_float :resis) 0))
        X′ (∨ (meta:get_float :react) 0)
        X  (if (≥ X′ 0) (inductance X′) (capacitance X′))]
    (twopole :consumer id pos (+ R X))))

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
        :consumer (.. "r" id) (.. "hole-" id) output (real resis)))))

(defun twoport [pos]
  (let [in-pin  (vector.new 1 0 0)
        out-pin (vector.new 0 0 1)
        prim₁   (vector.add pos in-pin)
        prim₂   (vector.add pos out-pin)
        sec₁    (vector.subtract pos in-pin)
        sec₂    (vector.subtract pos out-pin)]
    {:prim₁ (hash_node_connect pos prim₁)
     :prim₂ (hash_node_connect pos prim₂)
     :sec₁  (hash_node_connect pos sec₁)
     :sec₂  (hash_node_connect pos sec₂)}))