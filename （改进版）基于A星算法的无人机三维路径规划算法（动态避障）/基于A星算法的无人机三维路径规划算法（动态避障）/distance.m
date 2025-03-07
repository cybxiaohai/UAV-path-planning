function dist = distance(x1,y1,z1,x2,y2,z2)

dist=sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2); %距离等于两点间直线距离，改为三维时增加z轴坐标
%dist=abs(x1-x2)+abs(y1-y2)+abs(z1-z2);%曼哈顿算法
