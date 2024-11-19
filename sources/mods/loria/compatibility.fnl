(fn alias-default-to-loria [tbl]
  (each [name _ (pairs tbl)]
    (when (starts_with name "loria:")
      (core.register_alias (name:gsub "^loria:" "default:") name))))

(alias-default-to-loria core.registered_items)