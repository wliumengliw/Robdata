function network_names = getnetname(indices)
% 将网络编号转化为对应名称
% 输入：indices - 数字数组，如 [1 3 4]
% 输出：network_names - 单元格数组，如 {'ER', 'QSN', 'RH'}

    all_names = {'ER', 'SF', 'QSN', 'RH', 'RT', ...
                 'SW_NW', 'SW_WS', 'MCN', 'EH'};

    % 输入检查
    if any(indices < 1) || any(indices > numel(all_names))
        error('输入包含无效编号，必须在 1 到 %d 范围内。', numel(all_names));
    end

    % 根据索引取出名称
    network_names = all_names(indices);
end
