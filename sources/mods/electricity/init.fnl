(require-macros :useful-macros)

(local ie (minetest.request_insecure_environment))
(when (not ie)
  (error (.. "Electricity mod requires access to insecure functions in order "
             "to work. Please add the electricity mod to your secure.trusted_mods.")))

(local-require ffi)

(defun metatype [τ mt] (ffi.metatype (ffi.typeof τ) mt))

(global isctype ffi.istype)
(global allocate ffi.new)

(import :electricity
  "complex" "matrix" "matrix-solve"
  "models" "functions" "sim" "globalstep"
  "ground" "switch" "battery"
  "transformer" "infinite" "consumer"
  "riteg" "cables" "accumulator"
  "lamp" "multimeter")