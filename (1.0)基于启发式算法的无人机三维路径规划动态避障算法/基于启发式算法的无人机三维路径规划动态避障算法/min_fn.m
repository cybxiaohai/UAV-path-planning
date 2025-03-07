function i_min = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget,encounter,NP,NP_COUNT)

%  功能：在OPEN列表中查找具有最小f(n)值的节点
%  输入：
%    - OPEN：OPEN列表，包含待扩展的节点
%    - OPEN_COUNT：OPEN列表中的节点数量
%    - xTarget：目标点x坐标
%    - yTarget：目标点y坐标
%    - zTarget：目标点z坐标
%    - encounter：是否遇到NP点的标志
%    - NP：NP点列表
%    - NP_COUNT：NP点数量
%  输出：
%    - i_min：具有最小f(n)值的节点在OPEN列表中的索引



% 初始化临时数组
temp_array=[];
k=1;
flag=0;
goal_index=0;

if encounter~=1
    % 未遇到NP点
    for j=1:OPEN_COUNT
        if (OPEN(j,1)==1)
            temp_array(k,:)=[OPEN(j,:) j];
            % 检查是否为目标点
            if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget && OPEN(j,4)==zTarget)
                flag=1;
                goal_index=j;
            end
            k=k+1;
        end
    end
else
    % 遇到NP点
    for j=1:OPEN_COUNT
        f=0;
        for t=1:NP_COUNT
            if (OPEN(j,1)~=1 || ( OPEN(j,2)==NP(t,1) && OPEN(j,3)==NP(t,2) && OPEN(j,4)==NP(t,3) ))
                f=1;
            end
        end

        % 如果不是NP点，加入临时数组
        if f==0
            temp_array(k,:)=[OPEN(j,:) j];
            if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget && OPEN(j,4)==zTarget)
                flag=1;
                goal_index=j;
            end
            k=k+1;
        end
    end
end

% 如果找到目标点，直接返回其索引
if flag == 1
    i_min=goal_index;
end

% 在临时数组中查找f(n)最小的节点，返回其索引
if size(temp_array ~= 0)
    [min_fn,temp_min]=min(temp_array(:,10));
    i_min=temp_array(temp_min,11);
else
    i_min=-1;
end
end