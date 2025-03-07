%  功能：实现全局路径规划，生成从起始点到目标点的完整路径
%  输入：
%    - 使用全局变量中的地图信息、起始点和目标点
%  输出：
%    - Optimal_path：最优路径点序列
%  说明：
%    - 使用A*算法进行全局路径规划
%    - 包含路径可视化功能


%% 初始化OPEN和CLOSED列表
OPEN=[];
CLOSED=[];

%% 将障碍物加入CLOSED列表
k=1;
for i=1:MAX_X
    for j=1:MAX_Y
        for s=1:MAX_Z
            if(MAP(i,j,s) == -1 || MAP(i,j,s)==-2)
               CLOSED(k,1)=i;
               CLOSED(k,2)=j;
               CLOSED(k,3)=s;
               k=k+1;
            end
        end
    end
end

%% 初始化搜索参数
CLOSED_COUNT=size(CLOSED,1);
xNode=xStart;
yNode=yStart;
zNode=zStart;
OPEN_COUNT=1;
path_cost=0;
goal_distance=distance(xNode,yNode,zNode,xTarget,yTarget,zTarget);

%% 将起始节点加入OPEN列表
OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,zNode,xNode,yNode,zNode,path_cost,goal_distance,goal_distance);
OPEN(OPEN_COUNT,1)=0;
CLOSED_COUNT=CLOSED_COUNT+1;
CLOSED(CLOSED_COUNT,1)=xNode;
CLOSED(CLOSED_COUNT,2)=yNode;
CLOSED(CLOSED_COUNT,3)=zNode;
NoPath=1;

%% 主循环：寻找路径
while((xNode ~= xTarget || yNode ~= yTarget || zNode ~= zTarget) && NoPath == 1)
    % 扩展当前节点
    exp_array=expand_array_global(xNode,yNode,zNode,path_cost,xTarget,yTarget,zTarget,CLOSED,MAX_X,MAX_Y,MAX_Z);
    exp_count=size(exp_array,1);

    % 处理扩展节点
    for i=1:exp_count
        flag=0;
        for j=1:OPEN_COUNT
            if(exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3) && exp_array(i,3) == OPEN(j,4))
                OPEN(j,10)=min(OPEN(j,10),exp_array(i,6));
                if OPEN(j,10)== exp_array(i,6)
                    OPEN(j,5)=xNode;
                    OPEN(j,6)=yNode;
                    OPEN(j,7)=zNode;
                    OPEN(j,8)=exp_array(i,4);
                    OPEN(j,9)=exp_array(i,5);
                end
                flag=1;
            end
        end
        if flag == 0
            OPEN_COUNT = OPEN_COUNT+1;
            OPEN(OPEN_COUNT,:)=insert_open(exp_array(i,1),exp_array(i,2),exp_array(i,3),xNode,yNode,zNode,exp_array(i,4),exp_array(i,5),exp_array(i,6));
        end
    end

    % 查找最小f(n)值的节点
    index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget,0,0,0);
    
    % 更新当前节点
    if (index_min_node ~= -1)
        xNode=OPEN(index_min_node,2);
        yNode=OPEN(index_min_node,3);
        zNode=OPEN(index_min_node,4);
        path_cost=OPEN(index_min_node,8);
        CLOSED_COUNT=CLOSED_COUNT+1;
        CLOSED(CLOSED_COUNT,1)=xNode;
        CLOSED(CLOSED_COUNT,2)=yNode;
        CLOSED(CLOSED_COUNT,3)=zNode;
        OPEN(index_min_node,1)=0;
    else
        NoPath=0;
    end
end

%% 构建最优路径
i=size(CLOSED,1);
xval=CLOSED(i,1);
yval=CLOSED(i,2);
zval=CLOSED(i,3);
i=1;
Optimal_path=[];
Optimal_path(i,1)=xval;
Optimal_path(i,2)=yval;
Optimal_path(i,3)=zval;
i=i+1;

%% 回溯路径
if ((xval == xTarget) && (yval == yTarget) && (zval == zTarget))
    inode=0;
    parent_x=OPEN(node_index(OPEN,xval,yval,zval),5);
    parent_y=OPEN(node_index(OPEN,xval,yval,zval),6);
    parent_z=OPEN(node_index(OPEN,xval,yval,zval),7);
   
    while(parent_x ~= xStart || parent_y ~= yStart || parent_z ~= zStart)
        Optimal_path(i,1) = parent_x;
        Optimal_path(i,2) = parent_y;
        Optimal_path(i,3) = parent_z;
        inode=node_index(OPEN,parent_x,parent_y,parent_z);
        parent_x=OPEN(inode,5);
        parent_y=OPEN(inode,6);
        parent_z=OPEN(inode,7);
        i=i+1;
    end
    
    %% 可视化路径
    [x,y,z]=sphere(50);
    r=1.45;
    plot3(xStart+.5,yStart+.5,zStart+.5,'bo','MarkerFaceColor','b','MarkerSize',7);
    
    j=size(Optimal_path,1);
    Optimal_path(j+1,1)=xStart;
    Optimal_path(j+1,2)=yStart;
    Optimal_path(j+1,3)=zStart;
    j=size(Optimal_path,1);
    p=plot3(Optimal_path(j,1)+.5,Optimal_path(j,2)+.5,Optimal_path(j,3)+.5,'o','MarkerFaceColor','g','MarkerSize',7);
    
    % 动态显示路径
    j=j-1;
    for i=j:-1:1
        pause(.25);
        set(p,'XData',Optimal_path(i,1)+.5,'YData',Optimal_path(i,2)+.5,'ZData',Optimal_path(i,3)+.5);
        drawnow;
    end
    
    % 显示平滑路径
    values = spcrv([Optimal_path(:,1)'+.5;Optimal_path(:,2)'+.5;Optimal_path(:,3)'+.5],3);
    h=plot3(values(1,:),values(2,:),values(3,:),'m','LineWidth',2);
end

