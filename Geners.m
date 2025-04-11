function net = Geners()
    networktypes = [];  % Initialize empty list
    while true
        % 输入并转换为数字列表，比如 '13' → [1 3]
        str = input(['(1) ER, (2) SF, (3) QSN, (4) RH, (5) RT, (6) SW_NW, ' ...
            '(7) SW_WS, (8) MCN, (9) EH: '], 's');
        netype = str - '0';  % 把字符转成数字数组，比如 '13' → [1 3]
        netype = netype(netype >= 1 & netype <= 9);  % 可选：只保留合法数字
        networktypes = [networktypes, netype];  % 追加进数组
    
        flag = input('Continue? If not, please press "q" to quit: ', 's');
        if strcmp(flag, 'q')
            netps = numel(networktypes);  % 获取选择的数量
            fprintf("Fine! You selected %d networks.\n", netps);
            break
        end
    end
    networknames=getnetname(networktypes)
    diriction=input('The network is: (1) undirected, (2) directed, (3) All_need:','s')
    minAvgDegree = input('The lower limits of networks degree: ');      % ✅ 默认返回数值
    maxAvgDegree = input('The upper limits of networks degree: ');
    minNode = input('The lower limits of networks nodes: ');
    maxNode = input('The upper limits of networks nodes: ');
    generatedNetworks = input("The general networks' number: "); % 生成的符合条件的网络数量
    undi_config = struct('networks', generatedNetworks, ...
                'minN', minNode, ...
                'maxN', maxNode, ...
                'minAD', minAvgDegree*2, ...
                'maxAD', maxAvgDegree*2);
    di_config = struct('networks', generatedNetworks, ...
                'minN', minNode, ...
                'maxN', maxNode, ...
                'minAD', minAvgDegree, ...
                'maxAD', maxAvgDegree);
    if ismember('ER',networknames)
        ER_undi_node_set = randnum(minNode, maxNode, generatedNetworks, 'integer');
        ER_di_node_set   = randnum(minNode, maxNode, generatedNetworks, 'integer');
        ER_undi_degree_set = randnum(minAvgDegree*2, maxAvgDegree*2, generatedNetworks, 'decimal,1');
        ER_di_degree_set   = randnum(minAvgDegree, maxAvgDegree, generatedNetworks, 'decimal,1');
    
        nlink_undi_set = round((ER_undi_node_set .* ER_undi_degree_set) / 2);
        nlink_di_set   = round((ER_di_node_set .* ER_di_degree_set));  % 注意修正为使用 ER_di_node_set
    
        undi_degree = zeros(1, generatedNetworks);
    
        % === 生成无向 ER 网络 ===
        if strcmp(diriction, '1') || strcmp(diriction, '3')
            for i = 1:generatedNetworks
                N_undi = ER_undi_node_set(i);
                L_undi = nlink_undi_set(i);
                [A_undi, ak, ~] = ern(N_undi, L_undi, 'no_chain');
                A_undi = double((A_undi + A_undi') > 0);  % 对称化
                ER_undi_avg_degree = ak * 2;
                undi_degree(1, i) = ER_undi_avg_degree;
        
                res(i) = struct( ...
                    'id', i, ...
                    'adj', A_undi, ...
                    'N', N_undi, ...
                    'm', sum(A_undi(:)) / 2, ...
                    'avgdegree', ER_undi_avg_degree);
            end
            save_result('ER_undi',res,undi_config)
        end


        if strcmp(diriction, '2') || strcmp(diriction, '3')
            di_degree = zeros(1, generatedNetworks);
        
            % === 生成有向 ER 网络 ===
            for i = 1:generatedNetworks
                N_di = ER_di_node_set(i);
                L_di = nlink_di_set(i);
                [A_di, ak_di, ~] = ern(N_di, L_di, 'no_chain');  % 保持有向
        
                di_degree(1, i) = ak_di;
        
                res_di(i) = struct( ...
                    'id', i, ...
                    'adj', A_di, ...
                    'N', N_di, ...
                    'm', sum(A_di(:)), ...
                    'avgdegree', ak_di);
            end
            save_result('ER_di',res_di,di_config)
        end


    end

  if ismember('SF', networknames)
        SF_undi_node_set = randnum(minNode, maxNode, generatedNetworks, 'integer');
        SF_di_node_set   = randnum(minNode, maxNode, generatedNetworks, 'integer');
        SF_undi_degree_set = randnum(minAvgDegree*2, maxAvgDegree*2, generatedNetworks, 'decimal,1');
        SF_di_degree_set   = randnum(minAvgDegree, maxAvgDegree, generatedNetworks, 'decimal,1');

        nlink_undi_set = round((SF_undi_node_set .* SF_undi_degree_set) / 2);
        nlink_di_set   = round((SF_di_node_set .* SF_di_degree_set));

        sfpara.mu = 0.9;     % 趋近于 1 越集中，越 scale-free
        sfpara.theta = 1;    % 偏移调节参数

        %% === 无向 SF 网络 ===
        if strcmp(diriction, '1') || strcmp(diriction, '3')
            undi_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = SF_undi_node_set(i);
                L = nlink_undi_set(i);
                [A, ak, ~] = sfn(N, L, 'no_chain', sfpara);
                A = double((A + A') > 0);  % 对称化

                avgdeg = ak * 2;
                undi_degree(i) = avgdeg;

                res(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)) / 2, ...
                    'avgdegree', avgdeg);
            end
            save_result('SF_undi', res, undi_config);
        end

        %% === 有向 SF 网络 ===
        if strcmp(diriction, '2') || strcmp(diriction, '3')
            di_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = SF_di_node_set(i);
                L = nlink_di_set(i);
                [A, ak, ~] = sfn(N, L, 'no_chain', sfpara);  % 有向 SF 不对称

                di_degree(i) = ak;

                res_di(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)), ...
                    'avgdegree', ak);
            end
            save_result('SF_di', res_di, di_config);
        end
    end

    if ismember('QSN', networknames)
        QSN_undi_node_set = randnum(minNode, maxNode, generatedNetworks, 'integer');
        QSN_di_node_set   = randnum(minNode, maxNode, generatedNetworks, 'integer');
        QSN_undi_degree_set = randnum(minAvgDegree*2, maxAvgDegree*2, generatedNetworks, 'decimal,1');
        QSN_di_degree_set   = randnum(minAvgDegree, maxAvgDegree, generatedNetworks, 'decimal,1');

        nlink_undi_set = round((QSN_undi_node_set .* QSN_undi_degree_set) / 2);
        nlink_di_set   = round((QSN_di_node_set .* QSN_di_degree_set));

        r = 3;        % QSN 层数
        q = 0.3;      % snapback 概率
        itop = 'chain';  % 初始拓扑结构

        %% === 无向 QSN 网络 ===
        if strcmp(diriction, '1') || strcmp(diriction, '3')
            undi_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = QSN_undi_node_set(i);
                L = nlink_undi_set(i);
                [A, ak] = qsn(r, N, q, L, itop);
                A = double((A + A') > 0);  % 对称化

                avgdeg = ak * 2;
                undi_degree(i) = avgdeg;

                res(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)) / 2, ...
                    'avgdegree', avgdeg);
            end
            save_result('QSN_undi', res, undi_config);
        end

        %% === 有向 QSN 网络 ===
        if strcmp(diriction, '2') || strcmp(diriction, '3')
            di_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = QSN_di_node_set(i);
                L = nlink_di_set(i);
                [A, ak] = qsn(r, N, q, L, itop);  % 保留有向 snapback

                di_degree(i) = ak;

                res_di(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)), ...
                    'avgdegree', ak);
            end
            save_result('QSN_di', res_di, di_config);
        end
    end


    if ismember('RH', networknames)
        RH_undi_node_set = randnum(minNode, maxNode, generatedNetworks, 'integer');
        RH_di_node_set   = randnum(minNode, maxNode, generatedNetworks, 'integer');
        RH_undi_degree_set = randnum(minAvgDegree*2, maxAvgDegree*2, generatedNetworks, 'decimal,1');
        RH_di_degree_set   = randnum(minAvgDegree, maxAvgDegree, generatedNetworks, 'decimal,1');

        nlink_undi_set = round((RH_undi_node_set .* RH_undi_degree_set) / 2);
        nlink_di_set   = round((RH_di_node_set .* RH_di_degree_set));

        %% === 无向 RH 网络 ===
        if strcmp(diriction, '1') || strcmp(diriction, '3')
            undi_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = RH_undi_node_set(i);
                L = nlink_undi_set(i);
                A = rh(N, L);                     % 原始为有向
                A = double((A + A') > 0);         % 对称化为无向图
                avgdeg = sum(A(:)) / N;           % 或用 sum(sum(A)) / N
                undi_degree(i) = avgdeg;

                res(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)) / 2, ...
                    'avgdegree', avgdeg);
            end
            save_result('RH_undi', res, undi_config);
        end

        %% === 有向 RH 网络 ===
        if strcmp(diriction, '2') || strcmp(diriction, '3')
            di_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = RH_di_node_set(i);
                L = nlink_di_set(i);
                A = rh(N, L);                     % 有向图保持原样
                avgdeg = sum(A(:)) / N;
                di_degree(i) = avgdeg;

                res_di(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)), ...
                    'avgdegree', avgdeg);
            end
            save_result('RH_di', res_di, di_config);
        end
    end

    if ismember('RT', networknames)
        RT_undi_node_set = randnum(minNode, maxNode, generatedNetworks, 'integer');
        RT_di_node_set   = randnum(minNode, maxNode, generatedNetworks, 'integer');
        RT_undi_degree_set = randnum(minAvgDegree*2, maxAvgDegree*2, generatedNetworks, 'decimal,1');
        RT_di_degree_set   = randnum(minAvgDegree, maxAvgDegree, generatedNetworks, 'decimal,1');

        nlink_undi_set = round((RT_undi_node_set .* RT_undi_degree_set) / 2);
        nlink_di_set   = round((RT_di_node_set .* RT_di_degree_set));

        style = 'loop';

        %% === 无向 RT 网络 ===
        if strcmp(diriction, '1') || strcmp(diriction, '3')
            undi_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = RT_undi_node_set(i);
                L = nlink_undi_set(i);
                [A, ak, ~] = rtn(N, L, style);
                A = double((A + A') > 0);         % 对称化为无向图
                avgdeg = sum(A(:)) / N;
                undi_degree(i) = avgdeg;

                res(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)) / 2, ...
                    'avgdegree', avgdeg);
            end
            save_result('RT_undi', res, undi_config);
        end

        %% === 有向 RT 网络 ===
        if strcmp(diriction, '2') || strcmp(diriction, '3')
            di_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = RT_di_node_set(i);
                L = nlink_di_set(i);
                [A, ak, ~] = rtn(N, L, style);
                avgdeg = ak;
                di_degree(i) = avgdeg;

                res_di(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)), ...
                    'avgdegree', avgdeg);
            end
            save_result('RT_di', res_di, di_config);
        end
    end


    if ismember('SW_NW', networknames)
        SW_undi_node_set = randnum(minNode, maxNode, generatedNetworks, 'integer');
        SW_di_node_set   = randnum(minNode, maxNode, generatedNetworks, 'integer');
        SW_undi_degree_set = randnum(minAvgDegree*2, maxAvgDegree*2, generatedNetworks, 'decimal,1');
        SW_di_degree_set   = randnum(minAvgDegree, maxAvgDegree, generatedNetworks, 'decimal,1');

        p = 0.1;  % shortcut 添加概率

        %% === 无向 SW_NW 网络 ===
        if strcmp(diriction, '1') || strcmp(diriction, '3')
            undi_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = SW_undi_node_set(i);
                avgdeg = SW_undi_degree_set(i);
                K = round(avgdeg / 2);  % 每边连接 K 个邻居 → 平均度 2K

                G = sw_nw(N, K, p);
                A = double(adjacency(G));  % 无向邻接矩阵
                A=sparse(A)
                undi_degree(i) = mean(sum(A, 2));

                res(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)) / 2, ...
                    'avgdegree', undi_degree(i));
            end
            save_result('SW_NW_undi', res, undi_config);
        end

        %% === 有向 SW_NW 网络 ===
        if strcmp(diriction, '2') || strcmp(diriction, '3')
            di_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = SW_di_node_set(i);
                avgdeg = SW_di_degree_set(i);
                K = round(avgdeg);  % 有向图出度为 K

                G = sw_nw(N, K, p);          % 保持调用不变
                A = double(adjacency(G));    % 原本为无向图邻接矩阵
                A = A - diag(diag(A));       % 移除自环
                A = triu(A, 1);              % 随机赋方向
                A = A + double(rand(N) < 0.5 & A' == 1);  % 添加反方向
                A=sparse(A)
                di_degree(i) = mean(sum(A, 2));

                res_di(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)), ...
                    'avgdegree', di_degree(i));
            end
            save_result('SW_NW_di', res_di, di_config);
        end
    end


    if ismember('SW_WS', networknames)
        WS_undi_node_set = randnum(minNode, maxNode, generatedNetworks, 'integer');
        WS_di_node_set   = randnum(minNode, maxNode, generatedNetworks, 'integer');
        WS_undi_degree_set = randnum(minAvgDegree*2, maxAvgDegree*2, generatedNetworks, 'decimal,1');
        WS_di_degree_set   = randnum(minAvgDegree, maxAvgDegree, generatedNetworks, 'decimal,1');

        beta = 0.3;  % rewiring 概率

        %% === 无向 SW_WS 网络 ===
        if strcmp(diriction, '1') || strcmp(diriction, '3')
            undi_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = WS_undi_node_set(i);
                avgdeg = WS_undi_degree_set(i);
                K = round(avgdeg / 2);  % 每边 K 个邻居 → 平均度 2K

                G = sw_ws(N, K, beta);
                A = double(adjacency(G));

                undi_degree(i) = mean(sum(A, 2));

                res(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)) / 2, ...
                    'avgdegree', undi_degree(i));
            end
            save_result('SW_WS_undi', res, undi_config);
        end

        %% === 有向 SW_WS 网络 ===
        if strcmp(diriction, '2') || strcmp(diriction, '3')
            di_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = WS_di_node_set(i);
                avgdeg = WS_di_degree_set(i);
                K = round(avgdeg);  % 有向图出度为 K

                G = sw_ws(N, K, beta);
                A = double(adjacency(G));
                A = A - diag(diag(A));        % 去除自环
                A = triu(A, 1);               % 上三角表示方向
                A = A + double(rand(N) < 0.5 & A' == 1);  % 随机加反向边

                di_degree(i) = mean(sum(A, 2));

                res_di(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)), ...
                    'avgdegree', di_degree(i));
            end
            save_result('SW_WS_di', res_di, di_config);
        end
    end


    if ismember('MCN', networknames)
        MCN_undi_node_set = randnum(minNode, maxNode, generatedNetworks, 'integer');
        MCN_di_node_set   = randnum(minNode, maxNode, generatedNetworks, 'integer');
        MCN_undi_degree_set = randnum(minAvgDegree*2, maxAvgDegree*2, generatedNetworks, 'decimal,1');
        MCN_di_degree_set   = randnum(minAvgDegree, maxAvgDegree, generatedNetworks, 'decimal,1');

        r = 2;  % 控制参数

        %% === 无向 MCN 网络 ===
        if strcmp(diriction, '1') || strcmp(diriction, '3')
            undi_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = MCN_undi_node_set(i);
                L = round((N * MCN_undi_degree_set(i)) / 2);

                try
                    [A, ak] = mcn(r, N, L);
                catch ME
                    warning('[MCN_undi] Skip i=%d, N=%d, L=%d → %s', i, N, L, ME.message);
                    continue;
                end

                A = double((A + A') > 0);
                avgdeg = mean(sum(A, 2));
                undi_degree(i) = avgdeg;

                res(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)) / 2, ...
                    'avgdegree', avgdeg);
            end
            if exist('res', 'var') && ~isempty(res)
                save_result('MCN_undi', res, undi_config);
            end
        end

        %% === 有向 MCN 网络 ===
        if strcmp(diriction, '2') || strcmp(diriction, '3')
            di_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = MCN_di_node_set(i);
                L = round(N * MCN_di_degree_set(i));

                try
                    [A, ak] = mcn(r, N, L);
                catch ME
                    warning('[MCN_di] Skip i=%d, N=%d, L=%d → %s', i, N, L, ME.message);
                    continue;
                end

                avgdeg = ak;
                di_degree(i) = avgdeg;

                res_di(i) = struct( ...
                    'id', i, ...
                    'adj', A, ...
                    'N', N, ...
                    'm', sum(A(:)), ...
                    'avgdegree', avgdeg);
            end
            if exist('res_di', 'var') && ~isempty(res_di)
                save_result('MCN_di', res_di, di_config);
            end
        end
    end

    
    if ismember('EH', networknames)
        EH_undi_node_set = randnum(minNode, maxNode, generatedNetworks, 'integer');
        EH_di_node_set   = randnum(minNode, maxNode, generatedNetworks, 'integer');
        EH_undi_degree_set = randnum(minAvgDegree*2, maxAvgDegree*2, generatedNetworks, 'decimal,1');
        EH_di_degree_set   = randnum(minAvgDegree, maxAvgDegree, generatedNetworks, 'decimal,1');

        nlink_undi_set = round((EH_undi_node_set .* EH_undi_degree_set) / 2);
        nlink_di_set   = round((EH_di_node_set .* EH_di_degree_set));

        %% === 无向 EH 网络 ===
        if strcmp(diriction, '1') || strcmp(diriction, '3')
            undi_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = EH_undi_node_set(i);
                L = nlink_undi_set(i);
                try
                    [A, ~, ~] = ern(N, L, 'no_chain');
                catch
                    warning('[EH_undi] ER base network failed. Skip N=%d, L=%d', N, L);
                    continue;
                end
                A = double((A + A') > 0);  % 对称化为无向图

                % ==== 均匀化（EH 关键步骤）====
                degrees = sum(A, 2);
                target_degree = round(mean(degrees));
                for j = 1:N
                    while sum(A(j, :)) > target_degree
                        neighbors = find(A(j, :));
                        drop = neighbors(randi(length(neighbors)));
                        A(j, drop) = 0;
                        A(drop, j) = 0;
                    end
                end

                avgdeg = mean(sum(A, 2));
                undi_degree(i) = avgdeg;

                res(i) = struct( ...
                    'id', i, ...
                    'adj', sparse(A), ...
                    'N', N, ...
                    'm', sum(A(:)) / 2, ...
                    'avgdegree', avgdeg);
            end
            save_result('EH_undi', res, undi_config);
        end

        %% === 有向 EH 网络 ===
        if strcmp(diriction, '2') || strcmp(diriction, '3')
            di_degree = zeros(1, generatedNetworks);
            for i = 1:generatedNetworks
                N = EH_di_node_set(i);
                L = nlink_di_set(i);
                try
                    [A, ~, ~] = ern(N, L, 'no_chain');
                catch
                    warning('[EH_di] ER base network failed. Skip N=%d, L=%d', N, L);
                    continue;
                end

                % === EH 均匀化处理（有向）===
                out_deg = sum(A, 2);
                target_out = round(mean(out_deg));
                for j = 1:N
                    while sum(A(j, :)) > target_out
                        targets = find(A(j, :));
                        drop = targets(randi(length(targets)));
                        A(j, drop) = 0;
                    end
                end

                avgdeg = mean(sum(A, 2));
                di_degree(i) = avgdeg;

                res_di(i) = struct( ...
                    'id', i, ...
                    'adj', sparse(A), ...
                    'N', N, ...
                    'm', sum(A(:)), ...
                    'avgdegree', avgdeg);
            end
            save_result('EH_di', res_di, di_config);
        end
    end

    