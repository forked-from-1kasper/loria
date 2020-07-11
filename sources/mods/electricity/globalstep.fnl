(require-macros :useful-macros)

(defun serialize_pos [pos]
  (string.format "%f,%f,%f" pos.x pos.y pos.z))

(defun deserialize_pos [str]
  (let [(x y z) (str:match "([^,]+),([^,]+),([^,]+)")]
    (vector.new (tonumber x) (tonumber y) (tonumber z))))

(fn drop-current [pos]
  (let [meta (minetest.get_meta pos)]
    (meta:set_float :I  0)
    (meta:set_float :φᵢ 0)
    (meta:set_float :U  0)))

(defun reset_circuits [current already-processed]
  (each [_ vect (ipairs neighbors)]
    (let [pos  (vector.add current vect)
          name (-> (minetest.get_node pos) (. :name))]
      (when (∧ (∨ (> (minetest.get_item_group name :conductor) 0)
                  (> (minetest.get_item_group name :cable) 0))
               (∉ (serialize_pos pos) already-processed))
        (let [meta (minetest.get_meta pos)]
          (meta:set_float :I 0) (meta:set_float :U 0)
          (tset already-processed (serialize_pos pos) true)

          (when (∈ name consumer)
            (-> (minetest.get_node_timer pos) (: :start 0.5)))
          (reset_circuits pos already-processed))))))

(fn measurement-delta [X]
  (if (= X 0) 0 (+ X (/ (math.random) 2))))

(defun check_current [meta consumer]
  (let [I (math.abs (meta:get_float :I))
        U (math.abs (meta:get_float :U))]
    (∧ (≥ I consumer.current.I.min)
       (≤ I consumer.current.I.max)
       (≥ U consumer.current.U.min)
       (≤ U consumer.current.U.max))))

(fn check-consumer [meta consumer]
  (let [active?     (= (meta:get_int :active) 1)
        current-ok? (check_current meta consumer)]
    {:activate   (∧ (not active?) current-ok? consumer.on_activate)
     :deactivate (∧ active? (not current-ok?) consumer.on_deactivate)}))

(fn get-float-by-pos [key]
  (fn [pos] (-> (minetest.get_meta pos) (: :get_float key))))

(local get-emf (get-float-by-pos :emf))
(local get-resis (get-float-by-pos :resis))

(var idx 0)
(fn get-name [] (incf idx) idx)

(fn is-conductor [name]
  (≠ (minetest.get_item_group name :conductor) 0))

(fn is-source [name]
  (≠ (minetest.get_item_group name :source) 0))

(fn find-circuits [pos descriptions connections processed-sources]
  (var res []) (var queue [pos])

  (each [_ current (ipairs queue)]
    (each [_ vect (ipairs neighbors)]
      (let [pos (vector.add current vect)
            name (-> (minetest.get_node pos) (. :name))
            str (serialize_pos pos)]
        (when (∧ (∉ str descriptions) (∉ str processed-sources)
                 (∨ (is-conductor name) (is-source name)))
          (let [(connection desc) ((. model name) pos (get-name))]
            (tset descriptions str desc)
            (tset connections  str connection)

            (when (is-source name) (tset processed-sources str true))
            (when (∈ name consumer)
              (-> (minetest.get_node_timer pos) (: :start 0.5)))

            (drop-current pos) (table.insert queue pos)))))))

(fn set-float [meta name value]
  (if (≠ value value) ; NaN
      (meta:set_float name 0)
      (meta:set_float name (∨ value 0))))

(fn calculate-device [info elapsed]
  (let [meta      (minetest.get_meta info.pos)
        name      (-> (minetest.get_node info.pos) (. :name))
        consumer′ (. consumer name)]
    (set-float meta :I info.I) (set-float meta :φᵢ info.φᵢ)
    (set-float meta :U info.U) (set-float meta :φᵤ info.φᵤ)

    (when consumer′
      (let [actions (check-consumer meta consumer′)]
        (if actions.activate
            (do (consumer′.on_activate info.pos)
                (meta:set_int :active 1))
            actions.deactivate
            (do (consumer′.on_deactivate info.pos)
                (meta:set_int :active 0)))))

    (-?> (. on_circuit_tick name)
         (funcall meta elapsed))))

(fn get-time []
  "Returns gametime in seconds"
  (* (minetest.get_timeofday) 60 60 24))

(fn process-source [pos processed-sources elapsed]
  (var descriptions {}) (var connections {}) (var circ [])
  (local str (serialize_pos pos))
  (local func (. model (-> (minetest.get_node pos) (. :name))))
  (when func
    (let [(connection desc) (func pos (get-name))]
      (tset descriptions str desc)
      (tset connections  str connection)

      (drop-current pos)
      (tset processed-sources str true)

      (find-circuits pos descriptions connections processed-sources)

      (foreach (partial append circ) descriptions)

      (local res (circsolve circ))

      (each [str connection (pairs connections)]
        (let [pos (deserialize_pos str)]
          (var info {:pos pos})
          (when (∈ :current connection)
            (let [I (∨ (. res.currents connection.current) (real 0))]
              (tset info :I (complex.abs I)) (tset info :φᵢ (complex.arg I))))
          (when (∧ (∈ :pos connection) (∈ :neg connection))
            (let [U₁ (∨ (. res.voltages connection.pos) (real 0))
                  U₂ (∨ (. res.voltages connection.neg) (real 0))
                  U  (- U₁ U₂)]
              (tset info :U (complex.abs U)) (tset info :φᵤ (complex.arg U))))
          (calculate-device info elapsed))))))

(fn globalstep [Δt]
  (var processed-sources [])
  (each [str t (pairs sources)]
    (if (≥ Δt t)
      (tset sources str nil)
      (do (tset sources str (- t Δt))
          (when (∉ str processed-sources)
            (process-source (deserialize_pos str) processed-sources Δt)))))
  (set idx 0))

(global sources {})

(minetest.register_abm
  {:label "Enable electrcity sources"
   :nodenames ["group:source"]
   :interval 1
   :chance 1
   :action (fn [pos] (tset sources (serialize_pos pos) 1))})

(local electricity-step 0.5) (var timer 0)
(def-globalstep [Δt]
  (set timer (+ timer Δt))
  (when (≥ timer electricity-step)
    (globalstep timer) (set timer 0)))