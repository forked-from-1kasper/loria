(fn defun [name args ...]
  `(global ,name (fn ,args ,(unpack [...]))))

(fn ffi-proc [name type args ...]
  `(local ,name (ffi.cast ,type (fn ,args ,(unpack [...])))))

(fn local-require [name]
  `(local ,name (ie.require ,(tostring name))))

(fn def-globalstep [args ...]
  `(minetest.register_globalstep (fn ,args ,(unpack [...]))))

(fn table-contains [elem tbl] `(. ,tbl ,elem))
(fn table-not-contains [elem tbl] `(not (. ,tbl ,elem)))
(fn neq [a b] `(~= ,a ,b))

{ :defun defun :local-require local-require
  :∈ table-contains :∉ table-not-contains :≠ neq
  :ffi-proc ffi-proc :def-globalstep def-globalstep }