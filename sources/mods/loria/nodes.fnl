(require-macros :useful-macros)

(core.register_node "loria:test"
  {:description "For tests only"
   :tiles       ["loria_test.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:infinite_oxygen"
  {:description "Infinite oxygen"
   :tiles       ["loria_test.png^[colorize:#0000ff50"]
   :groups      {:crumbly 3}})

(core.register_node "loria:silicon"
  {:description "Silicon (Si)"
   :tiles       ["loria_silicon.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:magnesium_silicide"
  {:description "Magnesium silicide (Mg2Si)"
   :tiles       ["loria_magnesium_silicide.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:magnesium_oxide"
  {:description "Magnesium oxide (MgO)"
   :tiles       ["loria_magnesium_oxide.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:potassium_manganate"
  {:description "Potassium manganate (K2MnO4)"
   :tiles       ["loria_potassium_manganate.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:aluminium_oxide"
  {:description "Aluminium (III) oxide (Al2O3)"
   :tiles       ["loria_aluminium_oxide.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:manganese_dioxide"
  {:description "Manganese dioxide (MnO2)"
   :tiles       ["loria_manganese_dioxide.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:manganese_oxide"
  {:description "Manganese oxide (MnO)"
   :tiles       ["loria_manganese_oxide.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:ammonium_manganese_pyrophosphate"
  {:description "Ammonium manganese (III) pyrophosphate"
   :tiles       ["loria_ammonium_manganese_pyrophosphate.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:cinnabar"
  {:description "Cinnabar (HgS)"
   :tiles       ["loria_cinnabar.png"]
   :groups      {:cracky 2}})

(core.register_node "loria:copper_oxide"
  {:description "Copper (II) oxide (CuO)"
   :tiles       ["loria_copper_oxide.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:copper_sulfate_pure"
  {:description "Copper (II) sulfate (CuSO4)"
   :tiles       ["loria_copper_sulfate_pure.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:copper_sulfate"
  {:description "Copper (II) sulfate pentahydrate (CuSO4 * 5H2O)"
   :tiles       ["loria_copper_sulfate.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:mercury"
  {:description "Mercury (Hg)"
   :tiles       ["loria_mercury.png"]
   :groups      {:cracky 2}})

(core.register_node "loria:uranium"
  {:description "Uranium (U)"
   :tiles       ["loria_uranium.png"]
   :groups      {:cracky 1 :conductor 1}})

(core.register_node "loria:lead"
  {:description "Lead (Pb)"
   :tiles       ["loria_lead.png"]
   :groups      {:cracky 1 :conductor 1}})

(core.register_node "loria:brick"
  {:description "Ceramic brick"
   :tiles       ["loria_brick.png"]
   :groups      {:cracky 2}})

(core.register_node "loria:lead_case"
  {:description "Lead case"
   :tiles       ["loria_lead_case.png"]
   :groups      {:cracky 2}})

(core.register_node "loria:mercury_chloride"
  {:description "Mercury (II) chloride (HgCl2)"
   :tiles       ["loria_mercury_chloride.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:zinc_chloride"
  {:description "Zinc chloride (ZnCl2)"
   :tiles       ["loria_zinc_chloride.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:aluminium_chloride"
  {:description "Aluminium chloride (AlCl3)"
   :tiles       ["loria_aluminium_chloride.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:potassium_chloride"
  {:description "Potassium chloride (KCl)"
   :tiles       ["loria_potassium_chloride.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:mercury_fluoride"
  {:description "Mercury (II) fluoride (HgF2)"
   :tiles       ["loria_mercury_fluoride.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:lead_sulfate"
  {:description "Lead (II) sulfate (PbSO4)"
   :tiles       ["loria_lead_sulfate.png"]
   :groups      {:crumbly 1}
})

(core.register_node "loria:lead_selenide"
  {:description "Lead (II) selenide (PbSe)"
   :tiles       ["loria_lead_selenide.png"]
   :groups      {:cracky 1}})

(core.register_node "loria:selenium"
  {:description "Selenium (Se)"
   :tiles       ["loria_selenium.png"]
   :groups      {:crumbly 1}})

(core.register_node "loria:sodium_peroxide"
  {:description "Sodium peroxide (Na2O2)"
   :tiles       ["loria_sodium_peroxide.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:sodium_oxide"
  {:description "Sodium oxide (Na2O)"
   :tiles       ["loria_sodium_oxide.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:cobalt_sulfate"
  {:description "Cobalt sulfate (CoSO4)"
   :tiles       ["loria_cobalt_sulfate.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:chromia"
  {:description "Chromium (III) oxide (Cr2O3)"
   :tiles       ["loria_chromia.png"]
   :groups      {:crumbly 1}})

(core.register_node "loria:chromium_trioxide"
  {:description "Chromium trioxide (CrO3)"
   :tiles       ["loria_chromium_trioxide.png"]
   :groups      {:cracky 2}})

(core.register_node "loria:chromic_chloride"
  {:description "Chromium (III) chloride (CrCl3)"
   :tiles       ["loria_chromic_chloride.png"]
   :groups      {:cracky 2}})

(core.register_node "loria:chromium"
  {:description "Chromium (Cr)"
   :tiles       ["loria_chromium.png"]
   :groups      {:cracky 1}})

(core.register_node "loria:nickel_nitrate"
  {:description "Nickel (II) nitrate (Ni(NO3)2)"
   :tiles       ["loria_nickel_nitrate.png"]
   :groups      {:crumbly 1}})

(core.register_node "loria:chromium_fluoride"
  {:description "Chromium (III) fluoride (CrF3)"
   :tiles       ["loria_chromium_fluoride.png"]
   :groups      {:cracky 2}})

(core.register_node "loria:chromium_fluoride_capital"
  {:description "Machined chromium fluoride (I)"
   :tiles       ["loria_chromium_fluoride.png^loria_capital.png"]
   :groups      {:cracky 1}})

(core.register_node "loria:chromium_fluoride_shaft"
  {:description "Machined chromium fluoride (II)"
   :tiles (map (fn [postfix] (.. "loria_chromium_fluoride.png^" postfix))
               ["loria_shaft_top_bottom.png"
                "loria_shaft_top_bottom.png"
                "loria_shaft.png" "loria_shaft.png"
                "loria_shaft.png" "loria_shaft.png"])
   :groups {:cracky 1} :paramtype2 "wallmounted"})

(core.register_node "loria:chromium_fluoride_base"
  {:description "Machined chromium fluoride (III)"
   :tiles (map (fn [postfix] (.. "loria_chromium_fluoride.png^" postfix))
               ["loria_base_top.png" "loria_base_bottom.png"
                "loria_base.png" "loria_base.png"
                "loria_base.png" "loria_base.png"])
   :groups {:cracky 1} :paramtype2 "wallmounted"})

(core.register_node "loria:chromium_fluoride_volutes"
  {:description "Machined chromium fluoride (IV)"
   :tiles (map (fn [postfix] (.. "loria_chromium_fluoride.png^" postfix))
               ["loria_volutes_top.png" "loria_volutes_bottom.png"
                "loria_volutes.png" "loria_volutes.png"
                "loria_volutes.png" "loria_volutes.png"])
  :groups {:cracky 1} :paramtype2 "wallmounted"})

(core.register_node "loria:chromium_fluoride_floor"
  {:description "Machined chromium fluoride (V)"
   :tiles       ["loria_chromium_fluoride.png^loria_floor.png"]
   :groups      {:cracky 1}})

(core.register_node "loria:chromium_fluoride_cross"
  {:description "Machined chromium fluoride (VI)"
   :tiles       ["loria_chromium_fluoride.png^loria_cross.png"]
   :groups      {:cracky 1}})

(core.register_node "loria:chromium_fluoride_hooked_cross"
  {:description "Machined chromium fluoride (VII)"
   :tiles       ["loria_chromium_fluoride.png^loria_hooked_cross.png"]
   :groups      {:cracky 1}})

(core.register_node "loria:chromium_fluoride_block"
  {:description "Machined chromium fluoride (VIII)"
   :tiles       ["loria_chromium_fluoride.png^loria_block.png"]
   :groups      {:cracky 1}})

(core.register_node "loria:chromium_fluoride_filled_floor"
  {:description "Machined chromium fluoride (IX)"
   :tiles       ["loria_chromium_fluoride.png^loria_filled_floor.png"]
   :groups      {:cracky 1}})

(core.register_node "loria:lead_oxide"
  {:description "Lead (II) oxide (PbO)"
   :tiles       ["loria_lead_oxide.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:silicon_dioxide"
  {:description "Silicon dioxide (SiO2)"
   :tiles       ["loria_silicon_dioxide.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:fused_quartz"
  {:description         "Fused quartz (glass)"
   :drawtype            "glasslike"
   :tiles              ["loria_fused_quartz.png"]
   :paramtype           "light"
   :is_ground_content   false
   :sunlight_propagates true
   :groups {:snappy 2 :cracky 3 :oddly_breakable_by_hand 3}})

(core.register_node "loria:calcium_fluoride"
  {:description "Calcium fluoride (CaF2)"
   :tiles       ["loria_calcium_fluoride.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:cobalt_blue"
  {:description "Cobalt blue (CoAl2O4)"
   :tiles       ["loria_cobalt_blue.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:mercury_oxide"
  {:description "Mercury (II) oxide (HgO)"
   :tiles       ["loria_mercury_oxide.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:red_mercury_oxide"
  {:description "Mercury (II) oxide (HgO, red)"
   :tiles       ["loria_red_mercury_oxide.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:sulfur"
  {:description "Sulfur (S)"
   :tiles       ["loria_sulfur.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:iodine"
  {:description "Iodine (I)"
   :tiles       ["loria_iodine.png"]
   :groups      {:crumbly 2}})

(core.register_node "loria:thorium"
  {:description "Thorium (Th)"
   :tiles       ["loria_thorium.png"]
   :groups      {:cracky 1 :conductor 1}})

(core.register_node "loria:thorium_dioxide"
  {:description "Thorium dioxide (ThO2)"
   :tiles       ["loria_thorium_dioxide.png"]
   :groups      {:cracky 2}})

(core.register_node "loria:plutonium"
  {:description "Plutonium (Pu)"
   :tiles       ["loria_plutonium.png"]
   :groups      {:cracky 1 :conductor 1}})

(core.register_node "loria:mushroom_mass"
  {:description "Mushroom mass"
   :tiles       ["loria_mushroom_mass.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:ferrous_oxide"
  {:description "Iron (II) oxide (FeO)"
   :tiles       ["loria_ferrous_oxide.png"]
   :groups      {:crumbly 3}})

(core.register_node "loria:ferric_oxide"
  {:description "Iron (III) oxide (Fe2O3)"
   :tiles       ["loria_ferric_oxide.png"]
   :groups      {:crumbly 3}})

(local glow-stick-selection-box
  {:type        "wallmounted"
   :wall_top    [-0.1 (- 0.5 0.6) -0.1     0.1          0.5      0.1]
   :wall_bottom [-0.1   -0.5      -0.1     0.1      (+ -0.5 0.6) 0.1]
   :wall_side   [-0.5   -0.3      -0.1 (+ -0.5 0.3)     0.3      0.1]})

(core.register_node "loria:blowed_out_glow_stick"
  {:description "Blowed out glow stick"
   :drawtype "torchlike"
   :tiles ["loria_blowed_out_glow_stick_on_floor.png"
           "loria_blowed_out_glow_stick_on_ceiling.png"
           "loria_blowed_out_glow_stick.png"]
   :inventory_image "loria_blowed_out_glow_stick_on_floor.png"
   :wield_image "loria_blowed_out_glow_stick_on_floor.png"
   :paramtype "light" :paramtype2 "wallmounted"
   :sunlight_propagates true :is_ground_content false
   :walkable false :selection_box glow-stick-selection-box
   :groups {:choppy 2 :dig_immediate 3 :attached_node 1}
   :legacy_wallmounted true})

(core.register_node "loria:glow_stick"
  {:description "Glow stick"
   :drawtype "torchlike"
   :tiles ["loria_glow_stick_on_floor.png"
           "loria_glow_stick_on_ceiling.png"
           "loria_glow_stick.png"]
   :inventory_image "loria_glow_stick_on_floor.png"
   :wield_image "loria_glow_stick_on_floor.png"
   :paramtype "light" :paramtype2 "wallmounted"
   :sunlight_propagates true :is_ground_content false
   :walkable false :light_source 10
   :selection_box glow-stick-selection-box
   :groups {:choppy 2 :dig_immediate 3 :attached_node 1}
   :legacy_wallmounted true})

(defun drop_everything [pos]
  (let [meta (core.get_meta pos)
        inv  (meta:get_inventory)]
    (each [_ lst (pairs (inv:get_lists))]
      (each [_ itemstack (ipairs lst)]
        (core.add_item pos itemstack)))))

(defun setup_formspec [inv-size formspec]
  (fn [pos] (let [meta (core.get_meta pos)
                  inv  (meta:get_inventory)]
              (meta:set_string "formspec" formspec)
              (inv:set_size "main" inv-size))))

(local lead-box-formspec
  (.. "size[8,10.5]"
      "list[context;main;0,0;8,5;]"
      "list[current_player;main;0,6;8,1;]"
      "list[current_player;main;0,7.5;8,3;8]"))

(core.register_node "loria:lead_box"
  {:description "Lead box"
   :tiles ["loria_lead_box_top.png"  "loria_lead_box_bottom.png"
           "loria_lead_box_side.png" "loria_lead_box_side.png"
           "loria_lead_box_side.png" "loria_lead_box_front.png"]
   :on_destruct drop_everything
   :on_construct (setup_formspec 40 lead-box-formspec)
   :paramtype2 "facedir" :groups {:cracky 2}})

(local silicon-box-formspec
  (.. "size[8,8.5]"
      "list[context;main;0,0;8,3;]"
      "list[current_player;main;0,4;8,1;]"
      "list[current_player;main;0,5.5;8,3;8]"))

(core.register_node "loria:silicon_box"
  {:description "Silicon box"
   :tiles ["loria_silicon_box_top.png"  "loria_silicon_box_bottom.png"
           "loria_silicon_box_side.png" "loria_silicon_box_side.png"
           "loria_silicon_box_side.png" "loria_silicon_box_front.png"]
   :on_destruct drop_everything
   :on_construct (setup_formspec 24 silicon-box-formspec)
   :paramtype2 "facedir" :groups {:cracky 2}})

(each [name _ (pairs brickable)]
  (let [source (. core.registered_nodes name)]
    (core.register_node (.. name "_brick")
      {:description (.. source.description " brick")
       :tiles (map (fn [tile] (.. tile "^loria_brick_mask.png")) source.tiles)
       :groups {:cracky 3} :drop (.. name "_brick")})))
