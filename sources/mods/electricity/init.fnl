(require-macros :useful-macros)

(global fallback (or (core.settings:get_bool "electricity_fallback") false))

(when (not fallback)
  (local ie (core.request_insecure_environment))
  (when (not ie)
    (error (.. "Electricity mod requires access to insecure functions in order "
               "to work. Please add the electricity mod to your secure.trusted_mods.\n"
               "Insecure functions provide native (fast) complex numbers and arrays, "
               "which are necessary for MNA solver used in electricity mod.\n"
               "If you don’t trust to Loria’s developers or don’t want to use electricity, "
               "you can enable fallback mode for electricity, "
               "in which Loria do not use these untrusted features, "
               "but this can SIGNIFICANTLY reduce performance if map has electronics.\n"
               "This can be done by inserting “electricity_fallback = false” to your minetest.conf "
               "or in Minetest settings.\n\n"
               "BE CAREFUL: Loria exports `ffi.new` and `ffi.metatype` to global namespace, "
               "so they can be unsafely used by other mods.")))

  (local-require ffi)

  (defun metatype [τ mt] (ffi.metatype (ffi.typeof τ) mt))

  (global isctype ffi.istype)
  (global allocate ffi.new))

(import :electricity
  "complex" "matrix" "matrix-solve" "craftitems"
  "models" "functions" "sim" "globalstep"
  "ground" "switch" "battery" "transformer" "infinite"
  "consumer" "photoresistor" "riteg" "wires"
  "accumulator" "lamp" "multimeter" "relay" "amplifier")
