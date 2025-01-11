% 清除工作区变量和命令行窗口
close all;  % 关闭所有图形窗口
clear all;  % 清除工作区所有变量
clc;        % 清空命令行窗口
addpath(genpath('./')); % 添加当前目录及其子目录到搜索路径

%% 第一条路径规划 - 在map1地图中规划从起点到终点的路径
disp('Planning ...');  % 显示规划开始提示
% 加载地图1,参数分别为:地图文件、分辨率0.1、膨胀系数2、高度0.25
map = load_map('maps/map1.txt', 0.1, 2, 0.25);
% 设置起点坐标[x,y,z]
start = {[0.0  -4.9 0.2]};
% 设置终点坐标[x,y,z]
stop  = {[6.0  18.0-1 5.0]};
% 备选终点坐标(已注释)
% stop  = {[6.0  18.0-6 3.0]};

% 获取四旋翼数量
nquad = length(start);
% 为每个四旋翼规划路径
for qn = 1:nquad
    tic  % 开始计时
    % 使用Dijkstra算法计算路径,最后一个参数true表示显示搜索过程
    path{qn} = dijkstra(map, start{qn}, stop{qn}, true);
    toc  % 结束计时并显示耗时
end

% 路径可视化
if nquad == 1
    plot_path(map, path{1});  % 单个四旋翼路径绘制
else
    % 多个四旋翼的情况需要修改plot_path函数以支持多机器人
end


% %% 第三条路径规划 - 在map3地图中规划路径
% disp('Planning ...');  % 显示规划开始提示
% % 加载地图3,参数分别为:地图文件、分辨率0.2、膨胀系数0.5、高度0.25
% map = load_map('maps/map3.txt', 0.2, 0.5, 0.25);
% % 设置起点坐标[x,y,z]
% start = {[0.0, 5, 5.0]};
% % 设置终点坐标[x,y,z]
% stop  = {[20, 5, 5]};
% % 获取四旋翼数量
% nquad = length(start);
% % 为每个四旋翼规划路径
% for qn = 1:nquad
%     tic  % 开始计时
%     % 使用Dijkstra算法计算路径,最后一个参数true表示显示搜索过程
%     path{qn} = dijkstra(map, start{qn}, stop{qn}, true);
%     toc  % 结束计时并显示耗时
% end
% 
% % 路径可视化
% if nquad == 1
%     plot_path(map, path{1});  % 单个四旋翼路径绘制
% else
%     % 多个四旋翼的情况需要修改plot_path函数以支持多机器人
% end
% 

%% 初始化脚本
init_script;  % 运行初始化脚本,设置仿真所需的参数

%% 执行轨迹
% 生成并测试轨迹,最后一个参数true表示需要可视化显示
trajectory = test_trajectory(start, stop, map, path, true);
