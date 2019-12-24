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

(fn neq [a b] `(not= ,a ,b))

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

(fn alpha-beta-gamma [α β γ] { :alpha α :beta β :gamma γ })

(fn define-type [name init-func]
  `(do (global ,name {} )
       (tset ,name :__index ,name)
       (setmetatable ,name
          { :__call
            (fn [cls# ...]
              (var inst# {})
              (,init-func cls# inst# ...)
              (setmetatable inst# cls#)
              inst#) })))

{ ;; Unicode aliases and syntaxes
  "∈" table-contains "∉" table-not-contains "≠" neq
  "∃" (quantifier :find "existential")
  "∀" (quantifier :all "universal")
  "¬" (prefix :not)
  ;; Some useful macros for defining various functions
  :defun defun :on-mods-loaded on-mods-loaded
  :ffi-proc ffi-proc :def-globalstep def-globalstep
  ;; Other
  :local-require local-require :α-β-γ alpha-beta-gamma
  :define-type define-type }