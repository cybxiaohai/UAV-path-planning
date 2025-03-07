function n_index = node_index(OPEN,xval,yval,zval)

    i=1;
    while(OPEN(i,2) ~= xval || OPEN(i,3) ~= yval || OPEN(i,4) ~= zval )%%%%%%%%%%%%当OPEN表中结点坐标不等于输入的坐标
        i=i+1;
    end;%统计路径结点到输入结点前经过的结点数
    n_index=i;%返回值为结点数
end