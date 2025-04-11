% -----  -----  -----  -----  -----  -----  -----  -----  ----- 
% random hexagon network
% updated: 12-Dec-2021
% -----  -----  -----  -----  -----  -----  -----  -----  ----- 
function adj=rh(n,m)
% -----  -----  -----  -----  -----  -----  -----  -----  -----
% input:    n - number of nodes
%           m - number of edges
% output: adj - adjacency matrix
%n：节点数量（正整数）。
%m：边数量（正整数）。
% -----  -----  -----  -----  -----  -----  -----  -----  -----
Hex=6;
% --- Step(1): Generate a basic hexagon --- %
    adj=zeros(n,n);
    for idx=1:Hex
        adj(idx,mod(idx,Hex)+1)=1;
    end
% --- Step(2): Add random hexagons --- %
    for idx = Hex+1:4:n   % add 4 nodes each time-step
        jdx=randi(idx-1);
        neb=[find(adj(jdx,:)==1),find(adj(:,jdx)==1)'];
        len_neb=length(neb);
        if length(unique(neb))<len_neb;   error('    .. check !');   end
        kdx=neb(randi(len_neb));
        if adj(kdx,jdx)
            tmpv=kdx;  kdx=jdx;  jdx=tmpv;
        end
        adj(idx,jdx)=1;	% idx -> jdx	% (jdx -> kdx) already existing in the network
        adj(kdx,idx+1)=1;	%   kdx -> idx+1
        adj(idx+1,idx+2)=1;	% idx+1 -> idx+2
        adj(idx+2,idx+3)=1;	% idx+2 -> idx+3
        adj(idx+3,idx)=1;	% idx+3 -> idx	 % Loop: idx -> jdx -> kdx -> idx+1 -> idx+2 -> idx+3 -> idx
    end
    if(size(adj)>=n); adj(n+1:end,:)=[]; adj(:,n+1:end)=[]; end
    if (n-idx)~=0&(n-idx)~=1&(n-idx)~=2&(n-idx)~=3; error('.. check!'); end
    if (n-idx)==2  %% add TWO more nodes
        idx=n-1;
        jdx=randi(n-1);
        neb=[find(adj(jdx,:)==1),find(adj(:,jdx)==1)'];
        len_neb=length(neb);
        if length(unique(neb))<len_neb; error('.. check !'); end
        kdx=neb(randi(len_neb));
        if adj(kdx,jdx)
            tmpv=kdx;  kdx=jdx;  jdx=tmpv;
        end
        adj(idx,idx+1)=1;	% idx -> idx+1 -> jdx -> kdx (-> idx)
        adj(idx+1,jdx)=1;
        adj(kdx,idx)=1;
    end
    if (n-idx)==1  %% add just one more edge, and form a triangle
        idx=n;
        jdx=randi(n-1);
        neb=[find(adj(jdx,:)==1),find(adj(:,jdx)==1)'];
        len_neb=length(neb);
        if length(unique(neb))<len_neb; error('.. check !'); end
        kdx=neb(randi(len_neb));
        if adj(kdx,jdx)
            tmpv=kdx;  kdx=jdx;  jdx=tmpv;
        end
        adj(idx,jdx)=1;	% idx -> jdx -> kdx (-> idx)
        adj(kdx,idx)=1;
    end
% --- Step(3): Control exact number of edges --- %
    cnt=sum(adj,'all');
    deltaE=cnt-m;
    if deltaE>0
        while cnt>m
            delete_edge
            cnt=sum(adj,'all');
        end
    elseif deltaE<0
        while deltaE<-4
            add_edge  % add [0,5] edges per-step
            cnt=sum(adj,'all');
            deltaE=cnt-m;
        end
        if deltaE  %% deltaE <= 4
            while cnt<m
                add_one_edge
                cnt=sum(adj,'all');
            end
        end
    end
    adj=sparse(adj)
% % --- Step(4) Check again (DELETE when it is not necessary anymore) --- %
%     if sum(adj,'all')~=m || graphconncomp(sparse(adj),'Directed',true,'Weak',true)>1
%         error('.. check! ')
%     end

% -----| Auxiliary Functions |----- %
% control exact #edges: add 5 or delete 1 edge each time
    function add_edge
        r1=randi(n);
        neb1=find(adj(r1,:)==0);
        neb1(neb1==r1)=[];
        len_neb1=length(neb1);
        while ~len_neb1
            r1=randi(n);
            neb1=find(adj(r1,:)==0);
            neb1(neb1==r1)=[];
        end
        r2=neb1(randi(len_neb1));
        if ~adj(r2,r1)  %% r1 -> r2
            adj(r1,r2)=1;
        end
        neb1=find(adj(r2,:)==0);
        neb1(neb1==r2)=[];
        len_neb1=length(neb1);
        if length(unique(neb1))<len_neb1; error('.. check !'); end
        if ~len_neb1;  return;  end
        r3=neb1(randi(len_neb1));
        if ~adj(r3,r2)  %% r2 -> r3
            adj(r2,r3)=1;
        end
        neb1=find(adj(r3,:)==0);
        neb1(neb1==r3)=[];
        len_neb1=length(neb1);
        if length(unique(neb1))<len_neb1; error('.. check !'); end
        if ~len_neb1;  return;  end
        r4=neb1(randi(len_neb1));
        if ~adj(r4,r3)  %% r3 -> r4
            adj(r3,r4)=1;
        end
        neb1=find(adj(r4,:)==0);
        neb1(neb1==r4)=[];
        len_neb1=length(neb1);
        if length(unique(neb1))<len_neb1; error('.. check !'); end
        if ~len_neb1;  return;  end
        r5=neb1(randi(len_neb1));
        if ~adj(r5,r4)  %% r4 -> r5
            adj(r4,r5)=1;
        end
        if ~adj(r1,r5)  %% r5 -> r1
            adj(r5,r1)=1;
        end
    end

    function delete_edge
        r1=randi(n);
        neb1=[find(adj(r1,:)==1),find(adj(:,r1)==1)'];
        len_neb1=length(neb1);
        if length(unique(neb1))<len_neb1; error('.. check !'); end
        if(len_neb1)
            r2=neb1(randi(len_neb1));  %% default r2 -> r3
            adj(r1,r2)=0;
            adj(r2,r1)=0;
        end
    end

    function add_one_edge
        r1=randi(n);
        neb1=find(adj(r1,:)==0);
        neb1(neb1==r1)=[];
        len_neb1=length(neb1);
        while ~len_neb1
            r1=randi(n);  neb1=find(adj(r1,:)==0);  neb1(neb1==r1)=[];
        end
        r2=neb1(randi(len_neb1));
        if ~adj(r2,r1)  %% r1 -> r2
            adj(r1,r2)=1;
        end
    end
end

