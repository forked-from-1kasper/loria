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

{ :defun defun :local-require local-require
  :∈ table-contains :∉ table-not-contains :≠ neq
  :ffi-proc ffi-proc :def-globalstep def-globalstep
  :on-mods-loaded on-mods-loaded :α-β-γ alpha-beta-gamma
  :define-type define-type }