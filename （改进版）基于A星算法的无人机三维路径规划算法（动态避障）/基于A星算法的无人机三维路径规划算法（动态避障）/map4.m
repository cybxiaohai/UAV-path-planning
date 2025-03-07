%  �ļ����ƣ�map1.m
%  ���ܣ�Ԥ��ĵ�ͼ������������ʼ�㡢Ŀ�����ϰ����λ��

%% ������ά��ͼ����
clc;
clear;
close all;
warning off;

MAX_X = 20;
MAX_Y = 20;
MAX_Z = 15;
MAP = 2 * ones(MAX_X, MAX_Y, MAX_Z); % ��ʼ����ͼ���飬Ĭ��ֵΪ2

%% ���������յ�
xStart = 2;
yStart = 2;
zStart = 1;
xTarget = 18;
yTarget = 18;
zTarget = 5;

%% ���ɸ����ӵĳ��нṹ��ȷ��·�����ᱻ�赲
max_building_height = 12; % ������߽�����߶�

% ���ɽ������Ԥ���㹻�Ŀ�ͨ�пռ�
for x = 3:3:MAX_X-2
    for y = 3:3:MAX_Y-2
        if ~(x == xStart && y == yStart) && ~(x == xTarget && y == yTarget)
            height = randi([5, max_building_height]);
            MAP(x, y, 1:height) = -1; % ���ý����߶�
        end
    end
end

%% ��ӵر��Խ������������
landmark_height = min(14, max_building_height);
if ~(10 == xStart && 10 == yStart) && ~(10 == xTarget && 10 == yTarget)
    MAP(10, 10, 1:landmark_height) = -1;
end

%% ȷ����ͼ���㹻�Ŀ�ͨ������
for y = 1:MAX_Y
    if mod(y, 4) == 0  % ����ֲ�����ͨ��ͨ��
        MAP(:, y, 1:3) = 0;
    end
end

for x = 1:MAX_X
    if mod(x, 4) == 0  % ����ֲ�����ͨ��ͨ��
        MAP(x, :, 1:3) = 0;
    end
end

%% ��Ӷ����·��ͨ������ֹ��·
for x = 5:5:MAX_X-3
    for y = 5:5:MAX_Y-3
        MAP(x, y, 1:3) = 0;
    end
end

%% ���������ȷ��·�����ӵ���ͨ��
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

%% �������֧�Žṹ����Ӱ��·����
MAP(4, 10, 1:4) = -1;
MAP(16, 10, 1:4) = -1;
MAP(10, 4, 1:5) = -1;
MAP(10, 16, 1:5) = -1;

%% ȷ�������յ��ǿ�ͨ�е�
MAP(xStart, yStart, zStart) = 1;
MAP(xTarget, yTarget, zTarget) = 0;

%% ���ӻ���ͼ
figure;
hold on;

% ��ȡ�ϰ�������
[ox, oy, oz] = ind2sub(size(MAP), find(MAP == -1));
scatter3(ox, oy, oz, 30, 'k', 'filled');

% ��ȡ��·����������
[rx, ry, rz] = ind2sub(size(MAP), find(MAP == 0));
scatter3(rx, ry, rz, 20, 'g', 'filled');

% ��������յ�
scatter3(xStart, yStart, zStart, 100, 'b', 'filled');
scatter3(xTarget, yTarget, zTarget, 100, 'r', 'filled');

xlabel('X'); ylabel('Y'); zlabel('Z');
title('Expanded Complex Urban Map with Guaranteed Pathways');
grid on;
hold off;
