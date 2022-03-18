clc; clear all; clf; close all;

V_in = [100 150 200 250 300 350];
duty = (400-V_in)./400;

Vout_max = [483.072	522.526	528.298	504.403	472.974	436.019];
Vout_avg = [401.291	409.384	412.23	406.24	402.527	399.59];
ir_avg = [1.891837286713287,1.599242821178822,1.663236659850109,1.641154473362482,1.626994552145024,1.617123182374249];
iL_avg = [6.79148	4.64249	3.51272	2.71565	2.21514	1.86868];
settle = [0.00206798	0.00190048	0.00148164	0.00144465	0.00116294	0.000543364];
rise = [0.000380234	0.000221522	0.000160137	0.000126184	9.85E-05	8.01E-05];
pout = Vout_avg.* ir_avg;
pin = V_in .* iL_avg;
eff = pout./pin;

overshoot = (Vout_max-Vout_avg)./Vout_avg;
damping = log(overshoot)./sqrt(pi^2+1);
omega = 3./damping./settle;


%%

figure(1);
plot(V_in, Vout_avg, 'kx-');
title('V_{out} against V_{in}');

figure(2);
plot(V_in, eff.*100, 'kx-');
ylabel('Efficiency (%)');
xlabel('Input Voltage (V)');
filename = ['realBoost_varyVin_efficiency.jpg'];
saveas(gcf,filename)

figure(3);
plot(V_in, rise*1000, 'kx-');
ylabel('Rise Time (ms)');
xlabel('Input Voltage (V)');
filename = ['realBoost_varyVin_risetime.jpg'];
saveas(gcf,filename)

figure(4);
plot(V_in, settle*1000, 'kx-');
ylabel('Settling Time (ms)');
xlabel('Input Voltage (V)');
filename = ['realBoost_varyVin_settlingtime.jpg'];
saveas(gcf,filename)

figure(5);
plot(V_in, overshoot*100, 'kx-');
ylabel('Percentage Overshoot (%)');
xlabel('Input Voltage (V)');
filename = ['realBoost_varyVin_overshoot.jpg'];
saveas(gcf,filename)

figure(6);
plot(V_in, omega, 'kx-');
ylabel('Oscillation Frequency (Hz)');
xlabel('Input Voltage (V)');
filename = ['realBoost_varyVin_oscillation.jpg'];
saveas(gcf,filename)









