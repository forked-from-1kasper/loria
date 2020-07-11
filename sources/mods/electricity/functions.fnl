(require-macros :useful-macros)

(global on_circuit_tick {})

(global quadripole {})
(global consumers {})
(global model {})

(global cable_tick 0.1)

(defun set_resis [R′ X′]
  (let [R (∨ R′ 0) X (∨ X′ 0)]
    (fn [pos] (let [meta (minetest.get_meta pos)]
                (meta:set_float :resis R)
                (meta:set_float :react X)))))

(defun reset_current [pos]
  (var already-processed {})
  (tset already-processed (serialize_pos pos) true)
  (reset_circuits pos already_processed))

(defun reset_consumer [name]
  (fn [pos] (let [meta (minetest.get_meta pos)
                  consumer (. consumers name)]
              (when (∧ (¬ check_current meta consumer)
                        consumer.on_deactivate)
                (consumer.on_deactivate pos)
                (meta:set_int :active 0)))))

(global neighbors
  [(vector.new  1  0  0)
   (vector.new -1  0  0)
   (vector.new  0  0  1)
   (vector.new  0  0 -1)
   (vector.new  0  1  0)
   (vector.new  0 -1  0)])