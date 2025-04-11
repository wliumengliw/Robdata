function save_result(type, res, config)
    % 过滤掉无 avgdegree 字段或空值的结构体项
    valid_idx = arrayfun(@(x) isfield(x, 'avgdegree') && ~isempty(x.avgdegree), res);
    res = res(valid_idx);

    if isempty(res)
        warning('No valid results in "%s". Nothing saved.', type);
        return;
    end

    % 平均度：只提取标量字段，不碰矩阵字段（稀疏也安全）
    avg_degrees = zeros(1, numel(res));
    for i = 1:numel(res)
        avg_degrees(i) = full(res(i).avgdegree);  % 保守处理，防止稀疏影响
    end
    avgAD = mean(avg_degrees);

    % 保存结构体
    net.dataset  = type;
    net.networks = config.networks;
    net.minN     = config.minN;
    net.maxN     = config.maxN;
    net.minAD    = config.minAD;
    net.maxAD    = config.maxAD;
    net.avgAD    = avgAD;
    net.res      = res;

    filename = strcat(type, '.mat');
    save(filename, 'net', '-v7.3');  % 推荐使用 -v7.3 以支持稀疏矩阵大数据

    fprintf('✅ [%s] Saved %d networks to file: %s\n', type, numel(res), filename);
end
