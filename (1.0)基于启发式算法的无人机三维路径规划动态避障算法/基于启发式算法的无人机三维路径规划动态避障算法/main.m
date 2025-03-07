%% 名称：基于启发式算法的无人机三维路径规划动态避障算法
%  作者：于小航、郭镒闻、蒋文鹏、陈怡冰、尼玛白珍
%  日期：2025-03-02
%  版本：1.0
%  功能：实现无人机在三维空间中的路径规划和动态避障
%  输入：
%    - 地图信息：障碍物位置和大小
%    - 起始点：无人机初始位置
%    - 目标点：无人机目标位置
%  输出：
%    - 路径规划结果：包含路径点序列和可视化显示
%  说明：
%    - 使用启发式算法(A*)进行路径规划
%    - 支持动态避障功能
%    - 包含路径平滑处理

clc
clear
close all
warning off

%% 定义三维地图参数
MAX_X=10;
MAX_Y=10;
MAX_Z=10;
MAP=2*(ones(MAX_X,MAX_Y,MAX_Z));

%% 用户交互：选择地图输入方式
button=questdlg('是否需要手动输入地图信息？','输入地图','No');
if strcmp('No',button)==1
    % 读取预设地图
    map1;
else    
%% 获取信息，初始化
% 障碍点值为-1，目标点值为0，机器位置值为1，空间单元值为2（已赋）
j=0;
axis([1 MAX_X+1 1 MAX_Y+1])
grid on;
hold on;
n=0;                                        %表示障碍点的个数

    % 获取目标点
    pause(1);
    h=msgbox('请用鼠标左键选择一个目标点');
    uiwait(h,5);
    if ishandle(h) == 1
        delete(h);
    end
    xlabel('请用鼠标左键选择一个目标点');
    but=0;
    while (but ~= 1)
        [xval,yval,but]=ginput(1);
    end
    xval=floor(xval);
    yval=floor(yval);
    xTarget=xval;
    yTarget=yval;
    plot(xval+.5,yval+.5,'o','MarkerFaceColor','g','MarkerSize',7);

    % 获取目标点高度
    pause(0.5);
    prompt={'请用键盘输入目标点的高度（整数，1-10）'};
    title='输入高度';
    line=1;
    def={'5'};
    zval=inputdlg(prompt,title,line,def);
    zval=str2double(zval);
    zTarget=zval;
    MAP(xval,yval,zval)=0;

    % 获取障碍物信息
    pause(0.5);
    h=msgbox('请用鼠标左键选择障碍物，结束时用右键选择最后一个');
    xlabel('请用鼠标左键选择障碍物，结束时用右键选择最后一个','Color','b');
    uiwait(h,10);
    if ishandle(h) == 1
        delete(h);
    end

    while but == 1
        [xval,yval,but] = ginput(1);
        xval=floor(xval);
        yval=floor(yval);
        fill([xval,xval,xval+1,xval+1],[yval,yval+1,yval+1,yval],'y');
        
        pause(0.5);
        prompt={'请输入当前障碍物底部高度（整数，1-10）','请输入当前障碍物顶部高度（整数，1-10）'};
        title='请用键盘输入高度';
        line=[1 1]';
        def={'1','10'};
        zval=inputdlg(prompt,title,line,def);
        zval_1=str2double(zval(1));
        zval_2=str2double(zval(2));
        for i=zval_1:zval_2
            MAP(xval,yval,i)=-1;
        end
    end

    % 获取起始点
    pause(0.5);
    h=msgbox('请用鼠标左键选择一个起始点');
    uiwait(h,5);
    if ishandle(h) == 1
        delete(h);
    end
    xlabel('请用鼠标左键选择一个起始点 ','color','k');
    but=0;
    while (but ~= 1)
        [xval,yval,but]=ginput(1);
        xval=floor(xval);
        yval=floor(yval);
    end
    xStart=xval;
    yStart=yval;
    plot(xval+.5,yval+.5,'bo','MarkerFaceColor','b','MarkerSize',7);

    pause(0.5);
    prompt={'请用键盘输入起始点的高度（整数，1-10）'};
    title='输入高度';
    line=1;
    def={'5'};
    zval=inputdlg(prompt,title,line,def);
    zval=str2double(zval);
    zStart=zval;
    MAP(xval,yval,zval)=1;
end 

%% 显示三维环境
close all;
axis([1 MAX_X+1 1 MAX_Y+1 1 MAX_Z]);
grid on;
hold on;
xlabel('X轴');ylabel('Y轴');zlabel('Z轴');
fg=fill3([1,1,11,11],[1,11,11,1],[1,1,1,1],[.5,.5,.5]);
alpha(fg,.1);

%% 显示目标点
plot3(xTarget+.5,yTarget+.5,zTarget+.5,'o','MarkerFaceColor','g','MarkerSize',7);
text(xTarget+.5,yTarget+1,11,'目标点');
quiver3(xTarget+.5,yTarget+.5,10.5,0,0,-2,'Color','k','maxheadsize',1.5,'LineWidth',1.5);
axis square;
view(3);

%% 显示障碍物
% 显示地面障碍物
for x=1:MAX_X
    for y=1:MAX_Y
        for z1=1:MAX_Z
            if MAP(x,y,z1)==-1
                break
            end
        end
        for z=1:MAX_Z
            if MAP(x,y,z)==-1
                z2=z;
            end
        end
        if z1~=z
            f1=fill3([x,x,x,x+1,x+1;x,x,x,x+1,x;
                x+1,x,x+1,x+1,x;x+1,x,x+1,x+1,x+1
                ],[y,y,y+1,y+1,y;y+1,y+1,y+1,y+1,y;
                y+1,y+1,y+1,y,y;y,y,y+1,y,y
                ],[z2,z1,z1,z1,z1;z2,z1,z2,z2,z1;
                z2,z2,z2,z2,z2;z2,z2,z1,z1,z2],'y');
            alpha(f1,.5);
        end
    end
end

% 显示天花板障碍物
for x=1:MAX_X
    for y=1:MAX_Y
        for zt1=1:MAX_Z
            if MAP(x,y,zt1)==-1.5
                break
            end
        end
        for zt=1:MAX_Z
            if MAP(x,y,zt)==-1.5
                zt2=zt;
            end
        end
        if zt1~=zt
            f2=fill3([x,x,x,x+1,x+1;x,x,x,x+1,x;
                x+1,x,x+1,x+1,x;x+1,x,x+1,x+1,x+1
                ],[y,y,y+1,y+1,y;y+1,y+1,y+1,y+1,y;
                y+1,y+1,y+1,y,y;y,y,y+1,y,y
                ],[zt2,zt1,zt1,zt1,zt1;zt2,zt1,zt2,zt2,zt1;
                zt2,zt2,zt2,zt2,zt2;zt2,zt2,zt1,zt1,zt2],'y');
            alpha(f2,.5);
        end
    end
end

%% 显示起始点
[x,y,z]=sphere(50);                                                 %括号内数值是光滑度
r=1.45;
plot3(xStart+.5,yStart+.5,zStart+.5,'bo','MarkerFaceColor','b','MarkerSize',7);
X=x*r+xStart+.5;
Y=y*r+yStart+.5;
Z=z*r+zStart+.5;
s=surf(X,Y,Z,'FaceColor','k', 'EdgeColor','none', 'FaceLighting','phong');
text(xStart+.5,yStart+1,11,'起始点');
quiver3(xStart+.5,yStart+.5,10.5,0,0,-2,'Color','k','maxheadsize',1.5,'LineWidth',1.5);
axis square;
alpha(s,0.05);

%% 添加动态障碍物
kx=unidrnd(8);
ky=unidrnd(8);
kz1=unidrnd(3);
kz2=kz1+unidrnd(10);
for i=kz1:min(kz2,10)
    MAP(kx,ky,i)=-1;
end

% 显示动态障碍物
pause(1);
kz11=kz1;
kz22=min(kz2,10);
k=fill3([kx,kx,kx,kx+1,kx+1;kx,kx,kx,kx+1,kx;
       kx+1,kx,kx+1,kx+1,kx;kx+1,kx,kx+1,kx+1,kx+1
    ],[ky,ky,ky+1,ky+1,ky;ky+1,ky+1,ky+1,ky+1,ky;
       ky+1,ky+1,ky+1,ky,ky;ky,ky,ky+1,ky,ky
    ],[kz22,kz11,kz11,kz11,kz11;kz22,kz11,kz22,kz22,kz11;
       kz22,kz22,kz22,kz22,kz22;kz22,kz22,kz11,kz11,kz22],'r');
alpha(k,.5);
text(kx+.5,ky+1,10,'动态障碍物');
quiver3(kx+.5,ky+.5,10,0,0,-2,'Color','k','maxheadsize',1.5,'LineWidth',1.5);

%% 开始计时
tic;

%% 初始化路径规划参数
NoPath=1;
xNode=xStart;
yNode=yStart;
zNode=zStart;
path_cost=0;
Optiaml_path=[];
Optiaml_path(1,1)=xStart;
Optiaml_path(1,2)=yStart;
Optiaml_path(1,3)=zStart;
n=1;
NP=[0 0 0];
NP_COUNT=0;
encounter=0;

%% 主循环：路径规划
while xNode~=xTarget || yNode~=yTarget || zNode~=zTarget
    % 确定搜索范围
    xB1=max(xNode-1,1);
    xB2=min(xNode+1,10);
    yB1=max(yNode-1,1);
    yB2=min(yNode+1,10);
    zB1=max(zNode-1,1);
    zB2=min(zNode+1,10);
    n=n+1;

    % 执行A*算法
    if NoPath~=0
        A_Star;
        m=1;
        i=1;
        flag=0;
        
        % 防止航迹擦边
        red=0;
        if abs(xNode-Optiaml_path(n-1,1))==1 && abs(yNode-Optiaml_path(n-1,2))==1
            if MAP(Optiaml_path(n-1,1),yNode,zNode)<0 && MAP(xNode,Optiaml_path(n-1,2),zNode)>=0
                yNode=Optiaml_path(n-1,2);
            else
                if MAP(xNode,Optiaml_path(n-1,2),zNode)<0 && MAP(Optiaml_path(n-1,1),yNode,zNode)>=0
                    xNode=Optiaml_path(n-1,1);
                else
                    if MAP(xNode,Optiaml_path(n-1,2),zNode)<0 && MAP(Optiaml_path(n-1,1),yNode,zNode)<0
                        MAP(Optiaml_path(n-1,1),Optiaml_path(n-1,2),Optiaml_path(n-1,3))=-1;
                        clear Optiaml_path(n-1,1) Optiaml_path(n-1,2) Optiaml_path(n-1,3);
                        plot3(Optiaml_path(n-1,1)+.5,Optiaml_path(n-1,2)+.5,Optiaml_path(n-1,3)+.5,'ro','MarkerFaceColor','r','MarkerSize',7);
                        n=n-1;
                        xNode=Optiaml_path(n-1,1);
                        yNode=Optiaml_path(n-1,2);
                        zNode=Optiaml_path(n-1,3);
                    end
                end
            end
        end
        
        % 处理NP点
        while m<=n-1
            if (xNode~=xStart || yNode~=yStart || zNode~=zStart) && xNode==Optiaml_path(m,1) && yNode==Optiaml_path(m,2) && zNode==Optiaml_path(m,3)
                encounter=1;
                NP_COUNT=NP_COUNT+1;
                NP(NP_COUNT,1)=Optiaml_path(m,1);
                NP(NP_COUNT,2)=Optiaml_path(m,2);
                NP(NP_COUNT,3)=Optiaml_path(m,3);
                xNode=Optiaml_path(n-1,1);
                yNode=Optiaml_path(n-1,2);
                zNode=Optiaml_path(n-1,3);
                A_Star;
                m=1;
            else
                m=m+1;
            end
        end
    end
    
    % 更新路径点
    Optiaml_path(n,1)=xNode;
    Optiaml_path(n,2)=yNode;
    Optiaml_path(n,3)=zNode;
    
    % 显示路径点
    pause(.2);
    plot3(xNode+.5,yNode+.5,zNode+.5,'o','MarkerFaceColor','g','MarkerSize',7);
    
    % 显示当前位置
    [x,y,z]=sphere(50);
    r=1.45;
    plot3(xNode+.5,yNode+.5,zNode+.5,'bo','MarkerFaceColor','b','MarkerSize',7);
    X=x*r+xNode+.5;
    Y=y*r+yNode+.5;
    Z=z*r+zNode+.5;
    s2=surf(X,Y,Z,'FaceColor','b', 'EdgeColor','none', 'FaceLighting','phong');
    axis square;
    alpha(s2,0.05);
end

%% 完成路径规划
Optiaml_path(n,1)=xTarget;
Optiaml_path(n,2)=yTarget;
Optiaml_path(n,3)=zTarget;
plot3(xTarget+.5,yTarget+.5,zTarget+.5,'o','MarkerFaceColor','g','MarkerSize',7);

%% 显示平滑路径
values = spcrv([Optiaml_path(:,1)'+.5;Optiaml_path(:,2)'+.5;Optiaml_path(:,3)'+.5],3);
plot3(values(1,:),values(2,:),values(3,:),'k','LineWidth',2);

%% 结束计时
toc;

%% 询问是否需要与全局规划对比
button=questdlg('是否需要生成全局路径规划结果进行对比？');
if strcmp('Yes',button)==1
    global_path_planning;
end

