function A_converted = convert_network(A, direct)

N = size(A, 1); % Number of nodes

switch direct
    case 'to_directed'
        % Assumes A is undirected (symmetric)
        A_upper = triu(A, 1);   % Take upper triangle (no diagonal)
        rand_dir = rand(N);     % Random matrix for direction decision
        mask = rand_dir > 0.5;  % Randomly decide direction
        A_directed = sparse(N, N);
        
        for i = 1:N
            for j = i+1:N
                if A_upper(i,j)
                    if mask(i,j)
                        A_directed(i,j) = 1;
                    else
                        A_directed(j,i) = 1;
                    end
                end
            end
        end
        A_converted = A_directed;

    case 'to_undirected'
        % Simply symmetrize the adjacency matrix
        A_converted = double((A + A') > 0);

    otherwise
        error('Unsupported mode. Use "to_directed" or "to_undirected".');
end
end
