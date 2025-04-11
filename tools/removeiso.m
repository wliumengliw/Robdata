function A = removeiso(A)
% 去除孤立节点并重构邻接矩阵
% 输入：
%   A - 原始邻接矩阵（可以是稀疏或稠密）
% 输出：
%   A_cleaned - 去除孤立节点后的邻接矩阵
%   removed_nodes - 被删除的节点编号

    if ~ismatrix(A) || size(A,1) ~= size(A,2)
        error('输入必须为方阵邻接矩阵');
    end

    N = size(A,1);

    % 找出 in-degree 和 out-degree 全为 0 的节点
    isolated_nodes = find((sum(A,1) + sum(A,2)') == 0);

    % 记录删除的节点编号
    removed_nodes = isolated_nodes;

    % 删除这些节点
    keep_nodes = setdiff(1:N, isolated_nodes);
    A = A(keep_nodes, keep_nodes);

    fprintf('✅ 已删除 %d 个孤立节点。\n', length(removed_nodes));
end
