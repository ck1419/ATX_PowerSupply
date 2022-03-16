clc; clear all; clf; close all;

Load = [10 5 2 1 0.1];

Vout_max = [679.99	694.577	702.067	776.046	1092.46];
Vout_avg = [438.599	441.309	592.393	771.627	1054.14];
ic_avg = [0.00212982	0.000353518	-0.00131957	0.00264842	0.0191396];
ir_avg = [0.174809	0.0879446	0.0472211	0.0307542	0.0042014];
iL_avg = [0.779548	0.396728	0.27392	0.261465	0.251401];
settle = [0.00208252	0.00508194	0.00850035	0.00529794	0.0142282];
rise = [0.00019824	0.000190099	0.000251302	0.000429392	0.0116599];
pout = [76.6713	38.8108	27.9739	23.731	4.43087];
pin = [-77.9548	-39.6728	-27.392	-26.1465	-25.1401];
eff = [1.03222	1.24549	146.464	230.311	58.2246];

overshoot = (Vout_max-Vout_avg)./Vout_avg;
damping = log(overshoot)./sqrt(pi^2+1);
omega = 3./damping./settle;


%%
figure(1);
plot(Load, pout, 'kx-', 'LineWidth',2);
ylabel('P_{out} (W)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_power_veryLowLoad.jpg'];
saveas(gcf,filename)

figure(2);
plot(Load, eff.*100, 'kx-', 'LineWidth',2);
ylabel('Efficiency (%)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_efficiency_veryLowLoad.jpg'];
saveas(gcf,filename)

figure(3);
plot(Load, rise*1000, 'kx-', 'LineWidth',2);
ylabel('Rise Time (ms)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_risetime_veryLowLoad.jpg'];
saveas(gcf,filename)

figure(4);
plot(Load, settle*1000, 'kx-', 'LineWidth',2);
ylabel('Settling Time (ms)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_settlingtime_veryLowLoad.jpg'];
saveas(gcf,filename)

figure(5);
plot(Load, overshoot*100, 'kx-', 'LineWidth',2);
ylabel('Percentage Overshoot (%)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_overshoot_veryLowLoad.jpg'];
saveas(gcf,filename)

figure(6);
plot(Load, omega, 'kx-', 'LineWidth',2);
ylabel('Oscillation Frequency (Hz)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_oscillation_veryLowLoad.jpg'];
saveas(gcf,filename)

%% Confirmation for discontinuous mode

V_I = 100;
delta = 0.75;
L = 1.33E-3;
f = 100e3;
%I_in = linspace(0.00159,0.159,100);
% V_O = zeros(1,size(I_in, 2));
for i=1:size(I_in, 2)
    V_O(1,i) = V_I/(1-(V_I*delta^2/2/I_in(1,i)/L/f));
end

figure(7)
plot(I_in, V_O);
