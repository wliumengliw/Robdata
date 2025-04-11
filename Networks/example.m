%n=100; d=10; link=d*n;
%[adj,ak,dd]=ern(n,link)

% 参数设置 N = 1000;  nlink = 3000; str = 'no_chain';  sfpara.mu = 0.9; sfpara.theta = 1;
% [A, ak, disc] = sfn(N, nlink, str, sfpara);

% 参数设置N = 100;K = 2;每个节点连接 K 个两边邻居K相当于平均度的1/2，p = 0.1;添加随机shortcut的概率
% 生成网络G = sw_nw(N, K, p);

% 参数设置N = 100;K = 2;每个节点连接 K 个两边邻居K相当于平均度的1/2，p = 0.1;添加随机shortcut的概率
% 生成网络G = sw_ws(N, K, p);

% 参数设置r = 1;N = 100;
%[A, ak] = mcn(r, N);

%r = 3;N = 100;q = 0.3;nlink = 300;itop = 'chain';      
%[A, ak] = qsn(r, N, q, nlink, itop);

% 参数设置N = 100;nlink = 300;style = 'loop';   % or 'noloop'
%[A, ak, disc] = rtn(N, nlink, style);

% 参数设置N = 100;m = 300;     % 边数
%A = rh(N, m);





