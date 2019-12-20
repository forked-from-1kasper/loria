(fn defun [name args ...]
  `(global ,name (fn ,args ,(unpack [...]))))

{ :defun defun }