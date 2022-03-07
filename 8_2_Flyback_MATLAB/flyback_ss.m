clc; clf; clear all; close all; 

% syms L_eq1;
% syms r_eq1;
% syms r_m1;
% syms L_m1;
% syms L_1;
% syms L_eq2;
% syms r_eq2;
% syms C;
% syms r_c;
% syms R;
% syms k_N;
% 
% syms big_d;
% syms small_d;

%% Example: Designing a 400V to 12V flyback converter

ripple_ratio = 1/2; % delta i_L/I_L
V_in = 400;
V_out = 3.3;
Delta = 0.5;
P_in = 708; %637W / 0.9
f_sw = 100e3;
I_out = 34;
ripple_vout = 50e-3;

% Choose R to ensure it draws power as the entire device
% R = P/V^2 = 637.7/3.3^2
R_load = 58.5583;
% R_load = 97.1e-3;

L_eq1 = 0;
r_eq1 = 0;
r_m1  = 0;
L_1   = (V_in * Delta)^2/(ripple_ratio*P_in*f_sw);
L_m1  = L_1;
L_eq2 = 0;
r_eq2 = 0;
C     = (Delta * I_out)/(f_sw*ripple_vout);
r_c   = 0;
R     = R_load;
k_N   = V_out/V_in;
big_d = Delta;

% Modeling Conditions
StepSize = 0.05;

%% State Space

L_2 = k_N^2 * L_1;

% On state
A_on = [-(L_eq1+r_eq1)/L_1, 0; %fixed
        0, -1/(C*(R+r_c))];
B_on = [1/L_1; 0];
C_on = [0, R/(R+r_c)];

% Off state: Non transformed (iL2, VL)
A_off = [1/L_2*(-R*r_c/(R+r_c)-L_eq2- r_eq2), - R/(L_2*(R+r_c));
        R/(C*(R+r_c)), -1/(C*(R+r_c))];
B_off = [0;0];
C_off = [R*r_c/(R+r_c), R/(R+r_c)];

% Off state: Transformed (iL1, VL)
Transform = [1/k_N 0; 0 1];
A_off_T = Transform * A_off * inv(Transform);
B_off_T = Transform * B_off;
C_off_T = C_off * inv(Transform);

%% State Space Averaging

% Operating point
A = big_d*A_on + (1-big_d)*A_off_T;
B = big_d*B_on + (1-big_d)*B_off_T;
C = big_d*C_on + (1-big_d)*C_off_T;

U = V_in;
X = -inv(A)*B*U;
Y = C*X;

%Small-signal model
E = (A_on-A_off)*X + (B_on-B_off_T)*U;
F = (C_on-C_off_T)*X;

fb_ss = ss(A, E, C, F);

%% Transfer Function
[fb_tf_upper, fb_tf_lower] = ss2tf(A,E,C,F);
boost_tf = tf(fb_tf_upper, fb_tf_lower)

%% Unit Step Delta

% Find unit step-response
T = 0:0.001:StepSize;
[y,T,x] = step(fb_ss,T);

% Scale step-response and add to operating point
iL = 0.05*x(:,1)+X(1)*ones(length(T),1);
y = 0.05*y+Y*ones(length(T),1);

% Add time prior to step
T = [0; T+0.15];
iL = [X(1); iL];
y = [Y; y];


%% Open Loop Results

% Delta unit-step
figure(1);
subplot(3,1,1)
plot([0, 0.15, 0.1501, 0.2], [Delta, Delta, Delta+StepSize, Delta+StepSize])
ylim([Delta-0.05 Delta+0.05+StepSize]);
xlabel("Time [s]")
ylabel("Duty Cycle")
title("Delta Input")
grid on;

subplot(3,1,2)
plot(T,iL)
xlabel("Time [s]")
ylabel("Current [A]")
title("Current Output")
grid on;

subplot(3,1,3)
plot(T,y)
xlabel("Time [s]")
ylabel("Voltage [V]")
title("Voltage Output")
grid on;
movegui('northwest');

%%

% Pre-step Bode Plot
figure(2);
bode(fb_ss);
title("Bode plot for FB converter - Open loop, no controller");
grid on;
movegui('north');

figure(3);
rlocus(fb_ss);
title("Root Locus for FB converter - Closed loop, no controller");
grid on;
movegui('northeast');

figure(4);
step(fb_ss, 10e-3)
title("Open loop step response - no controller")
grid on;
movegui('west');

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

kI = 0.0000001;
i_gain = 3.11e7;

% Integral Controller
i_controller = tf([kI], [1 0]);

%% CHOOSE CONTROLLER TYPE HERE

type = 'Int'; % Available options: LL, PI, Int

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

fb_OL = series(fb_ss, controller);
fb_CL = feedback(fb_OL*gain, 1);

%% Results: With Controller

figure(5);
rlocus(fb_OL);
title(strcat("Pre-Step Root Locus - Closed loop, controller type: ",type))
grid on;

figure(6);
bode(fb_CL);
title(strcat("Pre-Step Bode Diagram - Closed loop, controller type: ",type))
grid on;
movegui('east');

figure(7);
step(fb_CL, 500e-3)
title(strcat("Step response - Closed loop, controller type: ", type));
grid on;
movegui('southwest');
