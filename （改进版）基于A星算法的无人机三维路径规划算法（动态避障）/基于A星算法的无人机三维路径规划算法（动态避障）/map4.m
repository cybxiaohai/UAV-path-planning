%  文件名称：map1.m
%  功能：预设的地图场景，包含起始点、目标点和障碍物的位置

%% 定义三维地图数组
clc;
clear;
close all;
warning off;

MAX_X = 20;
MAX_Y = 20;
MAX_Z = 15;
MAP = 2 * ones(MAX_X, MAX_Y, MAX_Z); % 初始化地图数组，默认值为2

%% 定义起点和终点
xStart = 2;
yStart = 2;
zStart = 1;
xTarget = 18;
yTarget = 18;
zTarget = 5;

%% 生成更复杂的城市结构，确保路径不会被阻挡
max_building_height = 12; % 限制最高建筑物高度

% 生成建筑物，但预留足够的可通行空间
for x = 3:3:MAX_X-2
    for y = 3:3:MAX_Y-2
        if ~(x == xStart && y == yStart) && ~(x == xTarget && y == yTarget)
            height = randi([5, max_building_height]);
            MAP(x, y, 1:height) = -1; % 设置建筑高度
        end
    end
end

%% 添加地标性建筑（如高塔）
landmark_height = min(14, max_building_height);
if ~(10 == xStart && 10 == yStart) && ~(10 == xTarget && 10 == yTarget)
    MAP(10, 10, 1:landmark_height) = -1;
end

%% 确保地图有足够的可通行区域
for y = 1:MAX_Y
    if mod(y, 4) == 0  % 间隔分布开放通行通道
        MAP(:, y, 1:3) = 0;
    end
end

for x = 1:MAX_X
    if mod(x, 4) == 0  % 间隔分布开放通行通道
        MAP(x, :, 1:3) = 0;
    end
end

%% 添加额外的路径通道，防止死路
for x = 5:5:MAX_X-3
    for y = 5:5:MAX_Y-3
        MAP(x, y, 1:3) = 0;
    end
end

%% 添加桥梁，确保路径复杂但可通行
bridge_height = 6;
for x = 4:4:MAX_X-2
    if all(MAP(x, 10, 1:bridge_height) ~= -1)
        MAP(x, 10, bridge_height) = 0;
    end
end
for y = 4:4:MAX_Y-2
    if all(MAP(10, y, 1:bridge_height) ~= -1)
        MAP(10, y, bridge_height) = 0;
    end
end

%% 添加桥梁支撑结构（不影响路径）
MAP(4, 10, 1:4) = -1;
MAP(16, 10, 1:4) = -1;
MAP(10, 4, 1:5) = -1;
MAP(10, 16, 1:5) = -1;

%% 确保起点和终点是可通行的
MAP(xStart, yStart, zStart) = 1;
MAP(xTarget, yTarget, zTarget) = 0;

%% 可视化地图
figure;
hold on;

% 获取障碍物坐标
[ox, oy, oz] = ind2sub(size(MAP), find(MAP == -1));
scatter3(ox, oy, oz, 30, 'k', 'filled');

% 获取道路和桥梁坐标
[rx, ry, rz] = ind2sub(size(MAP), find(MAP == 0));
scatter3(rx, ry, rz, 20, 'g', 'filled');

% 标记起点和终点
scatter3(xStart, yStart, zStart, 100, 'b', 'filled');
scatter3(xTarget, yTarget, zTarget, 100, 'r', 'filled');

xlabel('X'); ylabel('Y'); zlabel('Z');
title('Expanded Complex Urban Map with Guaranteed Pathways');
grid on;
hold off;
