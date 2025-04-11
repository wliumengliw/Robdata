% -----  -----  -----  -----  -----  -----  -----  -----  ----- 
% bi-connection attachment network
% or random triangle network
% -----  -----  -----  -----  -----  -----  -----  -----  ----- 
% updated: 14-09-2018

function [A,ak,disc] = rtn(N,nlink,str)
%[A,ak,disc] = rtn(N,nlink)
ShowNLink = 0;
Tri = 3;

    MODIFY_LINK = 1;
    if nargin==1
        MODIFY_LINK = 0;  str = 'loop';  %% pure triangles 
    elseif nargin==2
        str = 'loop';
    end
    A = zeros(N,N);
    for idx=1:Tri
        A(idx,mod(idx,Tri)+1) = 1;  %% form a Loop
    end
    for idx = Tri+1:1:N
        jdx = randi(idx-1);
        neb = [find(A(jdx,:)==1),find(A(:,jdx)==1)'];
        len_neb = length(neb);
        if length(unique(neb)) < len_neb;  error('check the A matrix ... ');  end
        kdx = neb(randi(len_neb));
        if A(kdx,jdx)
            tmpv = kdx;  kdx = jdx;  jdx = tmpv;
        end
        A(idx,jdx) = 1;  %% idx -> jdx -> kdx (-> idx)
        A(kdx,idx) = 1;
        if ~strcmp(str,'loop')
            if rand < 0.5  % destroy the loop
                A(idx,jdx) = 0;  A(jdx,idx) = 1;
            end
            if rand < 0.5
                A(kdx,idx) = 0;  A(idx,kdx) = 1;
            end
        end
    end
    
    % -----| Control Exact Number of Links |----- %
    if MODIFY_LINK
        cnt = sum(sum(A==1));  %% # links counter
        deltaE = cnt - nlink;
        if deltaE > 0
            if ShowNLink;  disp(['deleting ',int2str(deltaE),' links ...']);  end
            while cnt > nlink
                delete_alink
                cnt = sum(sum(A==1));  %% # links counter
            end
        elseif deltaE < 0
            deltaE = abs(deltaE);
            if ShowNLink;  disp(['adding ',int2str(deltaE),' links ...']);  end
            while cnt < nlink
                add_alink  %% add 2 links each time
                cnt = sum(sum(A==1));  %% # links counter
            end
            while cnt > nlink
                delete_alink  %% delete 1 link each time
                cnt = sum(sum(A==1));  %% # links counter
            end
        end
    end
    ak = sum(sum(A==1))/(N);
    if ShowNLink
        disp(['Required # of Links ''nlink'' = ',int2str(nlink),';'])
        disp(['Generated Random Triangle with ' ,int2str(sum(sum(A==1))),' Links.'])
    end
    disc = 0;
    % as long as a node has no in-/out-degree
    for i = 1:N
        if all(A(i,:)==0) && all(A(:,i)==0);  disc=1;  break;  end
    end
    A=sparse(A)
% -----| control exact number of links |----- %
% -----| add 2 edges each time         |----- %
% -----| delete 1 edges each time      |----- %
    function add_alink
        r = randperm(N,2);
        r1 = r(1);  r2 = r(2);
        while A(r1,r2) || A(r2,r1);  r = randperm(N,2);  r1 = r(1);  r2 = r(2);  end
        neb1 = [find(A(r2,:)==1),find(A(:,r2)==1)'];
        len_neb1 = length(neb1);
        if length(unique(neb1)) < len_neb1
            error('check the A matrix ... ');
        end
        r3 = neb1(randi(len_neb1));
        if A(r3,r2)  %% r3 -> r2
            A(r2,r1) = 1;
            if ~A(r1,r3) && ~A(r3,r1);  A(r1,r3) = 1;  end
        else  %% default r2 -> r3
            A(r1,r2) = 1;
            if ~A(r1,r3) && ~A(r3,r1);  A(r3,r1) = 1;  end
        end
        if ~strcmp(str,'loop')
            if rand < 0.5
                A(r1,r2) = ~A(r1,r2);
                A(r2,r1) = ~A(r2,r1);
            end
            if rand < 0.5
                A(r1,r3) = ~A(r1,r3);
                A(r3,r1) = ~A(r3,r1);
            end
        end
    end

    function delete_alink
        r1 = randi(N);
        neb1 = [find(A(r1,:)==1),find(A(:,r1)==1)'];
        len_neb1 = length(neb1);
        if length(unique(neb1)) < len_neb1;  error('check the A matrix ... ');  end
        r2 = neb1(randi(len_neb1));  %% default r2 -> r3
        A(r1,r2) = 0;
        A(r2,r1) = 0;
    end

end

