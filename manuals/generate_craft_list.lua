vector = { new = function() end }

dofile("../sources/mods/loria/prelude.lua")
dofile("../sources/mods/loria/conf.lua")
dofile("../sources/mods/loria/inv_crafts.lua")
dofile("../sources/mods/furnace/crafts.lua")

local special_names = {
    ["furnace:gas"] = "Gas powered furnace (PbSe)",
    ["furnace:thorium"] = "Gas powered furnace (ThO₂)",
    ["furnace:electric"] = "Electric furnace"
}

function process_content_name(name)
    return special_names[name] or capitalization(name:gsub("^%a+:", ""))
end

function process_stack_list(stack_list)
    local components = { }
    for _, stack in ipairs(stack_list) do
        local count = stack.count or 1
        table.insert(
            components,
            string.format(
                "%s × %d",
                process_content_name(stack.name),
                count
            )
        )
    end
    return table.concat(components, ", ")
end

function process_craft(id, craft)
    return string.format(
        "|%d|%s|%s|", id,
        process_stack_list(craft.input),
        process_stack_list(craft.output)
    )
end

template =
    "## %s\n\n" ..
    "| № | Input | Output |\n" ..
    "| - | ----- | ------ |\n" ..
    "%s\n"

function mk_table(name, values)
    return string.format(
        template, name,
        table.concat(imap(process_craft, values), "\n")
    )
end

inventory = { }
furnace = { }

print("# Craft list\n")

print("## Fuel\n\n| Name | Burning time |\n|-|-|")
for name, time in opairs(fuel_list) do
    print(string.format("|%s|%d|", process_content_name(name), time))
end
print("")

print(mk_table("Inventory", inv_crafts))
print(mk_table("Furnace", furnace_crafts))
print(mk_table("Furnace (high temperature)", high_temperature_crafts))
print(mk_table("Refiner", refiner_crafts))