(require-macros :useful-macros)

(global on_circuit_tick {})
(global quadripole {})
(global consumer {})
(global model {})

(global cable_tick 0.1)

(defun set_resis [resis]
  (fn [pos] (let [meta (minetest.get_meta pos)]
              (meta:set_float :resis resis))))

(defun reset_current [pos]
  (var already-processed {})
  (tset already-processed (serialize_pos pos) true)
  (reset_circuits pos already_processed))

(defun reset_consumer [name]
  (fn [pos] (let [meta (minetest.get_meta pos)
                  consumer (. consumer name)]
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