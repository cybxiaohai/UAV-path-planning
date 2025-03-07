%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  LISTS USED FOR ALGORITHM
%  输入：
%    - 使用全局变量中的地图信息、起始点和目标点
%  输出：
%    - Optimal_path：最优路径点序列
%  说明：
%    - 使用A*算法进行全局路径规划
%    - 包含路径可视化功能

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
OPEN=[];%定义open表
CLOSED=[];%定义closed表

%%%%%%%%%%%%%%将所有障碍点放到closed表%%%%%%%%%%%%%
k=1;%虚拟计数器
for i=1:MAX_X
    for j=1:MAX_Y
        for s=1:MAX_Z
            if(MAP(i,j,s) == -1 || MAP(i,j,s)==-2) %若判断为障碍点
               CLOSED(k,1)=i; %x坐标存到closed中
               CLOSED(k,2)=j; 
               CLOSED(k,3)=s; 
               k=k+1;
            end
        end
    end
end

CLOSED_COUNT=size(CLOSED,1); %CLOSED_COUNT为矩阵CLOSED行的个数（1表示行，2表示列）

xNode=xStart; 
yNode=yStart;
zNode=zStart;
OPEN_COUNT=1; 
path_cost=0; %路径代价初值设为0，即gn=0
goal_distance=distance(xNode,yNode,zNode,xTarget,yTarget,zTarget); %目标距离即hn,为distance函数返回值
OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,zNode,xNode,yNode,zNode,path_cost,goal_distance,goal_distance); %起始点存入open第一行
OPEN(OPEN_COUNT,1)=0; %起始点不在open表上
CLOSED_COUNT=CLOSED_COUNT+1; 
CLOSED(CLOSED_COUNT,1)=xNode;%起始点存入closed最后+1行
CLOSED(CLOSED_COUNT,2)=yNode;
CLOSED(CLOSED_COUNT,3)=zNode;
NoPath=1;% 路径存在与否，初始值——不存在

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while((xNode ~= xTarget || yNode ~= yTarget || zNode ~= zTarget) && NoPath == 1)%x坐标或y坐标不等于目标点且
    exp_array=expand_array_global(xNode,yNode,zNode,path_cost,xTarget,yTarget,zTarget,CLOSED,MAX_X,MAX_Y,MAX_Z);
    exp_count=size(exp_array,1);%exp_count为相邻点的个数

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%用可通过的结点更新OPEN表，用经过的结点更新CLOSED表%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%拓展结点空间%%%%%%%%%%%% 
    for i=1:exp_count
        flag=0;
        for j=1:OPEN_COUNT
            if(exp_array(i,1) == OPEN(j,2) && exp_array(i,2) == OPEN(j,3) && exp_array(i,3) == OPEN(j,4) )%若exp与open中的x坐标相等且y坐标也相等
               OPEN(j,10)=min(OPEN(j,10),exp_array(i,6)); % fn取open与exp表中最小的一个
               if OPEN(j,10)== exp_array(i,6)%若open与exp中的fn相等
                %更新双亲结点，gn，hn
                  OPEN(j,5)=xNode;%open中双亲结点更新为当前点
                  OPEN(j,6)=yNode;
                  OPEN(j,7)=zNode;
                  OPEN(j,8)=exp_array(i,4);%open中gn更新为exp中gn
                  OPEN(j,9)=exp_array(i,5);%hn
               end;%最小fn查找
               flag=1;
            end
        end
        if flag == 0 % 如果OPEN表没有exp该点，将其添加进去，并将node作为新结点的双亲结点
           OPEN_COUNT = OPEN_COUNT+1;
           OPEN(OPEN_COUNT,:)=insert_open(exp_array(i,1),exp_array(i,2),exp_array(i,3),xNode,yNode,zNode,exp_array(i,4),exp_array(i,5),exp_array(i,6));
        end;%插入新元素到open中
    end;
 
   %%%%%%%%%%找到fn最小的下一个航路点，转移%%%%%%%%%
    index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget,0,0,0);
   
    %%%%%%%%防止航迹擦边%%%%%%%%
%    if abs(OPEN(index_min_node,2)-xNode)==1 && abs(OPEN(index_min_node,3)-yNode)==1 
%        if MAP(xNode,OPEN(index_min_node,3),OPEN(index_min_node,4))<0 && MAP(OPEN(index_min_node,2),yNode,OPEN(index_min_node,4))>=0
%            OPEN(index_min_node,3)=yNode;  
%        else
%            if MAP(OPEN(index_min_node,2),yNode,OPEN(index_min_node,4))<0 && MAP(xNode,OPEN(index_min_node,3),OPEN(index_min_node,4))>=0
%               OPEN(index_min_node,2)=xNode;
%            else
%                if MAP(OPEN(index_min_node,2),yNode,OPEN(index_min_node,4))<0 && MAP(yNode,OPEN(index_min_node,3),OPEN(index_min_node,4))<0
%                   
%                end
%            end  
%        end
%    end
    %%%%%%%%%%%%%%%%%%%%%%%%%
    
    if (index_min_node ~= -1) %若索引最小点不为-1即存在到达目标点的路径
   %%%%%%%%将当前点转移到fn最小的点上%%%%%%%%%
        xNode=OPEN(index_min_node,2);
        yNode=OPEN(index_min_node,3);
        zNode=OPEN(index_min_node,4);
        path_cost=OPEN(index_min_node,8);%Update the cost of reaching the parent node 更新到达双亲结点的代价，即gn
   %%%%%%%将结点移到closed中%%%%%%%%
        CLOSED_COUNT=CLOSED_COUNT+1;
        CLOSED(CLOSED_COUNT,1)=xNode; 
        CLOSED(CLOSED_COUNT,2)=yNode;
        CLOSED(CLOSED_COUNT,3)=zNode;
        OPEN(index_min_node,1)=0;%OPEN表中删除该点，is on list=0
    else
        NoPath=0;%退出循环
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%从最后一个航路点开始反向到达起始点，更新Optimal_path%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=size(CLOSED,1);
xval=CLOSED(i,1);
yval=CLOSED(i,2);
zval=CLOSED(i,3);
i=1;
Optimal_path=[];
Optimal_path(i,1)=xval; % 先把最后经过的航路点加入路径中
Optimal_path(i,2)=yval;
Optimal_path(i,3)=zval;
i=i+1;

%%%%%%%%%通过双亲结点将每个航路点反向存入Optimal_path中%%%%%%%%%%%%%%
if ( (xval == xTarget) && (yval == yTarget) && (zval == zTarget))
    inode=0;
  
    parent_x=OPEN(node_index(OPEN,xval,yval,zval),5);
    parent_y=OPEN(node_index(OPEN,xval,yval,zval),6);
    parent_z=OPEN(node_index(OPEN,xval,yval,zval),7);
   
    while( parent_x ~= xStart || parent_y ~= yStart || parent_z ~= zStart)%当双亲结点不是起始点时
           Optimal_path(i,1) = parent_x;
           Optimal_path(i,2) = parent_y;
           Optimal_path(i,3) = parent_z;
           %找到祖父母结点
           inode=node_index(OPEN,parent_x,parent_y,parent_z);
           parent_x=OPEN(inode,5);
           parent_y=OPEN(inode,6);
           parent_z=OPEN(inode,7);
           i=i+1;
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%显示全局规划路径%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [x,y,z]=sphere(50);%括号内数值是光滑度？
    r=1.45;
 
    plot3(xStart+.5,yStart+.5,zStart+.5,'bo','MarkerFaceColor','b','MarkerSize',7);%显示起始点 
 
    j=size(Optimal_path,1);
    Optimal_path(j+1,1)=xStart;
    Optimal_path(j+1,2)=yStart;
    Optimal_path(j+1,3)=zStart;
    j=size(Optimal_path,1);
    p=plot3(Optimal_path(j,1)+.5,Optimal_path(j,2)+.5,Optimal_path(j,3)+.5,'o','MarkerFaceColor','g','MarkerSize',7);%显示第一个航路点

    
 %%%%%%%%%%%%%%%%%%正向动态显示航路点%%%%%%%%%%%%%%%%%%%
    j=j-1;
    for i=j:-1:1%递减
        pause(.25);
        set(p,'XData',Optimal_path(i,1)+.5,'YData',Optimal_path(i,2)+.5,'ZData',Optimal_path(i,3)+.5);
        drawnow ;
    end
    
    %%%%%%%%%%%%%%%%%%显示航迹%%%%%%%%%%%%%%%%%%%%%
    values = spcrv([Optimal_path(:,1)'+.5;Optimal_path(:,2)'+.5;Optimal_path(:,3)'+.5],3);
    h=plot3(values(1,:),values(2,:),values(3,:),'m','LineWidth',2); % 显示平滑轨迹
end

