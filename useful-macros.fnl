(fn defun [name args ...]
  `(global ,name (fn ,args ,(unpack [...]))))

(fn ffi-proc [name type args ...]
  `(local ,name (ffi.cast ,type (fn ,args ,(unpack [...])))))

(fn local-require [name]
  `(local ,name (ie.require ,(tostring name))))

(fn def-globalstep [args ...]
  `(minetest.register_globalstep (fn ,args ,(unpack [...]))))

(fn on-mods-loaded [...]
  `(minetest.register_on_mods_loaded (fn [] ,(unpack [...]))))

(fn table-contains [elem tbl] `(. ,tbl ,elem))
(fn table-not-contains [elem tbl] `(not (. ,tbl ,elem)))

(fn alias [func-name]
  (fn [...] `(,(sym func-name) ,(unpack [...]))))

(fn check-symbol [s val]
  (and (sym? s) (= (tostring s) val)))

(fn quantifier [func-name name]
  (fn [x sep X P]
    (assert (sym? x)
            (.. "‘" (tostring x) "’" " is not a symbol"))
    (assert (check-symbol sep "∈")
            (.. "invalid " name " quantifier syntax"))
    `(,(sym func-name) (fn [,x] ,P) ,X)))

(fn prefix [func-name]
  (fn [...] `(,(sym func-name) ,(list (unpack [...])))))

(fn first [...] `(. ,(list (unpack [...])) 1))

(fn alpha-beta-gamma [α β γ] {:alpha α :beta β :gamma γ})

(fn define-type [name init-func]
  `(do (global ,name {} )
       (tset ,name :__index ,name)
       (setmetatable ,name
          {:__call
           (fn [cls# ...]
             (var inst# {})
             (,init-func cls# inst# ...)
             (setmetatable inst# cls#)
             inst#)})))

(fn incf [x] `(set ,x (+ ,x 1)))
(fn decf [x] `(set ,x (- ,x 1)))

{;; Unicode aliases and syntaxes
 "∈" table-contains "∉" table-not-contains
 "≠" (alias :not=) "∧" (alias :and) "∨" (alias :or)
 "≥" (alias ">=")  "≤" (alias "<=")
 "∃" (quantifier :find "existential")
 "∀" (quantifier :all  "universal")
 "¬" (prefix :not) "−" (prefix "-")
 ;; Some useful macros for defining various functions
 :defun defun :on-mods-loaded on-mods-loaded
 :ffi-proc ffi-proc :def-globalstep def-globalstep
 ;; Other
 :local-require local-require :α-β-γ alpha-beta-gamma
 :define-type define-type :first first
 :incf incf :decf decf}