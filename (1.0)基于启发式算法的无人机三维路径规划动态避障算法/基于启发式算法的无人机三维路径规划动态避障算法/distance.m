function dist = distance(x1,y1,z1,x2,y2,z2)

%  功能：计算三维空间中两点之间的欧氏距离
%  输入：
%    - x1, y1, z1：第一个点的坐标
%    - x2, y2, z2：第二个点的坐标
%  输出：
%    - dist：两点之间的欧氏距离
%  说明：可选择使用欧氏距离或曼哈顿距离

dist=sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2);       % 欧氏距离
% dist=abs(x1-x2)+abs(y1-y2)+abs(z1-z2);            %曼哈顿距离
end
