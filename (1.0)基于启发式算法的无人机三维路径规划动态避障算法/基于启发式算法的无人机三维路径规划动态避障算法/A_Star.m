%  文件名称：A_Star.m
%  功能：实现A*算法的局部路径规划
%  输入：
%    - xNode, yNode, zNode：当前节点坐标
%    - xTarget, yTarget, zTarget：目标点坐标
%    - xB1, xB2, yB1, yB2, zB1, zB2：搜索范围边界
%    - MAP：环境地图
%  输出：
%    - 更新后的路径点和状态
%  说明：
%    - OPEN列表结构：[IS_ON_LIST, X, Y, Z, PARENT_X, PARENT_Y, PARENT_Z, g(n), h(n), f(n)]
%    - CLOSED列表结构：[X, Y, Z]

%% 初始化OPEN和CLOSED列表
OPEN=[];
CLOSED=[];

%% 初始化计数器和状态
CLOSED_COUNT=size(CLOSED,1);
OPEN_COUNT=1;
goal_distance=distance(xNode,yNode,zNode,xTarget,yTarget,zTarget);

%% 将起始节点加入OPEN列表
OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,zNode,xNode,yNode,zNode,path_cost,goal_distance,goal_distance);
OPEN(OPEN_COUNT,1)=0;
CLOSED_COUNT=CLOSED_COUNT+1;
CLOSED(CLOSED_COUNT,1)=xNode;
CLOSED(CLOSED_COUNT,2)=yNode;
CLOSED(CLOSED_COUNT,3)=zNode;
NoPath=1;

%% 将障碍物加入CLOSED列表
for i=xB1:xB2
    for j=yB1:yB2
        for s=zB1:zB2
            if(MAP(i,j,s) == -1)
                CLOSED_COUNT=CLOSED_COUNT+1;
                CLOSED(CLOSED_COUNT,1)=i;
                CLOSED(CLOSED_COUNT,2)=j;
                CLOSED(CLOSED_COUNT,3)=s;
            end
        end
    end
end

%% 扩展当前节点
exp_array=expand_array(xNode,yNode,zNode,path_cost,xTarget,yTarget,zTarget,CLOSED,xB1,xB2,yB1,yB2,zB1,zB2);
exp_count=size(exp_array,1);

%% 处理扩展节点
for i=1:exp_count
    flag=0;
    % 检查节点是否已在OPEN列表中
    for j=1:OPEN_COUNT
        if(exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3) && exp_array(i,3) == OPEN(j,4))
            % 更新代价值
            OPEN(j,10)=min(OPEN(j,10),exp_array(i,6));
            if OPEN(j,10)== exp_array(i,6)
                % 更新父节点和代价
                OPEN(j,5)=xNode;
                OPEN(j,6)=yNode;
                OPEN(j,7)=zNode;
                OPEN(j,8)=exp_array(i,4);
                OPEN(j,9)=exp_array(i,5);
            end
            flag=1;
        end
    end
    
    % 如果节点不在OPEN列表中
    if flag == 0
        OPEN_COUNT = OPEN_COUNT+1;
        OPEN(OPEN_COUNT,:)=insert_open(exp_array(i,1),exp_array(i,2),exp_array(i,3),xNode,yNode,zNode,exp_array(i,4),exp_array(i,5),exp_array(i,6));
    end
end

%% 查找最小f(n)值的节点
index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget,encounter,NP,NP_COUNT);

%% 更新当前节点
if (index_min_node ~= -1)
    xNode=OPEN(index_min_node,2);
    yNode=OPEN(index_min_node,3);
    zNode=OPEN(index_min_node,4);
    path_cost=OPEN(index_min_node,8);
else
    NoPath=0;
end

