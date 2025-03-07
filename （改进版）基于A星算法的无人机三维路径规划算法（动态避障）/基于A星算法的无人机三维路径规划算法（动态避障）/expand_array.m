function exp_array=expand_array(node_x,node_y,node_z,gn,xTarget,yTarget,zTarget,CLOSED,xB1,xB2,yB1,yB2,zB1,zB2,MAX_X,MAX_Y,MAX_Z)%输入结点xy坐标，gn，目标xy坐标，closed表，xy坐标最大值

    
    exp_array=[];%定义输出数组
    exp_count=1;%输出计数初始值为1
    c2=size(CLOSED,1);% c2为closed中结点的个数，包括起始点
    for k= 1:-1:-1%x轴增加值，初值为1，步长-1，终值-1
        for j= 1:-1:-1
            for i= 1:-1:-1  % 搜索一个结点相邻的几个点
                if (k~=j || k~=i || k~=0)% k=j=0时为假（1,1；1,0；0,1；），即不是当前点时继续
                    s_x = node_x+k;
                    s_y = node_y+j;
                    s_z = node_z+i;
                    if (s_x > 0 && s_x <= MAX_X) && (s_y > 0 && s_y <= MAX_Y) && (s_z > 0 && s_z <= MAX_Z)%if( (s_x >=xB1 && s_x <=xB2) && (s_y >=yB1 && s_y <=yB2) && (s_z >=zB1 && s_z <=zB2))%判断结点是否在网格界限内（xy坐标大于0且小于最大限）
                        flag=1;%标记为可通行                    
                        for c1=1:c2
                            if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))%若搜索点在closed中
                               flag=0;%标记为障碍点
                            end;
                        end;% 检查搜索点是否在closed中
                        if (flag == 1)% 若可通行且不在closed里
                            exp_array(exp_count,1) = s_x;%坐标取搜索点的坐标
                            exp_array(exp_count,2) = s_y;
                            exp_array(exp_count,3) = s_z;
                            exp_array(exp_count,4) = gn+distance(node_x,node_y,node_z,s_x,s_y,s_z);%gn等于原gn加当前点到搜索点的距离
                            exp_array(exp_count,5) = distance(xTarget,yTarget,zTarget,s_x,s_y,s_z);%hn等于distance计算出的搜索点到目标点的距离
                            exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);%fn=hn+gn
                            exp_count=exp_count+1;
                        end%生成了exp表
                    end
                end
            end%%%%%%%%%%%%i loop
        end
    end 