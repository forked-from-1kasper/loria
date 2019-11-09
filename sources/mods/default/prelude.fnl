(global comp (fn [f g]
  (fn [x] (f (g x)))))

(global andthen (fn [f g]
  (fn [x] (f x) (g x))))

(global map (fn [f l]
  (var res [])
  (each [_ x (ipairs l)]
    (table.insert res (f x)))
  res))

(global foreach (fn [f l]
  (each [_ x (ipairs l)] (f x))))

(global foreach2 (fn [f l]
  (each [key value (pairs l)] (f key value))))

(global copy (fn [t0]
  (var t {})
  (each [k v (pairs t0)]
    (tset t k v))
  t))

(global const (fn [x] (fn [...] x)))

(global starts_with (fn [str start]
  (= (str:sub 1 (length start)) start)))

(global ends_with (fn [str ending]
  (or (= ending "") (= (str:sub (- (length ending))) ending))))

(global swap_node (fn [pos name]
  (var node (minetest.get_node pos))
  (when (~= node.name name)
    (tset node :name name)
    (minetest.swap_node pos node))))

(global add_or_drop (fn [inv listname stack pos]
  (if (inv:room_for_item listname stack)
      (inv:add_item listname stack)
      (minetest.add_item pos stack))))

(global append (fn [dest source]
  (each [_ x (ipairs source)]
    (table.insert dest x))))

(global capitalization (fn [str]
  (string.gsub (str:gsub "^%l" string.upper) "_" " ")))

(global join (fn [lst1 lst2]
    (var res {})
    (each [idx x (pairs lst1)]
      (tset res idx x))
    (each [idx y (pairs lst2)]
      (tset res idx y))
    res))

(global i (vector.new 1 0 0))
(global j (vector.new 0 0 1))
(global k (vector.new 0 1 0))

(global above (fn [pos] (vector.add pos k)))
(global under (fn [pos] (vector.subtract pos k)))

(global import
  (partial foreach
    (comp dofile (partial .. (minetest.get_modpath :default) "/"))))