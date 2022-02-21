clear;
close all;
clc;


%% Circuit Parameters


% State-space average model of a Boost Converter
% u=[delta]; x=[i_L; v_C]; y=[v_O]
% Component Parameters
L = 3.14e-3; % real values 
r_L = 3.29e-3; 
C = 1.21e-6; 
r_C = 0; 
R = 247;

% Circuit Conditions
V_I = 100; 
Delta = 0.75;

% Modeling Conditions
StepSize = 0.05;

% factor = 2.65;
% controllerZero = 8e3;
% controllerPole = -controllerZero*factor;
% gain = 0.00083;

% Same lead lag controller as Buck Example
% controllerPole =1/(2*pi*1e4)
% controllerZero =1/(2*pi*3e3)

% PI Controller
kP = 0.0001;
kI = 1;
T = 0.02;
gain = 1;

% I Controller
ictrl_kI = 0.02;
ictrl_gain = 1;

%% Model


% First form models of the two states
A_on = [-r_L/L, 0; 0, -1/C/(R+r_C)];
B_on = [1/L; 0];
C_on = [0, R/(R+r_C)];
A_off = [-r_L/L-r_C*R/L/(R+r_C), -R/L/(R+r_C); R/C/(R+r_C), -1/C/(R+r_C)];
B_off = [1/L; 0];
C_off = [r_C*R/(R+r_C), R/(R+r_C)];


% Average the two models
% Operating point model
A = Delta*A_on + (1-Delta)*A_off;
B = Delta*B_on + (1-Delta)*B_off;
C = Delta*C_on + (1-Delta)*C_off;
U = V_I;
X = -inv(A)*B*U;
Y = C*X;

%Small-signal model
E = (A_on-A_off)*X + (B_on-B_off)*U;
F = (C_on-C_off)*X;

boost_ss = ss(A, E, C, F);
% boost_ss = ss(A,B,C,0);

% Control System
% [cA, cB, cC, cD] = tf2ss([1 -controllerZero], [1 -controllerPole]);
% controller_ss = ss(cA, cB, cC, cD);
% controller_tf = pid(kP,kI,0);

%% Boost Transfer Function
[boost_tf_upper, boost_tf_lower] = ss2tf(A,E,C,F);
boost_tf = tf(boost_tf_upper, boost_tf_lower);

%% Lead lag controller
% LL_controller_tf = tf([1 -controllerZero], [1 -controllerPole]); % Lead lag controller
% LL_boost_tf_ol = series(boost_tf, LL_controller_tf);
% LL_boost_tf_cl = feedback(LL_boost_tf_ol*gain, 1);
% LL_boost_ss_ol = series(boost_ss, LL_controller_tf);
% LL_boost_ss_cl = feedback(LL_boost_ss_ol*gain, 1);

% PI Controller
% pi_controller = pid(kP, kI, 0);
% pi_controller = tf([(kI*T) kP], [T 0]);
% pi_boost = series(pi_controller, boost_ss);
% pi_boost_cl = feedback(gain*pi_boost, 1);

%% Integral Controller
i_controller = tf([ictrl_kI], [1 0]);
i_boost = series(i_controller, boost_ss);
i_boost_cl = feedback(ictrl_gain*i_boost, 1);

%% Unit Step Delta

% Find unit step-response
T = 0:0.001:StepSize;
[y,T,x] = step(boost_ss,T);

% Scale step-response and add to operating point
iL = 0.05*x(:,1)+X(1)*ones(length(T),1);
y = 0.05*y+Y*ones(length(T),1);

% Add time prior to step
T = [0; T+0.15];
iL = [X(1); iL];
y = [Y; y];


%% Results

% % Delta unit-step
% figure(1);
% subplot(3,1,1)
% plot([0, 0.15, 0.1501, 0.2], [Delta, Delta, Delta+StepSize, Delta+StepSize])
% ylim([Delta-0.05 Delta+0.05+StepSize]);
% xlabel("Time [s]")
% ylabel("Duty Cycle")
% title("Delta Input")
% grid on;
% 
% subplot(3,1,2)
% plot(T,iL)
% xlabel("Time [s]")
% ylabel("Current [A]")
% title("Current Output")
% grid on;
% 
% subplot(3,1,3)
% plot(T,y)
% xlabel("Time [s]")
% ylabel("Voltage [V]")
% title("Voltage Output")
% grid on;
% movegui('northwest');
% 
% % Pre-step Bode Plot
% figure(2);
% bode(boost_tf);
% title("Bode plot for Boost converter - Open loop, no controller");
% grid on;
% movegui('north');
% 
% figure(3);
% rlocus(boost_tf);
% title("Root Locus for Boost converter - Closed loop, no controller");
% grid on;
% movegui('northeast');
% 
% figure(4);
% step(boost_tf, 10e-3)
% title("Open loop step response - no controller")
% grid on;
% movegui('west');

%%%%%% Lead lag %%%%%%
% figure(5);
% rlocus(LL_boost_tf_ol);
% title("Pre-Step Root Locus - Closed loop, with lead lag controller")
% xlim([-1e5, 0.5e5]);
% grid on;
% 
% figure(6);
% bode(LL_boost_tf_cl);
% title("Pre-Step Bode Diagram - Closed loop, with lead lag controller")
% grid on;
% movegui('east');
% 
% figure(7);
% step(LL_boost_tf_cl, 10e-3)
% title("Closed loop (Lead Lag) step response - From TF")
% grid on;
% movegui('southwest');

% figure(8);
% rlocus(pi_boost);
% title("Pre-Step Root Locus - Closed loop, with PI controller")
% grid on;
% xlim([-2e4, 1e4]);
% movegui('south');
% 
% figure(9);
% bode(pi_boost_cl);
% title("Pre-Step Bode Diagram - Closed loop, with PI controller")
% grid on;
% movegui('southeast');

% figure(10);
% step(pi_boost_cl, 50e-3)
% title("Closed loop (PI) step response - From TF")
% grid on;

figure(11);
rlocus(i_boost);
title("Pre-Step Root Locus - Closed loop, with Integral controller")
grid on;
xlim([-2e4, 1e4]);
movegui('south');

figure(12);
bode(i_boost_cl);
title("Pre-Step Bode Diagram - Closed loop, with Integral controller")
grid on;
movegui('southeast');

figure(13);
step(i_boost_cl, 500e-3)
title("Closed loop (I controller) step response - From TF")
grid on;

%% 

% Finds values starting from 0
% 5% Settling Threshold
startUpInfo = stepinfo(pi_boost_cl, 'SettlingTimeThreshold', 0.05)


%% Manually find settling time, rise time (10-90%), settling time(5%)

% G(s) = a/  (bs^2 + c^s + d)
a = boost_tf_upper(3);
b = boost_tf_lower(1);
c = boost_tf_lower(2);
d = boost_tf_lower(3);

% Using the general form of a second order transfer function
w_n = sqrt(d); % natural frequency
zeta = c/2/w_n; % damping ratio
varrho = a;
mu = varrho/w_n^2;

t_settle = 3/(w_n*zeta); % by approx from Parisini's Y2 Control Course
pc_overshoot = 100*exp(-zeta*pi/sqrt(1-zeta^2));
t_delay = (1+0.7*zeta)/w_n; % reach half its final value
t_rise = pi/t_delay;
oscillation_f = w_n * sqrt(1-zeta^2)/2/pi;
