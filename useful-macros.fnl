(local fennel (require :fennel))

(fn defun [name args ...]
  `(global ,name (fn ,args ,(unpack [...]))))

(fn ffi-proc [name type args ...]
  `(local ,name (ffi.cast ,type (fn ,args ,(unpack [...])))))

(fn local-require [name]
  `(local ,name (ie.require ,(tostring name))))

(fn callback-register [func]
  (fn [args ...] `(,(sym func) (fn ,args ,(unpack [...])))))

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

(fn alpha-beta-gamma [α β γ X] {:α α :β β :γ γ :X (or X 0)})

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

(fn define-circuit [...]
  (local k (length [...]))
  (local j (/ k 5)) (var res { })

  (assert (= (% k 5) 0) "wrong number of arguments")

  (for [i 1 j] (let [n (* i 5)]
    (tset res i
      {:type  (. [...] (- n 4))
       :name  (. [...] (- n 3))
       :pos   (. [...] (- n 2))
       :neg   (. [...] (- n 1))
       :value (. [...] (- n 0))})))
  res)

(fn unary-macro [φ]
  (fn [res idx]
    (if idx `(tset ,res ,idx (,(sym φ) (. ,res ,idx) 1))
            `(set ,res (,(sym φ) ,res 1)))))

(fn set-op [φ] (fn [x val] `(set ,x (,(sym φ) ,x ,val))))

(fn function-assignment [φ]
  (fn [M i j val]
    `(: ,M :set ,i ,j (,(sym φ) (: ,M :get ,i ,j) ,val))))

(fn compile [ast] (fennel.compile ast {:scope (get-scope) :compiler-env _G}))

(fn early-return [ε] (let [value (gensym)]
  `(lua ,(tostring (compile ε)))))

(fn check-constexpr-value [value]
  (case (type value)
    "function" (error "“function” in constexpr")
    "userdata" (error "“userdata” in constexpr")
    "thread"   (error "“thread” in constexpr")
    "table"    (each [_ v (pairs value)] (check-constexpr-value v))))

(fn get-ident [ε]
  (if (sym? ε) (fennel.mangle (tostring ε))
      (error (string.format "“%s” expected to be an identifier" (view ε)))))

(local lua-load (or loadstring load))

(fn compile-and-load [ast]
  (let [lua-code (compile ast)
        callback (lua-load lua-code)]
    (callback)))

(fn constexpr-emit [tag ε₁ ε₂]
  (tset _G tag ε₁) `(tset _G ,tag ,ε₂))

(fn constexpr-value [E ...]
  (let [tag   (get-ident E)
        ast  `(do ,...)
        value (compile-and-load ast)]
    (check-constexpr-value value)
    (constexpr-emit tag value value)))

(fn constexpr-defun [E ...]
  (let [tag   (get-ident E)
        ast  `(fn ,...)
        value (compile-and-load ast)]
    (constexpr-emit tag value ast)))

(fn constexpr [τ ...]
  (if (= τ `defun) (constexpr-defun ...)
      (constexpr-value τ ...)))

{;; Unicode aliases and syntaxes
 "∈" table-contains "∉" table-not-contains
 "≠" (alias :not=) "∧" (alias :and) "∨" (alias :or)
 "≥" (alias ">=")  "≤" (alias "<=")
 "∃" (quantifier :find "existential")
 "∀" (quantifier :all  "universal")
 "¬" (prefix :not) "−" (prefix "-")
 ;; Some useful macros for defining various functions
 :defun defun :on-mods-loaded on-mods-loaded :ffi-proc ffi-proc
 :def-globalstep (callback-register "minetest.register_globalstep")
 :on-joinplayer  (callback-register "minetest.register_on_joinplayer")
 :on-leaveplayer (callback-register "minetest.register_on_leaveplayer")
 ;; Macros for matrices
 "+=" (function-assignment "+")
 "-=" (function-assignment "-")
 "*=" (function-assignment "*")
 "/=" (function-assignment "/")
 ;; Other
 :local-require local-require :α-β-γ alpha-beta-gamma
 :define-type define-type :first first
 :define-circuit define-circuit
 :incf (unary-macro "+") :set+ (set-op "+")
 :decf (unary-macro "-") :set- (set-op "-")
 :set* (set-op "*") :set/ (set-op "/")
 :return! early-return
 :constexpr constexpr}