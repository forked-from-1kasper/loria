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
    "# Craft list\n" ..
    "## Inventory\n" ..
    "| Input | Output |\n" ..
    "| ----- | ------ |\n" ..
    "%s\n\n" ..
    "## Furnace\n" ..
    "| Input | Output |\n" ..
    "| ----- | ------ |\n" ..
    "%s\n"

inventory = { }
furnace = { }

for _, craft in ipairs(inv_crafts) do
    table.insert(inventory, process_craft(craft))
end

for _, craft in ipairs(furnace_crafts) do
    table.insert(furnace, process_craft(craft))
end

print(string.format(
    template,
    table.concat(inventory, "\n"),
    table.concat(furnace, "\n")
))