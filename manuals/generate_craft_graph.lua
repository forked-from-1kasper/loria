-- lua5.3 generate_craft_graph.lua | dot.exe -Tsvg -o pictures/crafts.svg

dofile("../loria/mods/default/prelude.lua")
dofile("../loria/mods/default/inv_crafts.lua")
dofile("../loria/mods/furnace/crafts.lua")

function process_craft(tag)
    return function(craft)
	local lines = {}
        for _, ing1 in ipairs(craft.input) do
            for _, ing2 in ipairs(craft.output) do
                table.insert(lines, string.format(
                    '  "%s" -> "%s" [label="%s"];',
                    ing1.name, ing2.name, tag
                ))
            end
        end
	return table.concat(lines, "\n")
    end
end

function mk_table(name, values)
    return string.format(table.concat(map(process_craft(name), values), "\n"))
end

print('digraph loria {\nratio="compress";\n')
print(mk_table("Inventory", inv_crafts))
print(mk_table("Furnace", furnace_crafts))
print(mk_table("Refiner", refiner_crafts))
print("}\n")
