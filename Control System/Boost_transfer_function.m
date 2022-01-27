clear all;
close all;
clc;


%% Circuit Parameters


% State-space average model of a Boost Converter
% u=[delta]; x=[i_L; v_C]; y=[v_O]
% Component Parameters
L = 11.43e-3; 
r_L = 0.05; 
C = 1.21e-6; 
r_C = 0.02; 
R = 247;


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
boost_ss = ss(A,E,C,F);


%% Unit Step


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


% Boost Transfer Function
[boost_tf_upper, boost_tf_lower] = ss2tf(A,B,C,0);
boost_tf = tf(boost_tf_upper, boost_tf_lower);

% Plot results
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

%Pre-step Bode Plot
figure(2);
bode(boost_tf);
grid on;