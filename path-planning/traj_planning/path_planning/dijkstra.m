function [path, num_expanded] = dijkstra(map, start, goal, astar)
% DIJKSTRA 寻找从起点到终点的最短路径
%   输入参数:
%   - map: 地图对象,包含占据网格等信息
%   - start: 起点坐标 [x,y,z]
%   - goal: 终点坐标 [x,y,z] 
%   - astar: 布尔值,true表示使用A*算法,false表示使用Dijkstra算法
%
%   输出参数:
%   - path: M×3矩阵,每行包含路径上一个点的(x,y,z)坐标。第一行是起点,最后一行是终点
%   - num_expanded: 搜索过程中访问的节点数量
%
%   注意:路径上相邻点间距不应超过地图网格间距

% 如果没有指定astar参数,默认使用Dijkstra算法
if nargin < 4
    astar = false;
end

% 欧几里得距离启发函数(用于A*算法)
function cost = euclidean_heuristic(start_pos, goal_pos)
    cost = sqrt(sum((double(start_pos) - double(goal_pos)).^2));
end

path = [];
num_expanded = 0;

% 保存原始坐标
start_xyz = start;
goal_xyz = goal;

% 将坐标转换为地图索引
start = points_to_idx(map, start);
goal = points_to_idx(map, goal);

% 初始化距离矩阵
dist = inf(size(map.occ_map)); % 初始化所有距离为无穷大
dist(start(1), start(2), start(3)) = 0; % 起点距离设为0

% 初始化访问状态矩阵(1表示未访问,inf表示已访问)
unvisited = ones(map.nx, map.ny, map.nz);

% 初始化回溯矩阵(用于重建路径)
prev = zeros(size(map.occ_map,1), size(map.occ_map,2), size(map.occ_map,3), 3);

% 定义6连通邻居方向(上下左右前后)
dijk = [1,0,0;-1,0,0; 0,1,0; 0,-1,0; 0,0,1; 0,0,-1];

if astar == false
    % Dijkstra算法实现
    while (~all(unvisited(:)==inf))
        % 在未访问节点中找到距离最小的节点
        dist_unvisited = dist.*unvisited;
        [~, id] = min(dist_unvisited(:));
        % 标记为已访问
        unvisited(id) = inf;
        num_expanded = num_expanded + 1;
        
        % 检查当前节点的6个邻居
        [i,j,k] = ind2sub([map.nx,map.ny,map.nz],id);
        for d = 1:size(dijk,1)
            nijk = bsxfun(@plus, int32([i,j,k]), int32(dijk(d,:)));
            % 检查邻居是否(在地图内)且(未访问)且(非障碍物)
            if all(nijk > 0) & all(int32([map.nx, map.ny, map.nz]) >= int32(nijk)) ...
                & unvisited(nijk(1),nijk(2),nijk(3)) == 1 ...
                & map.occ_map(nijk(1),nijk(2),nijk(3)) ~= 1
                % 计算经过当前节点到达邻居的距离
                alt = dist(id) + sqrt(sum(dijk(d,:).^2));
                % 计算邻居节点的线性索引
                nid = (nijk(3)-1)*map.nx*map.ny + (nijk(2)-1)*map.nx + nijk(1);
                % 如果找到更短路径则更新
                if alt < dist(nid)
                    dist(nid) = alt;
                    prev(nijk(1), nijk(2), nijk(3),:) = [i,j,k];
                end
            end
        end
        % 如果到达目标点则结束搜索
        if id == (goal(3)-1)*map.nx*map.ny + (goal(2)-1)*map.nx + goal(1);
            break
        end
    end
else
    % A*算法实现
    % 初始化f值矩阵(f = g + h)
    fscore = inf(size(map.occ_map));
    fscore(start(1), start(2), start(3)) = euclidean_heuristic(start, goal);
    % 初始化开放集
    openset = inf(size(map.occ_map));
    openset(start(1), start(2), start(3)) = 1;

    while (~all(openset(:)==inf))
        % 在开放集中找到f值最小的节点
        openfscore = fscore.*openset;
        [~, id] = min(openfscore(:));
        
        % 如果找到目标点则结束搜索
        if id == (goal(3)-1)*map.nx*map.ny + (goal(2)-1)*map.nx + goal(1);
            break
        end
        
        % 从开放集中移除当前节点
        openset(id) = inf;
        unvisited(id) = inf;
        num_expanded = num_expanded + 1;
        
        % 检查当前节点的6个邻居
        [i,j,k] = ind2sub([map.nx,map.ny,map.nz],id);
        for d = 1:size(dijk,1)
            nijk = bsxfun(@plus, int32([i,j,k]), int32(dijk(d,:)));
            % 检查邻居是否(在地图内)且(未访问)且(非障碍物)
            if all(nijk > 0) & all(int32([map.nx, map.ny, map.nz]) >= int32(nijk)) ...
                & unvisited(nijk(1),nijk(2),nijk(3)) == 1 ...
                & map.occ_map(nijk(1),nijk(2),nijk(3)) ~= 1
                % 计算从起点经过当前节点到达邻居的距离(g值)
                nid = (nijk(3)-1)*map.nx*map.ny + (nijk(2)-1)*map.nx + nijk(1);
                gscore = dist(id) + sqrt(sum(dijk(d,:).^2));
                
                % 如果邻居不在开放集中则添加
                if openset(nid) == inf
                    openset(nid) = 1;
                elseif gscore >= dist(nid)
                    % 如果新路径不比已知路径更好则跳过
                    continue
                end
                
                % 更新最佳路径
                prev(nijk(1), nijk(2), nijk(3),:) = [i,j,k];
                dist(nid) = gscore;
                % 更新f值(f = g + h)
                fscore(nid) = dist(nid) + euclidean_heuristic(nijk, goal);
            end
        end
    end
end

% 路径重建
if dist(goal(1), goal(2), goal(3)) == inf
    % 如果没有找到路径则返回空路径
    path = [];
else
    % 从目标点开始回溯到起点
    path = [goal(1), goal(2), goal(3)];
    cur_p = reshape(prev(goal(1), goal(2), goal(3), :),[1,3]);
    while any(cur_p ~= start)
        path = [cur_p;path];
        cur_p = reshape(prev(cur_p(1), cur_p(2), cur_p(3), :), [1,3]);
    end
    path = [cur_p;path];
end

% 将索引转换回实际坐标
path = idx_to_points(map, path);
if size(path, 1) > 0
    path = [start_xyz; path; goal_xyz];
else
    path = zeros(0, 3);
end
end