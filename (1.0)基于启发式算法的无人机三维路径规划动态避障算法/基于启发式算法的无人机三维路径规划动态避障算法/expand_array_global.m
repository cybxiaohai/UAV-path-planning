function exp_array=expand_array(node_x,node_y,node_z,gn,xTarget,yTarget,zTarget,CLOSED,MAX_X,MAX_Y,MAX_Z)

%  功能：全局路径规划中扩展当前节点，生成相邻的可行节点
%  输入：
%    - node_x, node_y, node_z：当前节点坐标
%    - gn：从起始点到当前节点的实际代价
%    - xTarget, yTarget, zTarget：目标点坐标
%    - CLOSED：已访问节点列表
%    - MAX_X, MAX_Y, MAX_Z：搜索空间的最大范围
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
                if( (s_x >0 && s_x <=MAX_X) && (s_y >0 && s_y <=MAX_Y) && (s_z >0 && s_z <=MAX_Z))
                    flag=1;

                    % 检查节点是否在CLOSED列表中
                    for c1=1:c2
                        if(s_x == CLOSED(c1,1) && s_y == CLOSED(c1,2) && s_z == CLOSED(c1,3))
                            flag=0;
                        end
                    end

                    % 如果节点可行，添加到扩展数组
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