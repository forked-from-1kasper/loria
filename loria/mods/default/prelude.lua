function comp(f, g)
    return (function(x)
        return f(g(x))
    end)
end

function and_then(f, g)
    return (function(x)
        g(x)
        return f(x)
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

function append(dest, source)
    for _, x in ipairs(source) do
        table.insert(dest, x)
    end
end