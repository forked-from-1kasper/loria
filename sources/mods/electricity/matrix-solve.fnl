(require-macros :useful-macros)

(defun swaprows [A i j]
  (for [k 1 A.size.width]
    (let [t (A:get i k)]
      (A:set i k (A:get j k))
      (A:set j k t))))

;; from https://rosettacode.org/wiki/Gaussian_elimination#Python
;; crushes “a” and “b”
(defun linsolve [a b]
  (local n a.size.height)
  (local p b.size.width)

  (for [i 1 n]
    (var k i)

    (for [j (+ i 1) n]
      (when (> (complex.abs (a:get j i))
               (complex.abs (a:get k i)))
        (set k j)))

    (when (≠ k i) (swaprows a i k) (swaprows b i k))
  
    (for [j (+ i 1) n]
      (let [t (/ (a:get j i) (a:get i i))]
        (for [k (+ i 1) n] (-= a j k (* t (a:get i k))))
        (for [k 1 p]       (-= b j k (* t (b:get i k)))))))

  (for [i n 1 -1]
    (for [j (+ i 1) n] (let [t (a:get i j)]
      (for [k 1 p] (-= b i k (* t (b:get j k))))))

    (let [t (a:get i i)] (for [j 1 p] (/= b i j t))))

  b)