function i_min = min_fn(OPEN,OPEN_COUNT,xTarget,yTarget,zTarget,encounter,NP,NP_COUNT)


 temp_array=[];%定义临时矩阵
 k=1;
 flag=0;
 goal_index=0;%目标索引初值为0
 if encounter~=1
    for j=1:OPEN_COUNT%j初值为1，终值为open结点个数
        if (OPEN(j,1)==1)%若该点已经在open表中
            temp_array(k,:)=[OPEN(j,:) j]; %temp_array第k行存可航行点的各种数值（open表第j行）及序号
            if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget && OPEN(j,4)==zTarget)
                flag=1;%在open表中找到目标点
                goal_index=j;%记下序号
            end;
            k=k+1;
        end;
    end;%获得所有在open表中的点
    
 else
    for j=1:OPEN_COUNT%j初值为1，终值为open结点个数
        f=0;
        for t=1:NP_COUNT
            if (OPEN(j,1)~=1 || ( OPEN(j,2)==NP(t,1) && OPEN(j,3)==NP(t,2) && OPEN(j,4)==NP(t,3) ))%若该点已经在open表中
                f=1;
            end
        end

        if f==0 %若该点在表中且不为NP点
            temp_array(k,:)=[OPEN(j,:) j]; %temp_array第k行存可航行点的各种数值（open表第j行）及序号
            if (OPEN(j,2)==xTarget && OPEN(j,3)==yTarget && OPEN(j,4)==zTarget)
                flag=1;%在open表中找到目标点
                goal_index=j;%记下序号
            end;
            k=k+1;
        end
    end
 end%获得所有在open表中的点

 
 
 if flag == 1 %若一个继承点就是目标点 
     i_min=goal_index;%该点序号为返回值
 end

 if size(temp_array ~= 0)
  [min_fn,temp_min]=min(temp_array(:,10));%取temp_array第10列（即fn）最小的向量
  i_min=temp_array(temp_min,11);%取temp_array第11列（即序号）为返回值 
 else
     i_min=-1;%temp_array是空的，即没有可行路径
 end
 
 
 
end