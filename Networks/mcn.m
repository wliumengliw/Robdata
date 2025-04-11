function [A, ak] = mcn(r, N, nlink)
% 构建 MCN 并删边至目标边数 nlink

    A = zeros(N,N);
    for i = 1:N
        for j = i+1:N+1
            if mod(j+1, i+1) == r && j <= N
                A(i,j) = 1;
            end
        end
    end

    % 原始边总数
    [row, col] = find(A);
    E = length(row);

    % 如果边数太少，报错提示
    if nlink > E
        error('目标边数 nlink=%d 超过原始边数 %d，无法满足。', nlink, E);
    end

    % 删除多余边
    if nlink < E
        perm = randperm(E, E - nlink);  % 要删除的边索引
        for k = perm
            A(row(k), col(k)) = 0;
        end
    end

    ak = sum(sum(A)) / N;  % 平均度
    A=sparse(A)
end

