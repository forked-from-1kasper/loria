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

function contains(arr, val)
    for _, elem in ipairs(arr) do
        if val == elem then
            return true
        end
    end

    return false
end

function nope()
end