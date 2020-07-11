(require-macros :useful-macros)

(define-type matrix
  (λ [cls self n m]
    (let [size (* n m)]
      (set self.data (allocate "complex[?]" size))
      (set self.size {:width m :height n}))))

(fn matrix.idx [self i j]
  (+ (* (- i 1) self.size.width) (- j 1)))

(fn matrix.get [self i j]
  (. self.data (matrix.idx self i (or j 1))))

(fn matrix.set [self i j val]
  (tset self.data (matrix.idx self i (or j 1)) val))

(fn matrix.print [self]
  (for [i 1 self.size.width]
    (for [j 1 self.size.height]
      (io.write (self:get i j) " "))
    (io.write "\n")))