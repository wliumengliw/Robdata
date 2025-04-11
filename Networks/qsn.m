% updated: 15-09-2018

function [A,ak] = qsn(r,N,q,nlink,itop)
% Input: r - 2,3,...
%        N - number of nodes
%        q - probability of snapback, an approximate q is needed
%    nlink - the total number of links
%     itop - initial topology = {'chain'; 'ring'; 'tree'}
% -----  -----  -----  -----  -----  -----  -----
ShowNLink = 0;

    if nargin == 3
        EX_LINK = 0;    %% NOT control the exact number of links
        itop = 'chain';
    elseif nargin == 4
        EX_LINK = 1;    %% DO control the exact number of links by (nlink)
        itop = 'chain';
    elseif nargin == 5 && ~isempty(nlink)
        EX_LINK = 1;    %% DO control the exact number of links by (nlink)
    end
    
    A = zeros(N,N);  %% initial adj_mat
    for rdx = 1:r
        if rdx == 1  %% Start from a directed chain 1 -> 2 -> 3 -> ... -> N
            switch itop
                case 'chain'
                    A = diag(ones(1,N-1),1);  %% i -> (i+1)
                case 'ring'
                    A = diag(ones(1,N-1),1);  %% i -> (i+1)
                    A(N,1) = 1;  %% an initial ring
                case 'tree'
                    for i = 1:N-1
                        A(i,i+randi(N-i)) = 1;
                    end
                    A(N,1) = 1;
            end
        else  %% if rdx > 1  % For node(i), perform snapback
            for i = rdx+1:N  %% those nodes are able to jump back (to certain node with q)
                for j = (i-rdx):-(rdx-1):(rdx-1) %% (i-rdx):-1:(rdx-1)
                    if rand <= q  %%&& mod(i,j) == rdx
                        A(i,j) = 1;
                    end
                end
            end
        end
    end
    if ShowNLink;  disp(['Generated QSN with ',int2str(sum(sum(A==1))),' links.']);  end

% -----| Control Exact Number of Links |----- %
    if EX_LINK
       cnt = sum(sum(A==1));  %% # links counter
       deltaE = cnt - nlink;
       if deltaE > 0
           if ShowNLink;  disp(['deleting ',int2str(deltaE),' links ...']);  end
           for i=1:deltaE
               delete_alink
           end
       elseif deltaE < 0
           deltaE = abs(deltaE);
           if ShowNLink;  disp(['adding ',int2str(deltaE),' links ...']);  end
           for i=1:deltaE
               add_alink
           end
       end
    end
    ak = sum(sum(A==1))/(N);
    if ShowNLink
        disp(['Finally QSN with ',int2str(sum(sum(A==1))),' links.'])
    end
    A=sparse(A)
% -----| Control Exact Number of Links |----- %
% % ----- no need check 'disc' ----- %
%     disc = 0;
%     % as long as a node has no in-/out-degree
%     for i = 1:N
%         if all(A(i,:)==0) && all(A(:,i)==0);  disc=1;  break;  end
%     end

% ----- Functions ----- %
    function add_alink
        idx = randi(N);
        list = find(A(idx,1:idx-2)==0);
        while isempty(list)
            idx = randi(N);
            list = find(A(idx,1:(idx-2))==0);
        end
        jdx = list(randi(length(list)));
        A(idx,jdx) = 1;
    end

    function delete_alink
        idx = randi(N);
        list = find(A(idx,1:idx-2)==1);
        while isempty(list)
            idx = randi(N);
            list = find(A(idx,1:idx-2)==1);
        end
        jdx = list(randi(length(list)));
        A(idx,jdx) = 0;
    end

end

