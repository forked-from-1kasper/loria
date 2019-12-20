(fn defun [name args ...]
  `(global ,name (fn ,args ,(unpack [...]))))

(fn ffi-proc [name type args ...]
  `(local ,name (ffi.cast ,type (fn ,args ,(unpack [...])))))

(fn local-require [name]
  `(local ,name (ie.require ,(tostring name))))

(fn def-globalstep [args ...]
  `(minetest.register_globalstep (fn ,args ,(unpack [...]))))

{ :defun defun :local-require local-require
  :ffi-proc ffi-proc :def-globalstep def-globalstep }