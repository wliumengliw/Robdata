% To construct a directed Scale-Free network
% optinal: with a backbone chain
% updated: 14-09-2018

function [A,ak,disc] = sfn(N,nlink,str,sfpara)
% Input:  N - # of nodes
%     nlink - # of links
%       str - {'no_chain'; 'chain'}
% Output: A -
%        ak -
%      disc - (disconnected == 1); (OK == 0)

    if nargin==2
        str = 'no_chain';
        sfpara.theta = 0;
        sfpara.mu    = 0.999;
    elseif nargin==3
        sfpara.theta = 0;
        sfpara.mu    = 0.999;
    end
    A = zeros(N,N);
    w = ((1:N)+sfpara.theta).^(-sfpara.mu);
    ransec = cumsum(w);
    cnt = 0;
    
% -----| if a backbone is needed |----- %    
    switch str
        case 'chain'
            A = diag(ones(1,N-1),1);  %% i -> (i+1)
            A(N,1) = 1;
            cnt = N;
        case 'tree'
            for i = 1:N-1
                j = i+randi(N-i);
                A(i,j) = 1;
            end
            A(N,1) = 1;
            cnt = N;
        otherwise
            % do nothing ...
    end
% -----| if a backbone is needed |----- %

    while cnt < nlink
        r = rand*ransec(end);
        for i=1:N
            if r<=ransec(i)
                break;
            end
        end
        r = rand*ransec(end);
        for j=1:N
            if r<=ransec(j)
                break;
            end
        end
        if i~=j && (~A(i,j)) && (~A(j,i))
            A(i,j) = 1;  %A(j,i) =-1;
        end
        cnt = sum(sum(A==1));
    end
    disc = 0;
    % as long as a node has no in-/out-degree
    for i = 1:N
        if all(A(i,:)==0) && all(A(:,i)==0);  disc=1;  break;  end
    end
    ak = cnt/N;
    A=sparse(A)
end

