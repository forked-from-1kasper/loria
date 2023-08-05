(require-macros :useful-macros)

(defun all [f xs]
  (each [_ x (ipairs xs)]
    (when (¬ f x) (return! false)))
  true)

(defun find [f xs]
  (each [_ x (ipairs xs)]
    (when (f x) (return! x))))

(defun contains [arr val]
  (each [_ elem (ipairs arr)]
    (when (= val elem) (return! true)))
  false)

(defun funcall [f ...] (f ...))

(defun nope [])