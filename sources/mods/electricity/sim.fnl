(require-macros :useful-macros)
(global ground "gnd")

(fn calculate-consumer [A b elem g2-index]
  (let [G (/ 1 elem.value)]
    (when (≠ elem.pos 0) (+= A elem.pos elem.pos G))
    (when (≠ elem.neg 0) (+= A elem.neg elem.neg G))
    (when (∧ (≠ elem.pos 0) (≠ elem.neg 0))
      (-= A elem.pos elem.neg G)
      (-= A elem.neg elem.pos G))))

(fn calculate-voltage [A b elem g2-index]
  (when (≠ elem.pos 0)
    (+= A elem.pos g2-index 1)
    (+= A g2-index elem.pos 1))

  (when (≠ elem.neg 0)
    (-= A elem.neg g2-index 1)
    (-= A g2-index elem.neg 1))

  (b:set g2-index 1 elem.value))

(fn calculate-current [A b elem g2-index]
  (when (≠ elem.pos 0) (-= b elem.pos 1 elem.value))
  (when (≠ elem.neg 0) (+= b elem.neg 1 elem.value)))

(local one-port ["pos" "neg"])
(local circuit-models
  {:consumer    {:handler calculate-consumer :needs-current? false
                 :ports one-port             :voltage-index  0}
   :current     {:handler calculate-current  :needs-current? false
                 :ports one-port             :voltage-index  0}
   :voltage     {:handler calculate-voltage  :needs-current? true
                 :ports   one-port           :voltage-index  1}})

(define-type node-table
  (λ [cls self]
    (set self.nodes         {ground 0})
    (set self.node-count    0)
    (set self.components    0)

    (each [model-name _ (pairs circuit-models)]
      (tset self model-name 0))))

(fn node-table.add-to-nodes [self node-str]
  (when (∉ node-str self.nodes)
    (incf self.node-count)
    (tset self.nodes node-str self.node-count))
  (. self.nodes node-str))

(fn map-nodes [circ]
  (local tbl (node-table))

  (each [_ elem (ipairs circ)]
    (incf tbl.components)
    ;; Sets tbl.voltage, tbl.current etc
    (incf tbl elem.type)
    (let [model (. circuit-models elem.type)]
      (each [_ port (ipairs model.ports)]
        (tset elem port (tbl:add-to-nodes (. elem port))))))

  tbl)

(fn solve-aux [tbl circ]
  (var g2-count 0)
  (each [model-name model (pairs circuit-models)]
    (set+ g2-count (* (. tbl model-name) model.voltage-index)))

  (let [matrix-size (+ tbl.node-count g2-count)]
    (var A (matrix matrix-size matrix-size))
    (var b (matrix matrix-size 1))

    (var g2-index (+ tbl.node-count 1))

    ;; generate A and b
    (each [_ elem (ipairs circ)]
      (let [model (. circuit-models elem.type)]
        (model.handler A b elem g2-index)
        (when model.needs-current? (set elem.current-index g2-index))
        (set g2-index (+ model.voltage-index g2-index))))

    ;; Ax = b ⇒ x = A⁻¹ × b
    (local solution (linsolve A b))

    (var res {:voltages {} :currents {}})
    ;; make “node — voltage” table
    (each [name pin (pairs tbl.nodes)]
      (let [v (or (solution:get pin 1) (real 0))]
        (tset res.voltages name v)))
    (tset res.voltages ground (real 0))

    ;; make “source — current” table
    (each [id elem (ipairs circ)]
      (when (≠ elem.current-index nil)
        (tset res.currents elem.name
          (solution:get elem.current-index 1))))

    res))

(defun circsolve [circ] (solve-aux (map-nodes circ) circ))