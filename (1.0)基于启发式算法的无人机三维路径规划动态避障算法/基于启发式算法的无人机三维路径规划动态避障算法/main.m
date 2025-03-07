%% ���ƣ���������ʽ�㷨�����˻���ά·���滮��̬�����㷨
%  ���ߣ���С���������š������������������������
%  ���ڣ�2025-03-02
%  �汾��1.0
%  ���ܣ�ʵ�����˻�����ά�ռ��е�·���滮�Ͷ�̬����
%  ���룺
%    - ��ͼ��Ϣ���ϰ���λ�úʹ�С
%    - ��ʼ�㣺���˻���ʼλ��
%    - Ŀ��㣺���˻�Ŀ��λ��
%  �����
%    - ·���滮���������·�������кͿ��ӻ���ʾ
%  ˵����
%    - ʹ������ʽ�㷨(A*)����·���滮
%    - ֧�ֶ�̬���Ϲ���
%    - ����·��ƽ������

clc
clear
close all
warning off

%% ������ά��ͼ����
MAX_X=10;
MAX_Y=10;
MAX_Z=10;
MAP=2*(ones(MAX_X,MAX_Y,MAX_Z));

%% �û�������ѡ���ͼ���뷽ʽ
button=questdlg('�Ƿ���Ҫ�ֶ������ͼ��Ϣ��','�����ͼ','No');
if strcmp('No',button)==1
    % ��ȡԤ���ͼ
    map1;
else    
%% ��ȡ��Ϣ����ʼ��
% �ϰ���ֵΪ-1��Ŀ���ֵΪ0������λ��ֵΪ1���ռ䵥ԪֵΪ2���Ѹ���
j=0;
axis([1 MAX_X+1 1 MAX_Y+1])
grid on;
hold on;
n=0;                                        %��ʾ�ϰ���ĸ���

    % ��ȡĿ���
    pause(1);
    h=msgbox('����������ѡ��һ��Ŀ���');
    uiwait(h,5);
    if ishandle(h) == 1
        delete(h);
    end
    xlabel('����������ѡ��һ��Ŀ���');
    but=0;
    while (but ~= 1)
        [xval,yval,but]=ginput(1);
    end
    xval=floor(xval);
    yval=floor(yval);
    xTarget=xval;
    yTarget=yval;
    plot(xval+.5,yval+.5,'o','MarkerFaceColor','g','MarkerSize',7);

    % ��ȡĿ���߶�
    pause(0.5);
    prompt={'���ü�������Ŀ���ĸ߶ȣ�������1-10��'};
    title='����߶�';
    line=1;
    def={'5'};
    zval=inputdlg(prompt,title,line,def);
    zval=str2double(zval);
    zTarget=zval;
    MAP(xval,yval,zval)=0;

    % ��ȡ�ϰ�����Ϣ
    pause(0.5);
    h=msgbox('����������ѡ���ϰ������ʱ���Ҽ�ѡ�����һ��');
    xlabel('����������ѡ���ϰ������ʱ���Ҽ�ѡ�����һ��','Color','b');
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
        prompt={'�����뵱ǰ�ϰ���ײ��߶ȣ�������1-10��','�����뵱ǰ�ϰ��ﶥ���߶ȣ�������1-10��'};
        title='���ü�������߶�';
        line=[1 1]';
        def={'1','10'};
        zval=inputdlg(prompt,title,line,def);
        zval_1=str2double(zval(1));
        zval_2=str2double(zval(2));
        for i=zval_1:zval_2
            MAP(xval,yval,i)=-1;
        end
    end

    % ��ȡ��ʼ��
    pause(0.5);
    h=msgbox('����������ѡ��һ����ʼ��');
    uiwait(h,5);
    if ishandle(h) == 1
        delete(h);
    end
    xlabel('����������ѡ��һ����ʼ�� ','color','k');
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
    prompt={'���ü���������ʼ��ĸ߶ȣ�������1-10��'};
    title='����߶�';
    line=1;
    def={'5'};
    zval=inputdlg(prompt,title,line,def);
    zval=str2double(zval);
    zStart=zval;
    MAP(xval,yval,zval)=1;
end 

%% ��ʾ��ά����
close all;
axis([1 MAX_X+1 1 MAX_Y+1 1 MAX_Z]);
grid on;
hold on;
xlabel('X��');ylabel('Y��');zlabel('Z��');
fg=fill3([1,1,11,11],[1,11,11,1],[1,1,1,1],[.5,.5,.5]);
alpha(fg,.1);

%% ��ʾĿ���
plot3(xTarget+.5,yTarget+.5,zTarget+.5,'o','MarkerFaceColor','g','MarkerSize',7);
text(xTarget+.5,yTarget+1,11,'Ŀ���');
quiver3(xTarget+.5,yTarget+.5,10.5,0,0,-2,'Color','k','maxheadsize',1.5,'LineWidth',1.5);
axis square;
view(3);

%% ��ʾ�ϰ���
% ��ʾ�����ϰ���
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

% ��ʾ�컨���ϰ���
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

%% ��ʾ��ʼ��
[x,y,z]=sphere(50);                                                 %��������ֵ�ǹ⻬��
r=1.45;
plot3(xStart+.5,yStart+.5,zStart+.5,'bo','MarkerFaceColor','b','MarkerSize',7);
X=x*r+xStart+.5;
Y=y*r+yStart+.5;
Z=z*r+zStart+.5;
s=surf(X,Y,Z,'FaceColor','k', 'EdgeColor','none', 'FaceLighting','phong');
text(xStart+.5,yStart+1,11,'��ʼ��');
quiver3(xStart+.5,yStart+.5,10.5,0,0,-2,'Color','k','maxheadsize',1.5,'LineWidth',1.5);
axis square;
alpha(s,0.05);

%% ��Ӷ�̬�ϰ���
kx=unidrnd(8);
ky=unidrnd(8);
kz1=unidrnd(3);
kz2=kz1+unidrnd(10);
for i=kz1:min(kz2,10)
    MAP(kx,ky,i)=-1;
end

% ��ʾ��̬�ϰ���
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
text(kx+.5,ky+1,10,'��̬�ϰ���');
quiver3(kx+.5,ky+.5,10,0,0,-2,'Color','k','maxheadsize',1.5,'LineWidth',1.5);

%% ��ʼ��ʱ
tic;

%% ��ʼ��·���滮����
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

%% ��ѭ����·���滮
while xNode~=xTarget || yNode~=yTarget || zNode~=zTarget
    % ȷ��������Χ
    xB1=max(xNode-1,1);
    xB2=min(xNode+1,10);
    yB1=max(yNode-1,1);
    yB2=min(yNode+1,10);
    zB1=max(zNode-1,1);
    zB2=min(zNode+1,10);
    n=n+1;

    % ִ��A*�㷨
    if NoPath~=0
        A_Star;
        m=1;
        i=1;
        flag=0;
        
        % ��ֹ��������
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
        
        % ����NP��
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
    
    % ����·����
    Optiaml_path(n,1)=xNode;
    Optiaml_path(n,2)=yNode;
    Optiaml_path(n,3)=zNode;
    
    % ��ʾ·����
    pause(.2);
    plot3(xNode+.5,yNode+.5,zNode+.5,'o','MarkerFaceColor','g','MarkerSize',7);
    
    % ��ʾ��ǰλ��
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

%% ���·���滮
Optiaml_path(n,1)=xTarget;
Optiaml_path(n,2)=yTarget;
Optiaml_path(n,3)=zTarget;
plot3(xTarget+.5,yTarget+.5,zTarget+.5,'o','MarkerFaceColor','g','MarkerSize',7);

%% ��ʾƽ��·��
values = spcrv([Optiaml_path(:,1)'+.5;Optiaml_path(:,2)'+.5;Optiaml_path(:,3)'+.5],3);
plot3(values(1,:),values(2,:),values(3,:),'k','LineWidth',2);

%% ������ʱ
toc;

%% ѯ���Ƿ���Ҫ��ȫ�ֹ滮�Ա�
button=questdlg('�Ƿ���Ҫ����ȫ��·���滮������жԱȣ�');
if strcmp('Yes',button)==1
    global_path_planning;
end

