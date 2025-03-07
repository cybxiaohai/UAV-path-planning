%A_Star(xNode,yNode,zNode,xTarget,yTarget,zTarget,xB1,xB2,yB1,yB2,zB1,zB2,MAP)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LISTS USED FOR ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%OPEN表的结构为：
%--------------------------------------------------------------------------------------------------
%IS ON LIST 1/0 |X val |Y val |Z val |Parent X val |Parent Y val |Parent Z val |h(n) |g(n) |f(n) |
%--------------------------------------------------------------------------------------------------
OPEN=[];%定义open表

%CLOSED表的结构为：
%------------------------
%X val | Y val | Z val |
%------------------------
% CLOSED=zeros(MAX_VAL,3); 元素均为0的10x3的矩阵
CLOSED=[];%定义closed表
%CLOSED = zeros(MAX_X * MAX_Y * MAX_Z, 3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CLOSED_COUNT=size(CLOSED,1); %CLOSED_COUNT为矩阵CLOSED行的个数（1表示行，2表示列）
OPEN_COUNT=1; 
goal_distance=distance(xNode,yNode,zNode,xTarget,yTarget,zTarget); %目标距离即hn,为distance函数返回值
%goal_distance = distance(xNode, yNode, zNode, xTarget, yTarget, zTarget, MAX_X, MAX_Y, MAX_Z);
OPEN(OPEN_COUNT,:)=insert_open(xNode,yNode,zNode,xNode,yNode,zNode,path_cost,goal_distance,goal_distance); %起始点存入open第一行
OPEN(OPEN_COUNT,1)=0; %起始点从open表删除 
CLOSED_COUNT=CLOSED_COUNT+1; 
CLOSED(CLOSED_COUNT,1)=xNode;%起始点存入closed最后+1行
CLOSED(CLOSED_COUNT,2)=yNode;
CLOSED(CLOSED_COUNT,3)=zNode;
NoPath=1;% 路径存在与否，初始值——不存在

%%%%%%%%%%%%%%将所有障碍点放到closed表%%%%%%%%%%%%%
for i=xB1:xB2
        for j=yB1:yB2
            for s=zB1:zB2
                if(MAP(i,j,s) == -1) %若判断为障碍点
%                    MAP(i,j,s)=-2;%表示已经存入该障碍点信息
                    CLOSED_COUNT=CLOSED_COUNT+1;
                    CLOSED(CLOSED_COUNT,1)=i; %x坐标存到closed中
                    CLOSED(CLOSED_COUNT,2)=j; 
                    CLOSED(CLOSED_COUNT,3)=s; 
                end
            end
        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START ALGORITHM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%while((xNode ~= xTarget || yNode ~= yTarget || zNode ~= zTarget) && NoPath == 1)


    exp_array=expand_array(xNode,yNode,zNode,path_cost,xTarget,yTarget,zTarget,CLOSED,xB1,xB2,yB1,yB2,zB1,zB2,MAX_X,MAX_Y,MAX_Z);
    %----------------------起始点xyz坐标，    0，       目标点xyz坐标，          closed表，10,10,10
    exp_count=size(exp_array,1);%exp_count为相邻点的个数
 
    %OPEN表的结构
    %--------------------------------------------------------------------------------------------------
    %IS ON LIST 1/0 |X val |Y val |Z val |Parent X val |Parent Y val |Parent Z val |g(n) |h(n) |f(n) |
    %--------------------------------------------------------------------------------------------------
    %EXPANDED ARRAY 的结构
    %------------------------------------------
    %|X val |Y val |Z val ||g(n) |h(n) |f(n) |
    %------------------------------------------
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%用可通过的结点更新OPEN表，用经过的结点更新CLOSED表%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%拓展结点空间%%%%%%%%%%%% 
    
    for i=1:exp_count
%%%%%%%%%%%%%%%%%%%%%%%%%%这段都可以不要了%%%%%%%%开始%%%%%%%%%%%%%%%%%%%%        
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
            end;
        end;
        if flag == 0 % 如果OPEN表没有exp该点，将其添加进去，并将node作为新结点的双亲结点
%%%%%%%%%%%%%%%%%%%%%%%%%%%结束%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
           OPEN_COUNT = OPEN_COUNT+1;
           OPEN(OPEN_COUNT,:)=insert_open(exp_array(i,1),exp_array(i,2),exp_array(i,3),xNode,yNode,zNode,exp_array(i,4),exp_array(i,5),exp_array(i,6));
        end;%插入新元素到open中
    end;
 
   %%%%%%%%%%找到fn最小的下一个航路点，转移%%%%%%%%%
    index_min_node = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget,encounter,NP,NP_COUNT);
    
    
    if (index_min_node ~= -1) %若索引最小点不为-1即存在到达目标点的路径
   %%%%%%%%将当前点转移到fn最小的点上%%%%%%%%%
        xNode=OPEN(index_min_node,2);
        yNode=OPEN(index_min_node,3);
        zNode=OPEN(index_min_node,4);
        path_cost=OPEN(index_min_node,8);%Update the cost of reaching the parent node 更新到达双亲结点的代价，即gn
   %%%%%%%将结点移到closed中%%%%%%%%
   %     CLOSED_COUNT=CLOSED_COUNT+1;
   %     CLOSED(CLOSED_COUNT,1)=xNode; 
   %     CLOSED(CLOSED_COUNT,2)=yNode;
   %     CLOSED(CLOSED_COUNT,3)=zNode;
   %     OPEN(index_min_node,1)=0;%OPEN表中删除该点，is on list=0
    else
        NoPath=0;%退出循环
    end;
    
%end



    





