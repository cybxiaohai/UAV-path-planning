%  文件名称：map3.m
%  功能：预设的地图场景，包含起始点、目标点和障碍物的位置

%% 定义三维地图数组
clc;
clear;
close all;
warning off;

MAX_X = 10;
MAX_Y = 10;
MAX_Z = 10;
MAP = 2 * ones(MAX_X, MAX_Y, MAX_Z); % 初始化地图数组，默认值为2

%% 定义起点和终点
xStart = 1;
yStart = 1;
zStart = 1;
xTarget = 8;
yTarget = 8;
zTarget = 5;

%% 生成更复杂的城市结构，确保路径不会被阻挡
max_building_height = 8; % 限制最高建筑物高度

% 生成建筑物，但预留足够的可通行空间
for x = 2:9
    for y = 2:9
        if mod(x, 3) == 0 && mod(y, 3) == 0  % 交错分布建筑，增加复杂度
            if ~(x == xStart && y == yStart) && ~(x == xTarget && y == yTarget)
                height = randi([3, max_building_height]);
                MAP(x, y, 1:height) = -1; % 设置建筑高度
            end
        end
    end
end

%% 添加地标性建筑（如高塔）
landmark_height = min(9, max_building_height);
if ~(5 == xStart && 5 == yStart) && ~(5 == xTarget && 5 == yTarget)
    MAP(5, 5, 1:landmark_height) = -1;
end

%% 确保地图有足够的可通行区域
for y = 1:MAX_Y
    if mod(y, 2) == 0  % 偶数列开放通行
        MAP(:, y, 1) = 0;
    end
end

for x = 1:MAX_X
    if mod(x, 2) == 0  % 偶数行开放通行
        MAP(x, :, 1) = 0;
    end
end

%% 添加桥梁，确保路径复杂但可通行
bridge_height = 4;
for x = 2:8
    if mod(x, 2) == 0 && all(MAP(x, 5, 1:bridge_height) ~= -1)
        MAP(x, 5, bridge_height) = 0;
    end
end
for y = 2:8
    if mod(y, 2) == 0 && all(MAP(5, y, 1:bridge_height) ~= -1)
        MAP(5, y, bridge_height) = 0;
    end
end

%% 添加桥梁支撑结构（不影响路径）
MAP(3, 5, 1:3) = -1;
MAP(6, 5, 1:3) = -1;
MAP(5, 3, 1:5) = -1;
MAP(5, 6, 1:5) = -1;

%% 确保起点和终点是可通行的
MAP(xStart, yStart, zStart) = 1;
MAP(xTarget, yTarget, zTarget) = 0;

%% 可视化地图
figure;
hold on;

% 获取障碍物坐标
[ox, oy, oz] = ind2sub(size(MAP), find(MAP == -1));
scatter3(ox, oy, oz, 50, 'k', 'filled');

% 获取道路和桥梁坐标
[rx, ry, rz] = ind2sub(size(MAP), find(MAP == 0));
scatter3(rx, ry, rz, 30, 'g', 'filled');

% 标记起点和终点
scatter3(xStart, yStart, zStart, 100, 'b', 'filled');
scatter3(xTarget, yTarget, zTarget, 100, 'r', 'filled');

xlabel('X'); ylabel('Y'); zlabel('Z');
title('Complex Urban Map with Safe Pathways');
grid on;
hold off;
