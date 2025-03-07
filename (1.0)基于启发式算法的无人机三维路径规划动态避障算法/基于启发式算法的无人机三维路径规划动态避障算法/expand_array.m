function exp_array=expand_array(node_x,node_y,node_z,gn,xTarget,yTarget,zTarget,CLOSED,xB1,xB2,yB1,yB2,zB1,zB2)

%  功能：扩展当前节点，生成相邻的可行节点
%  输入：
%    - node_x, node_y, node_z：当前节点坐标
%    - gn：从起始点到当前节点的实际代价
%    - xTarget, yTarget, zTarget：目标点坐标
%    - CLOSED：已访问节点列表
%    - xB1, xB2：x轴搜索范围
%    - yB1, yB2：y轴搜索范围
%    - zB1, zB2：z轴搜索范围
%  输出：
%    - exp_array：扩展节点数组，每行包含[x, y, z, gn, hn, fn]

% 初始化扩展数组
exp_array=[];
exp_count=1;
c2=size(CLOSED,1);

% 遍历相邻节点
for k= 1:-1:-1
    for j= 1:-1:-1
        for i= 1:-1:-1
            if (k~=j || k~=i || k~=0)
                % 计算相邻节点坐标
                s_x = node_x+k;
                s_y = node_y+j;
                s_z = node_z+i;

                % 检查节点是否在搜索范围内
                if( (s_x >=xB1 && s_x <=xB2) && (s_y >=yB1 && s_y <=yB2) && (s_z >=zB1 && s_z <=zB2))
                    flag=1;

                    % 检查节点是否在CLOSED列表中
                    for c1=1:c2
                        if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                            flag=0;
                        end
                    end

                    % 如节点可行，添加到扩展数组
                    if (flag == 1)
                        exp_array(exp_count,1) = s_x;
                        exp_array(exp_count,2) = s_y;
                        exp_array(exp_count,3) = s_z;
                        % 计算代价函数
                        exp_array(exp_count,4) = gn+distance(node_x,node_y,node_z,s_x,s_y,s_z);
                        exp_array(exp_count,5) = distance(xTarget,yTarget,zTarget,s_x,s_y,s_z);
                        exp_array(exp_count,6) = exp_array(exp_count,4)+exp_array(exp_count,5);
                        exp_count=exp_count+1;
                    end
                end
            end
        end
    end
end