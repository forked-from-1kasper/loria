(fn ∈ [elem tbl] (. tbl elem))
(fn ∉ [elem tbl] (not (. tbl elem)))

(fn operator? [elem prec]
  (and (sym? elem)
       (∈ (tostring elem) prec)))

(fn non-empty? [arr] (> (length arr) 0))
(fn first [arr] (. arr 1))

(fn process-operator [out stack]
  (let [f (table.remove stack)
        y (table.remove out)
        x (table.remove out)]
  (table.insert out [f x y])))

(fn map [f l]
  (var res {})
  (each [key val (pairs l)]
    (tset res key (f val)))
  res)

(fn get-prec [prec expr]
  (. prec (tostring expr)))

(fn shunting-yard [prec exprs]
  (assert (non-empty? exprs) "expression must be non-empty")
  (var out []) (var stack [])

  (each [_ expr (ipairs exprs)]
    (if (operator? expr prec)
        (do (while (and (non-empty? stack)
                        (<= (get-prec prec (first stack))
                            (get-prec prec expr)))
              (process-operator out stack))
            (table.insert stack expr))
        (list? expr) (table.insert out (shunting-yard prec expr))
        (table.insert out expr)))
  (while (non-empty? stack)
    (process-operator out stack))

  (if (= (length out) 1) (first out) out))

(fn list-to-expr [x]
  (if (table? x)
      (list (unpack (map list-to-expr x))) x))

(local operator-precedence
  { "^"    4   "%"  5
    "*"    5   "/"  5
    "+"    6   "-"  6
    "<"    8   ">"  8
    "<="   8   "≤"  8
    ">="   8   "≥"  8
    "="    9   "~=" 9
    "not=" 9   "≠"  9
    "and"  13  "∧"  13
    "or"   14  "∨"  14
    "∈"    15  "∉"  15 })

(fn infix [...] (list-to-expr (shunting-yard operator-precedence [...])))

{ :infix infix }