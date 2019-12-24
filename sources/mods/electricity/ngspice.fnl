(require-macros :useful-macros)

(defun hash_node_pos [pos]
  (string.format "%d#%d#%d" pos.x pos.y pos.z))

(defun hash_node_connect [A B]
  (let [[pos1 pos2] (if (or (< B.x A.x) (< B.y A.y) (< B.z A.z)) [B A] [A B])]
    (string.format "%s&%s" (hash_node_pos pos1) (hash_node_pos pos2))))

(defun two_pole [device pos value]
  (let [dir (-> (minetest.get_node pos) (. :param2) minetest.facedir_to_dir)
        input (->> (vector.subtract pos dir) (hash_node_connect pos))
        output (->> (vector.add pos dir) (hash_node_connect pos))]
    [(table.concat [device input (.. "hole-" device) value] " ")
     (table.concat [(.. "v" device) (.. "hole-" device) output 0] " ")
     (string.format ".measure tran %s-u RMS v(%s)" device input)
     (string.format ".measure tran %s-delta RMS v(%s)" device output)
     (string.format ".measure tran %s-i MAX I(v%s)" device device)]))

(defun resistor [pos id]
  (let [meta (minetest.get_meta pos)
        device-name (.. "r" id)]
    (values (->> (meta:get_float :resis)
                 (two_pole device-name pos))
            device-name)))

(defun dc_source [pos id]
  (let [meta (minetest.get_meta pos)
        emf (meta:get_float :emf)

        resis (meta:get_float :resis)
        dir (-> (minetest.get_node pos) (. :param2) minetest.facedir_to_dir)

        input (->> (vector.subtract pos dir) (hash_node_connect pos))
        output (->> (vector.add pos dir) (hash_node_connect pos))]

  (values [(string.format "v%d %s hole-%d %f" id input id emf)
           (string.format "r%d hole-%d %s %f" id id output resis)
           (string.format ".measure tran v%s-u RMS v(%s)" id input)
           (string.format ".measure tran v%s-delta RMS v(%s)" id output)
           (string.format ".measure tran v%s-i MAX I(v%s)" id id)]
          (.. "v" id))))