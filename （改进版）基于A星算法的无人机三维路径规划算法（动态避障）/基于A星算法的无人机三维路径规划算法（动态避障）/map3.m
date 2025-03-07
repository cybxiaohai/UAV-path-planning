%  �ļ����ƣ�map3.m
%  ���ܣ�Ԥ��ĵ�ͼ������������ʼ�㡢Ŀ�����ϰ����λ��

%% ������ά��ͼ����
clc;
clear;
close all;
warning off;

MAX_X = 10;
MAX_Y = 10;
MAX_Z = 10;
MAP = 2 * ones(MAX_X, MAX_Y, MAX_Z); % ��ʼ����ͼ���飬Ĭ��ֵΪ2

%% ���������յ�
xStart = 1;
yStart = 1;
zStart = 1;
xTarget = 8;
yTarget = 8;
zTarget = 5;

%% ���ɸ����ӵĳ��нṹ��ȷ��·�����ᱻ�赲
max_building_height = 8; % ������߽�����߶�

% ���ɽ������Ԥ���㹻�Ŀ�ͨ�пռ�
for x = 2:9
    for y = 2:9
        if mod(x, 3) == 0 && mod(y, 3) == 0  % ����ֲ����������Ӹ��Ӷ�
            if ~(x == xStart && y == yStart) && ~(x == xTarget && y == yTarget)
                height = randi([3, max_building_height]);
                MAP(x, y, 1:height) = -1; % ���ý����߶�
            end
        end
    end
end

%% ��ӵر��Խ������������
landmark_height = min(9, max_building_height);
if ~(5 == xStart && 5 == yStart) && ~(5 == xTarget && 5 == yTarget)
    MAP(5, 5, 1:landmark_height) = -1;
end

%% ȷ����ͼ���㹻�Ŀ�ͨ������
for y = 1:MAX_Y
    if mod(y, 2) == 0  % ż���п���ͨ��
        MAP(:, y, 1) = 0;
    end
end

for x = 1:MAX_X
    if mod(x, 2) == 0  % ż���п���ͨ��
        MAP(x, :, 1) = 0;
    end
end

%% ���������ȷ��·�����ӵ���ͨ��
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

%% �������֧�Žṹ����Ӱ��·����
MAP(3, 5, 1:3) = -1;
MAP(6, 5, 1:3) = -1;
MAP(5, 3, 1:5) = -1;
MAP(5, 6, 1:5) = -1;

%% ȷ�������յ��ǿ�ͨ�е�
MAP(xStart, yStart, zStart) = 1;
MAP(xTarget, yTarget, zTarget) = 0;

%% ���ӻ���ͼ
figure;
hold on;

% ��ȡ�ϰ�������
[ox, oy, oz] = ind2sub(size(MAP), find(MAP == -1));
scatter3(ox, oy, oz, 50, 'k', 'filled');

% ��ȡ��·����������
[rx, ry, rz] = ind2sub(size(MAP), find(MAP == 0));
scatter3(rx, ry, rz, 30, 'g', 'filled');

% ��������յ�
scatter3(xStart, yStart, zStart, 100, 'b', 'filled');
scatter3(xTarget, yTarget, zTarget, 100, 'r', 'filled');

xlabel('X'); ylabel('Y'); zlabel('Z');
title('Complex Urban Map with Safe Pathways');
grid on;
hold off;
