(fn alias-default-to-loria [tbl]
  (each [name _ (pairs tbl)]
    (when (starts_with name "loria:")
      (minetest.register_alias (name:gsub "^loria:" "default:") name))))

(foreach alias-default-to-loria
  [minetest.registered_items minetest.registered_nodes
   minetest.registered_craftitems minetest.registered_tools
   minetest.registered_entities])