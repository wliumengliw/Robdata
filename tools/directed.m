function isUndirected = directed(A)
    if isequal(A, A')
        isUndirected = false;
    else
        isUndirected = true;
    end
end
