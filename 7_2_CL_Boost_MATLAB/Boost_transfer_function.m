clear;
close all;
clc;

%% Instructions

% 1. Define controller parameters in Lead lag controller, PI Controller, Integral Controller sections
% 2. Choose controller type in CHOOSE CONTROLLER TYPE HERE


%% Circuit Parameters

% State-space average model of a Boost Converter
% u=[delta]; x=[i_L; v_C]; y=[v_O]
% Component Parameters
L = 3.14e-3; % real values 
r_L = 3.29e-3; 
C = 1.21e-6; 
r_C = 0.528; 
R = 500;

% Circuit Conditions
V_I = 100; 
Delta = 0.75;

% Modeling Conditions
StepSize = 0.05;


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


%% Boost Transfer Function
[boost_tf_upper, boost_tf_lower] = ss2tf(A,E,C,F);
boost_tf = tf(boost_tf_upper, boost_tf_lower);

%% Lead lag controller

factor = 2.65;
controllerZero = 8e6;
controllerPole = -controllerZero*factor;
ll_gain = 0.00101;

% If you take gain crossover frequency as one tenth of the right half plane zero frequency, your system will be stable. 
LL_controller = tf([1 -controllerZero], [1 -controllerPole]); % Lead lag controller

%% PI Controller

kP = 300e-6; % Should be in the milli to 10k range?
kI = 0.6; % Should be in the 10's micro range?
pi_gain = 1;

pi_controller = pid(kP, kI, 0);

%% Integral Controller
% Why is it damping so much despite the fact that

kI = 0.02;
i_gain = 1.61;

% Integral Controller
i_controller = tf([kI], [1 0]);

%% CHOOSE CONTROLLER TYPE HERE

type = 'PI'; % Available options: LL, PI, Int

gain = ll_gain;
controller = tf([1 -controllerZero], [1 -controllerPole]);

switch type
    case 'LL'
        gain = ll_gain;
        controller = LL_controller;
    case 'PI'
        gain = pi_gain;
        controller = pi_controller;
    case 'INT'
        gain = i_gain;
        controller = i_controller;
end

boost_OL = series(boost_tf, controller);
boost_CL = feedback(boost_OL*gain, 1);


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


%% Open Loop Results

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
% Pre-step Bode Plot
figure(2);
bode(boost_tf);
title("Bode plot for Boost converter - Open loop, no controller");
grid on;
movegui('north');

figure(3);
rlocus(boost_tf);
title("Root Locus for Boost converter - Closed loop, no controller");
grid on;
movegui('northeast');

figure(4);
step(boost_tf, 10e-3)
title("Open loop step response - no controller")
grid on;
movegui('west');

%% Results: With Controller

figure(5);
rlocus(boost_OL);
title(strcat("Pre-Step Root Locus - Closed loop, controller type: ",type))
grid on;

figure(6);
bode(boost_CL);
title(strcat("Pre-Step Bode Diagram - Closed loop, controller type: ",type))
grid on;
movegui('east');

figure(7);
step(boost_CL, 500e-3)
title(strcat("Step response - Closed loop, controller type: ", type));
grid on;
movegui('southwest');

%% 

% Finds values starting from 0
% 5% Settling Threshold
startUpInfo = stepinfo(boost_CL, 'SettlingTimeThreshold', 0.05)
damp(boost_CL)

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
