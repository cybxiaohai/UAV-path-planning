%%%%%%%%%%%%%%%%%
%脚本文件%
%  文件名称：map1.m
%  功能：预设的地图场景，包含起始点、目标点和障碍物的位置
%  说明：
%    - 障碍点值为-1
%    - 目标点值为0
%    - 机器位置值为1
%    - 空间单元值为2
%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%起始点位置%%%%%%%%%%%%%
xStart=4;
yStart=1;
zStart=1;
%%%%%%%%%%%%目标点位置%%%%%%%%%%%%%%
xTarget=7;
yTarget=9;
zTarget=5;
%%%%%%%%%%%%%承重柱障碍物%%%%%%%%%%%%
for i=1:10
    MAP(2,2,i)=-1;
    MAP(2,9,i)=-1;
    MAP(9,2,i)=-1;
    MAP(9,9,i)=-1;
end
%%%%%%%%%%%%%桌子障碍物%%%%%%%%%%%%
for i=1:4
    MAP(5,5,i)=-1;
    MAP(5,6,i)=-1;
    MAP(6,5,i)=-1;
    MAP(6,6,i)=-1;
end
%%%%%%%%%%%%%柜子障碍物%%%%%%%%%%%%
for i=1:7
    MAP(4,8,i)=-1;
    MAP(5,8,i)=-1;
    MAP(6,8,i)=-1;
    MAP(7,8,i)=-1;
end
%%%%%%%%%%%%%吊灯障碍物%%%%%%%%%%%%
for i=9:10
%    MAP(3,4,i)=-1.5;
    MAP(3,5,i)=-1.5;
    MAP(3,6,i)=-1.5;
    MAP(3,7,i)=-1.5;
end
%%%%%%%%%%%%%其他障碍物%%%%%%%%%%%%



