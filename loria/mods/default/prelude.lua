function comp(f, g)
    return (function(x)
        return f(g(x))
    end)
end

function and_then(f, g)
    return (function(x)
        g(x)
        f(x)
    end)
end

function map(f, l)
    res = { }
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