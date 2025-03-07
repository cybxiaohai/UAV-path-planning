%  文件名称：map2.m
%  功能：预设的地图场景，包含起始点、目标点和障碍物的位置

% 定义三维地图数组
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

%% 添加高楼（模拟复杂城市结构，但确保不阻挡起点和终点）
max_building_height = 8; % 限制最高建筑物高度，避免路径穿越
for x = 2:2:8
    for y = 2:2:8
        if ~(x == xStart && y == yStart) && ~(x == xTarget && y == yTarget)
            height = randi([3, max_building_height]);
            MAP(x, y, 1:height) = -1; % 确保不会生成过高的建筑
        end
    end
end

%% 添加地标性建筑（如高塔）
landmark_height = min(9, max_building_height); % 避免路径规划穿越最高建筑
if ~(5 == xStart && 5 == yStart) && ~(5 == xTarget && 5 == yTarget)
    MAP(5, 5, 1:landmark_height) = -1;
end

%% 添加主要道路（x 方向）
for y = 1:10
    MAP(:, y, 1) = 0;
end

%% 添加主要道路（y 方向）
for x = 1:10
    MAP(x, :, 1) = 0;
end

%% 添加桥梁（确保不会穿越最高建筑）
bridge_height = 4; % 限制桥梁高度，避免与最高建筑冲突
for x = 3:6
    if ~(x == xStart && 5 == yStart) && ~(x == xTarget && 5 == yTarget) && all(MAP(x, 5, 1:bridge_height) ~= -1)
        MAP(x, 5, bridge_height) = 0;
    end
end
for y = 3:6
    if ~(5 == xStart && y == yStart) && ~(5 == xTarget && y == yTarget) && all(MAP(5, y, 1:bridge_height) ~= -1)
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
title('Urban Map with Roads and Bridges (No Path Over Tallest Buildings)');
grid on;
hold off;
