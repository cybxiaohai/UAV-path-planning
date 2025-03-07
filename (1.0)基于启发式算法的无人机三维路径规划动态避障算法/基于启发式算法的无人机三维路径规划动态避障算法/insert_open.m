function new_row = insert_open(xval,yval,zval,parent_xval,parent_yval,parent_zval,gn,hn,fn)

%  功能：创建新的OPEN列表节点
%  输入：
%    - xval：节点x坐标
%    - yval：节点y坐标
%    - zval：节点z坐标
%    - parent_xval：父节点x坐标
%    - parent_yval：父节点y坐标
%    - parent_zval：父节点z坐标
%    - gn：从起始点到当前节点的实际代价
%    - hn：从当前节点到目标点的估计代价
%    - fn：总代价（gn + hn）
%  输出：
%    - new_row：包含节点信息的新行，格式为：
%      [is_on_list, x, y, z, parent_x, parent_y, parent_z, gn, hn, fn]

new_row=[1,10];
new_row(1,1)=1;             % 设置节点状态为在列表中
new_row(1,2)=xval;          % 设置节点坐标
new_row(1,3)=yval;
new_row(1,4)=zval;
new_row(1,5)=parent_xval;   % 设置父节点坐标
new_row(1,6)=parent_yval;
new_row(1,7)=parent_zval;
new_row(1,8)=gn;            % 设置代价值
new_row(1,9)=hn;
new_row(1,10)=fn;
end