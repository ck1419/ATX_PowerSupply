clear;
close all;
clc;

%% Instructions

% 1. Define controller parameters in Lead lag controller, PI Controller, Integral Controller sections
% 2. Choose controller type in CHOOSE CONTROLLER TYPE HERE


%% Circuit Parameters

R_load_list = [250.9 278.8 313.6 358.8 418.2 501.8];
load_percentage = ["100load" "90load" "80load" "70load" "60load" "50load"];

V_in = [100 200 300 350];
V_in_String = ["100V" "200V" "300V" "350V"];


%%

figure(1);
grid on;

for i=1:size(R_load_list,2)
    % for j=1:size(V_in,2)
    j = 1

        % State-space average model of a Boost Converter
        % u=[delta]; x=[i_L; v_C]; y=[v_O]
        % Component Parameters
        L = 3.14e-3; % real values 
        r_L = 3.29e-3; 
        C = 1.21e-6; 
        r_C = 0.528; 
        R = R_load_list(i);

        % Circuit Conditions
        V_I = V_in(j); 
        Delta = 1-V_I/400;

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

        %% PI Controller

        % kP = 300e-6; % Should be in the milli to 10k range? % kI = 0.6; % Should be in the 10's micro range?
        kP = 0.000152; kI = 0.85553;
        pi_gain = 1;

        pi_controller = pid(kP, kI, 0);

        %% CHOOSE CONTROLLER TYPE HERE

        gain = pi_gain;
        controller = pi_controller;
        boost_OL = series(boost_tf, controller);
        boost_CL = feedback(boost_OL*gain, 1);

        %% Results: With Controller

        % figure(4);
        % step(boost_tf, 5e-3)
        % title(strcat("Open loop step response - no controller, ", load_percentage(i), ", V_{in}=", V_in_String(j)))
        % grid on;
        % saveas(gcf,strcat('boost_',load_percentage(i),V_in_String(j),'_ol_step.jpeg'))

        step(boost_CL, 50e-3); hold on;

    % end
end
legend(load_percentage, 'Location','Southeast');
title(strcat("Step response with PI Controller, V_{in}=", V_in_String(j)))
saveas(gcf,strcat('compare_boost_',V_in_String(j),'.jpeg'));
