function n_index = node_index(OPEN,xval,yval,zval)

%  功能：在OPEN列表中查找指定节点的索引
%  输入：
%    - OPEN：OPEN列表，包含待扩展的节点
%    - xval：要查找的节点的x坐标
%    - yval：要查找的节点的y坐标
%    - zval：要查找的节点的z坐标
%  输出：
%    - n_index：节点在OPEN列表中的索引位

i=1;
while(OPEN(i,2) ~= xval || OPEN(i,3) ~= yval || OPEN(i,4) ~= zval )
    i=i+1;
end;
n_index=i;
end