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

%% Example: Designing a 400V to 3.3V flyback converter

ripple_ratio = 1/2; % delta i_L/I_L
V_in = 400;
V_out = 3.3;
Delta = 0.5;
P_in = 708; %637W / 0.9
f_sw = 100e3;
I_out = 34;
ripple_vout = 50e-3;

% Choose R to ensure it draws power as the entire device
% R = V^2/P
R_load_list = [97.1e-3 129.4e-3 194.1e-3 388.2e-3];

%% Select i for Load percentage to test
load_percentage = ["100% load" "75% load" "50% load" "25% load"];

figure(1);
grid on;
for i=1:size(load_percentage,2)

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

    % Modeling Conditions
    StepSize = 0.5;

    %% State Space

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
    E = (A_on-A_off)*X + (B_on-B_off_T)*U;
    F = (C_on-C_off_T)*X;

    fb_ss = ss(A, E, C, F);

    %% Transfer Function
    [fb_tf_upper, fb_tf_lower] = ss2tf(A,E,C,F);
    boost_tf = tf(fb_tf_upper, fb_tf_lower)

    %% PI Controller

    kP = -741;
    kI = -7.179e6; % Should be in the 10's micro range?
    pi_gain = 1;

    pi_controller = pid(kP, kI, 0);

    %% CHOOSE CONTROLLER TYPE HERE

    type = 'PI'; % Available options: LL, PI, Int    
    gain = pi_gain;
    controller = pi_controller;
    fb_OL = series(fb_ss, controller);
    fb_CL = feedback(fb_OL*gain, 1);

    step(fb_CL, 0.6e-3); hold on;
end
xlim([0 0.0001]);
legend(load_percentage, 'Location','Southeast');
title(strcat("Step response with PI Controller"))
saveas(gcf,strcat('compare_fb_loads.jpeg'));