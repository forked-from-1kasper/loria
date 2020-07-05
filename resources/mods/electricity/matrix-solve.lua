function swaprows(A, i, j)
    for k = 1, A.size.width do
        local t = A:get(i, k)
        A:set(i, k, A:get(j, k))
        A:set(j, k, t)
    end
end

-- from https://rosettacode.org/wiki/Gaussian_elimination#Python
-- crushes “a” and “b”
function linsolve(a, b)
    local n = a.size.height
    local p = b.size.width

    for i = 1, n do
        local k = i
        for j = i + 1, n do
            if complex.abs(a:get(j, i)) > complex.abs(a:get(k, i)) then
                k = j
            end
        end

        if k ~= i then
            swaprows(a, i, k)
            swaprows(b, i, k)
        end

        for j = i + 1, n do
            local t = a:get(j, i) / a:get(i, i)
            for k = i + 1, n do
                a:set(j, k, a:get(j, k) - t * a:get(i, k))
            end
            
            for k = 1, p do
                b:set(j, k, b:get(j, k) - t * b:get(i, k))
            end
        end
    end

    for i = n, 1, -1 do
        for j = i + 1, n do
            local t = a:get(i, j)
            for k = 1, p do
                b:set(i, k, b:get(i, k) - t * b:get(j, k))
            end
        end
        
        local t = a:get(i, i)
        for j = 1, p do
            b:set(i, j, b:get(i, j) / t)
        end
    end

    return b
end