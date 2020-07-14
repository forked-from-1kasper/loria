-- lua5.3 generate_craft_graph.lua | dot.exe -Tsvg -o pictures/crafts.svg
vector = { new = function() end }

dofile("../sources/mods/loria/prelude.lua")
dofile("../sources/mods/loria/conf.lua")
dofile("../sources/mods/loria/inv_crafts.lua")
dofile("../sources/mods/furnace/crafts.lua")

graph = {}

function has_value(arr, name, tag)
    for _, val in ipairs(arr) do
        if val.name == name and val.tag == tag then
            return true
        end
    end

    return false
end

function process_craft(tag)
    return function(craft)
        for _, ing1 in ipairs(craft.input) do
            for _, ing2 in ipairs(craft.output) do
                if not graph[ing1.name] then
                    graph[ing1.name] = {}
                end

                if not has_value(graph[ing1.name], ing2.name, tag) then
                    table.insert(graph[ing1.name], {
                        name = ing2.name,
                        tag = tag
                    })
                end
            end
        end
    end
end

function mk_table(name, values)
    return foreach(process_craft(name), values)
end

mk_table("I", inv_crafts)
mk_table("F", furnace_crafts)
mk_table("R", refiner_crafts)

print('digraph loria {\nratio="compress";\n')
for name, connection in pairs(graph) do
    for _, endpoint in ipairs(connection) do
        print(string.format(
            '  "%s" -> "%s" [label="%s"];',
            name, endpoint.name, endpoint.tag
        ))
    end
end
print("}\n")
