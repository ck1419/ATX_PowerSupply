clc; clear all; clf; close all;

V_in = [100 150 200 250 300 350];
duty = (400-V_in)./400;

Vout_max = [506.304 549.083 558.065 530.16 490.672 446.893];
Vout_avg = [402.916 418.299 428.02 415.409 409.935 403.372];
ic_avg = [0.00244165 0.0118717 0.0180314 0.0103782 0.00513967 0.00219789];
ir_avg = [1.63124 1.69352 1.73288 1.68182 1.65966 1.63308];
iL_avg = [7.07191 4.9686 3.84586 2.85353 2.28876 1.89334];
settle = [0.00134808 0.00124056 0.00111586 0.000904899 0.000870213 0.000470214];
rise = [0.00022903 0.00013941 9.96E-05 7.19E-05 5.96E-05 4.85E-05];
pout = [657.288 708.426 741.727 698.653 680.357 658.74];
pin = [-707.191 -745.29 -769.172 -713.383 -686.628 -662.669];
eff = [0.930175 0.952631 0.968325 0.985543 0.9971 0.997095];

overshoot = (Vout_max-Vout_avg)./Vout_avg;
damping = log(overshoot)./sqrt(pi^2+1);
omega = 3./damping./settle;


%%

figure(1);
plot(V_in, Vout_avg, 'x-', 'LineWidth',2);
title('V_{out} against V_{in}');

figure(2);
plot(V_in, eff.*100, 'kx-', 'LineWidth',2);
ylabel('Efficiency (%)');
xlabel('Input Voltage (V)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_efficiency.jpg'];
saveas(gcf,filename)

figure(3);
plot(V_in, rise*1000, 'kx-', 'LineWidth',2);
ylabel('Rise Time (ms)');
xlabel('Input Voltage (V)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_risetime.jpg'];
saveas(gcf,filename)

figure(4);
plot(V_in, settle*1000, 'kx-', 'LineWidth',2);
ylabel('Settling Time (ms)');
xlabel('Input Voltage (V)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_settlingtime.jpg'];
saveas(gcf,filename)

figure(5);
plot(V_in, overshoot*100, 'kx-', 'LineWidth',2);
ylabel('Percentage Overshoot (%)');
xlabel('Input Voltage (V)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_overshoot.jpg'];
saveas(gcf,filename)

figure(6);
plot(V_in, omega, 'kx-', 'LineWidth',2);
ylabel('Oscillation Frequency (Hz)');
xlabel('Input Voltage (V)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_oscillation.jpg'];
saveas(gcf,filename)









