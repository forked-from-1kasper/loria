dofile("../loria/mods/default/prelude.lua")
dofile("../loria/mods/default/inv_crafts.lua")
dofile("../loria/mods/furnace/crafts.lua")

function process_stack_list(stack_list)
    local components = { }
    for _, stack in ipairs(stack_list) do
        local count = stack.count or 1
        table.insert(components, string.format("%s × %d", stack.name, count))
    end
    return table.concat(components, ", ")
end

function process_craft(craft)
    return string.format(
        "|%s|%s|",
        process_stack_list(craft.input),
        process_stack_list(craft.output)
    )
end

template =
    "## %s\n" ..
    "| Input | Output |\n" ..
    "| ----- | ------ |\n" ..
    "%s\n"

function mk_table(name, values)
    return string.format(
        template, name,
        table.concat(map(process_craft, values), "\n")
    )
end

inventory = { }
furnace = { }

print("# Craft list\n")
print(mk_table("Inventory", inv_crafts))
print(mk_table("Furnace", furnace_crafts))
print(mk_table("Refiner", refiner_crafts))