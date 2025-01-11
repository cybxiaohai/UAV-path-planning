function [F, M, trpy, drpy] = controller(qd, t, qn, params)
% CONTROLLER 四旋翼控制器
% 输入参数:
% qd{qn}.pos - 当前位置
% qd{qn}.vel - 当前速度
% qd{qn}.euler - 当前欧拉角[roll;pitch;yaw]
% qd{qn}.omega - 当前角速度
% qd{qn}.pos_des - 期望位置
% qd{qn}.vel_des - 期望速度
% qd{qn}.acc_des - 期望加速度
% qd{qn}.yaw_des - 期望偏航角
% qd{qn}.yawdot_des - 期望偏航角速度
% 输出参数:
% F - 总推力
% M - 力矩
% trpy - [总推力,期望roll,期望pitch,期望yaw]
% drpy - [0,0,0,0] 备用参数

% 位置控制器参数
Kp = [15;15;30];    % 位置比例增益
Kd = [12;12;10];    % 速度比例增益

% 姿态控制器参数
KpM = ones(3,1)*3000;   % 姿态角比例增益
KdM = ones(3,1)*300;    % 角速度比例增益

% 计算期望加速度(PD控制器)
acc_des = qd{qn}.acc_des + Kd.*(qd{qn}.vel_des - qd{qn}.vel) + Kp.*(qd{qn}.pos_des - qd{qn}.pos);

% 计算期望姿态角
% 根据期望加速度和偏航角,计算期望的roll和pitch角
phi_des = 1/params.grav * (acc_des(1)*sin(qd{qn}.yaw_des) - acc_des(2)*cos(qd{qn}.yaw_des));    % 期望roll角
theta_des = 1/params.grav * (acc_des(1)*cos(qd{qn}.yaw_des) + acc_des(2)*sin(qd{qn}.yaw_des));  % 期望pitch角
psi_des = qd{qn}.yaw_des;  % 期望yaw角

% 组合期望姿态角和角速度
euler_des = [phi_des;theta_des;psi_des];  % 期望欧拉角
pqr_des = [0;0; qd{qn}.yawdot_des];      % 期望角速度

% 计算控制输出
F  = params.mass*(params.grav + acc_des(3));  % 总推力 = 质量*(重力 + 期望垂直加速度)
% 计算力矩(PD控制器)
M =  params.I*(KdM.*(pqr_des - qd{qn}.omega) + KpM.*(euler_des - qd{qn}.euler));

% 输出控制量
trpy = [F, phi_des, theta_des, psi_des];
drpy = [0, 0,       0,         0];

end
