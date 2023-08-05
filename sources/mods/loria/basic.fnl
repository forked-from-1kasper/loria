(require-macros :useful-macros)

(defun all [f xs]
  (each [_ x (ipairs xs)]
    (when (¬ f x) (lua "return false")))
  true)

(defun find [f xs]
  (each [_ x (ipairs xs)]
    (when (f x) (lua "return x"))))

(defun contains [arr val]
  (each [_ elem (ipairs arr)]
    (when (= val elem) (lua "return true")))
  false)

(defun funcall [f ...] (f ...))

(defun nope [])