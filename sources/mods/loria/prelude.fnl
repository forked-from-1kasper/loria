(require-macros :useful-macros)

(defun comp [f g]
  (fn [x] (f (g x))))

(defun andthen [f g]
  (fn [x] (f x) (g x)))

(defun map [f l]
  (var res {})
  (each [key val (pairs l)]
    (tset res key (f val)))
  res)

(defun imap [f l]
  (var res [])
  (each [key val (ipairs l)]
    (tset res key (f key val)))
  res)

(defun foreach [f l]
  (each [_ x (pairs l)] (f x)))

(defun iforeach [f l]
  (each [id x (ipairs l)] (f id x)))

(defun foreach2 [f l]
  (each [key value (pairs l)] (f key value)))

(defun copy [t₀]
  (var t {})
  (each [k v (pairs t₀)] (tset t k v))
  t)

(defun const [x] (fn [...] x))

(defun starts_with [str start]
  (= (str:sub 1 (length start)) start))

(defun ends_with [str ending]
  (or (= ending "") (= (str:sub (- (length ending))) ending)))

(defun swap_node [pos name]
  (var node (minetest.get_node pos))
  (when (≠ node.name name)
    (tset node :name name)
    (minetest.swap_node pos node)))

(defun add_or_drop [inv listname stack pos]
  (if (inv:room_for_item listname stack)
      (inv:add_item listname stack)
      (minetest.add_item pos stack)))

(defun append [dest source]
  (each [_ x (ipairs source)]
    (table.insert dest x)))

(defun capitalization [str]
  (string.gsub (str:gsub "^%l" string.upper) "_" " "))

(defun union [lst₁ lst₂]
  (var res {})
  (each [id x (pairs lst₁)] (tset res id x))
  (each [id y (pairs lst₂)] (tset res id y))
  res)

(defun join [sep ...]
  (table.concat [...] sep))

(global i (vector.new 1 0 0))
(global j (vector.new 0 0 1))
(global k (vector.new 0 1 0))

(defun above [pos] (vector.add pos k))
(defun under [pos] (vector.subtract pos k))

(defun import [mod ...]
  (let [modpath (minetest.get_modpath mod)
        get-path (fn [name] (.. modpath "/" name ".lua"))]
    (foreach (comp dofile get-path) [...])))

;;; from http://lua-users.org/wiki/SortedIteration

(fn gen-ordered-index [t]
  (var ordered-index [])
  (each [key _ (pairs t)]
    (table.insert ordered-index key))
  (table.sort ordered-index)

  ordered-index)

(defun onext [t state]
  (var key nil)

  (if (= state nil)
    (do (tset t :ordered-index (gen-ordered-index t))
        (set key (. t.ordered-index 1)))
    (for [i 1 (length t.ordered-index)]
      (when (= (. t.ordered-index i) state)
        (set key (. t.ordered-index (+ i 1))))))

  (if key (values key (. t key))
          (tset t :ordered-index nil)))

(defun opairs [t] (values onext t nil))

(defun plus  [x y] (+ x y))
(defun minus [x y] (- x y))

(defun range [iₘₐₓ]
  (var res [])
  (for [i 1 iₘₐₓ] (table.insert res i))
  res)