function G = sw_nw(N, K, p)
    % Create a ring lattice
    s = repelem((1:N)', 1, K);
    t = s + repmat(1:K, N, 1);
    t = mod(t-1, N) + 1;
    
    % Add random shortcuts
    for node = 1:N
        for neighbor = 1:K
            if rand < p
                new_target = randi(N);
                while new_target == node || any(t(node, :) == new_target)
                    new_target = randi(N);
                end
                t(node, neighbor) = new_target;
            end
        end
    end
    
    % Create graph
    G = graph(s(:), t(:));
end

