clc; clf; clear all; close all; 

syms L_eq1;
syms r_eq1;
syms r_m1;
syms L_m1;
syms L_1;
syms L_eq2;
syms r_eq2;
syms C;
syms r_c;
syms R;
syms k_N;

syms big_d;
syms small_d;

syms V_in;

StepSize = 0.5;

%%

ripple_ratio = 1/2; % delta i_L/I_L
V_in = 400;
V_out = 3.3;
Delta = 0.5;
P_in = 708; %637W / 0.9
f_sw = 100e3;
I_out = 34;
ripple_vout = 50e-3;

% Choose R to ensure it draws power as the entire device (637.7W, not only 34A)
% R = V^2/P
% R_load_list = [97.1e-3 129.4e-3 194.1e-3 388.2e-3]; % old list
R_load_list = [0.01708	0.01897	0.02135	0.0244	0.02846	0.03415];

% Select i for Load percentage to test
load_percentage = ["100% load" "75% load" "50% load" "25% load"];
load_filename = ["100load" "75load" "50load" "25load"];
i = 1;

L_eq1 = 0;
r_eq1 = 1e-3;
r_m1  = 0;
L_1   = (V_in * Delta)^2/(ripple_ratio*P_in*f_sw);
L_m1  = L_1;
L_eq2 = 0;
r_eq2 = 1e-3;
C     = (Delta * I_out)/(f_sw*ripple_vout);
r_c   = 25e-3; % Testing
R     = R_load_list(1,i);
k_N   = V_out/V_in;
big_d = Delta;


%%  State Space

% L_2 = k_N^2 * L_1;
% k_N = I_1/ I_2;

%Use Lm = L1 = L2 for now
L_1 = L_m1;
L_2 = k_N^2 * L_1;

% On state
A_on = [-r_eq1/L_1, 0 %fixed
        0, -1/(C*(R+r_c))]
B_on = [1/L_1; 0]
C_on = [0, R/(R+r_c)]

% Off state: Non transformed (iL2, VL)
A_off = [-1/L_2*(R*r_c)/(R+r_c), - 1/L_2*R/(R+r_c);
        R/(C*(R+r_c)), -1/(C*(R+r_c))]
B_off = [0;0]
C_off = [R*r_c/(R+r_c), R/(R+r_c)]

% Off state: Transformed (iL1, VL)
Transform = [k_N 0; 0 1];
A_off_T = Transform * A_off * inv(Transform)
B_off_T = Transform * B_off
C_off_T = C_off * inv(Transform)


%% State Space Averaging

% Operating point
A = big_d*A_on + (1-big_d)*A_off_T;
B = big_d*B_on + (1-big_d)*B_off_T;
C = big_d*C_on + (1-big_d)*C_off_T;

U = V_in;
X = -inv(A)*B*U;
Y = C*X;

%Small-signal model
E = (A_on-A_off_T)*X + (B_on-B_off_T)*U;
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
    xlim([0 0.2]);
    grid on;

    subplot(3,1,2)
    plot(T,iL)
    xlabel("Time [s]")
    ylabel("Current [A]")
    title("Current Output")
    xlim([0 0.2]);
    grid on;

    subplot(3,1,3)
    plot(T,y)
    xlabel("Time [s]")
    ylabel("Voltage [V]")
    title("Voltage Output")
    grid on;
    xlim([0 0.2]);

    saveas(gcf,strcat('basic_fb_',load_filename(i),'_ol_time.jpeg'))

    %%

    % Pre-step Bode Plot
    figure(4);
    bode(fb_ss);
    title(strcat("Bode plot - Open loop, no controller, ", load_percentage(i)));
    grid on;
    saveas(gcf,strcat('basic_fb_',load_filename(i),'_ol_bode.jpeg'))

    figure(5);
    rlocus(fb_ss);
    title(strcat("Root Locus - Closed loop, no controller, ", load_percentage(i)));
    grid on;
    saveas(gcf,strcat('basic_fb_',load_filename(i),'_ol_rlocus.jpeg'))

    figure(6);
    step(fb_ss, 1e-3)
    title(strcat("Open loop step response - no controller, ", load_percentage(i)))
    grid on;
    saveas(gcf,strcat('basic_fb_',load_filename(i),'_ol_step.jpeg'))


    %% PI Controller

    % kP = -741; kI = -7.179e6; % Should be in the 10's micro range?
    % kP = 0.0004; kI = 0.8;
    kP = 0.085; kI=8000;
    pi_gain = 1;

    pi_controller = pid(kP, kI, 0);


    %% CHOOSE CONTROLLER TYPE HERE

    type = 'PI'; % Available options: LL, PI, Int
    gain = pi_gain;
    controller = pi_controller;

    fb_OL = series(fb_ss, controller);
    fb_CL = feedback(fb_OL*gain, 1);

    %% Results: With Controller

    figure(7);
    rlocus(fb_OL);
    title(strcat("Pre-Step Root Locus - Closed loop, ", load_percentage(i)))
    grid on;
    saveas(gcf,strcat('basic_fb_',load_filename(i),'_cl_rlocus.jpeg'))

    figure(8);
    bode(fb_CL);
    title(strcat("Pre-Step Bode Diagram - Closed loop, ", load_percentage(i)))
    grid on;
    saveas(gcf,strcat('basic_fb_',load_filename(i),'_cl_bode.jpeg'))


    figure(9);
    step(fb_CL, 1e-3);
    xlim([0 0.0005]);
    title(strcat("Step response - Closed loop, ", load_percentage(i)));
    grid on;
    saveas(gcf,strcat('basic_fb_',load_filename(i),'_cl_step.jpeg'))
    
    %%
    % Finds values starting from 0
    % 5% Settling Threshold
    startUpInfo = stepinfo(fb_CL, 'SettlingTimeThreshold', 0.05)
    damp(fb_CL);