(require-macros :useful-macros)

(fn number? [x] (= (type x) :number))

(global complex {})
(setmetatable complex {:__call (fn [cls x y] (complex.τ x y))})

(fn complex.both [z]
  (if (number? z) (values z 0)
      (isctype complex.τ z) (values (. z 0) (. z 1))
      (error "expected number/complex")))

(fn complex.__add [z₁ z₂]
  (let [(a b) (complex.both z₁) (c d) (complex.both z₂)]
    (complex (+ a c) (+ b d))))

(fn complex.__sub [z₁ z₂]
  (let [(a b) (complex.both z₁) (c d) (complex.both z₂)]
    (complex (- a c) (- b d))))

(fn complex.__mul [z₁ z₂]
  (let [(a b) (complex.both z₁) (c d) (complex.both z₂)]
    (complex (- (* a c) (* b d)) (+ (* b c) (* a d)))))

(fn complex.__div [z₁ z₂]
  (let [(a b) (complex.both z₁) (c d) (complex.both z₂)
        den (+ (^ c 2) (^ d 2))]
    (complex (/ (+ (* a c) (* b d)) den)
             (/ (- (* b c) (* a d)) den))))

(fn complex.__unm [z] (let [(a b) (complex.both z)]
  (complex (- a) (- b))))
(fn complex.__eq [z₁ z₂]
  (let [(a b) (complex.both z₁)
        (c d) (complex.both z₂)]
    (∧ (= a c) (= b d))))

(fn complex.__pow [z n]
  (let [|z|  (complex.abs z)
        |z|ⁿ (^ |z| n)
         φ   (complex.arg z)]
    (complex (* |z|ⁿ (math.cos (* n φ)))
             (* |z|ⁿ (math.sin (* n φ))))))

(tset complex "τ" (metatype :complex complex))

(fn complex.inv [z] (/ 1 z))
(fn complex.conj [z] (complex z.re (- z.im)))

(fn complex.arg [z] (math.atan2 z.im z.re))
(fn complex.abs [z] (math.sqrt (+ (^ z.re 2) (^ z.im 2))))

(fn angular-freq [T] (/ (* 2 math.pi) T))

;; All sources are 50 Hz AC sources due to lack of author’s mind.
;; However, it is not so important for the game.
(local ω (angular-freq 50))

(defun real [R] (complex R 0))
(defun inductor  [L] (complex 0 (* ω L)))
(defun capacitor [C] (complex 0 (/ (- 1) (* ω C))))