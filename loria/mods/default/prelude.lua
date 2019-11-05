function comp(f, g)
    return (function(x)
        return f(g(x))
    end)
end

function and_then(f, g)
    return (function(x)
        f(x)
        return g(x)
    end)
end

function map(f, l)
    local res = { }
    for _, x in ipairs(l) do
        table.insert(res, f(x))
    end

    return res
end

function foreach(f, l)
    for _, x in ipairs(l) do
        f(x)
    end
end

function all(f, l)
    for _, x in ipairs(l) do
        if not f(x) then
            return false
        end
    end

    return true
end

function find(f, l)
    for _, x in ipairs(l) do
        if f(x) then
            return x
        end
    end
end

function copy(t)
    local t1 = { }
    for k, v in pairs(t) do
        t1[k] = v
    end

    return t1
end

function const(x)
    return (function()
        return x
    end)
end

function starts_with(str, start)
    return str:sub(1, #start) == start
end

function ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

function swap_node(pos, name)
    local node = minetest.get_node(pos)
    if node.name == name then
        return
    end
    node.name = name
    minetest.swap_node(pos, node)
end

function add_or_drop(inv, listname, stack, pos)
    if inv:room_for_item(listname, stack) then
        inv:add_item(listname, stack)
    else
        minetest.add_item(pos, stack)
    end
end

function append(dest, source)
    for _, x in ipairs(source) do
        table.insert(dest, x)
    end
end

function contains(arr, val)
    for _, elem in ipairs(arr) do
        if val == elem then
            return true
        end
    end

    return false
end

function capitalization(str)
    return string.gsub(str:gsub("^%l", string.upper), "_", " ")
end

function join(lst1, lst2)
    local res = {}

    for idx, x in pairs(lst1) do
        res[idx] = x
    end

    for idx, y in pairs(lst2) do
        res[idx] = y
    end

    return res
end

function nope()
end