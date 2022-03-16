clc; clear all; clf; close all;

Load = [100 90 80 70 60 50];

Vout_max = [506.304	520.104	533.731	549.548	566.933	585.748];
Vout_avg = [402.916	405.24	407.586	409.959	412.361	414.794];
ic_avg = [0.00244165	0.00301037	0.00358059	0.00415528	0.00473414	0.00532586];
ir_avg = [1.63124	1.47628	1.3199	1.16169	1.00161	0.839495];
iL_avg = [7.07191	6.40803	5.73801	5.06014	4.37426	3.6797];
settle = [0.00134808	0.00135805	0.00135821	0.00178034	0.00185029	0.00189079];
rise = [0.00022903	0.00021978	0.000210626	0.000210171	0.000209275	0.0002003];
pout = [657.288	598.276	537.992	476.257	413.032	348.222];
pin = [-707.191	-640.803	-573.801	-506.014	-437.426	-367.97];
eff = [0.930175	0.934483	0.93859	0.942407	0.945777	0.948422];
load_ratio = pin/750;

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
filename = ['ideal_boost_power.jpg'];
saveas(gcf,filename)

figure(2);
plot(Load, eff.*100, 'kx-', 'LineWidth',2);
ylabel('Efficiency (%)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_efficiency_varyLoad.jpg'];
saveas(gcf,filename)

figure(3);
plot(Load, rise*1000, 'kx-', 'LineWidth',2);
ylabel('Rise Time (ms)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_risetime_varyLoad.jpg'];
saveas(gcf,filename)

figure(4);
plot(Load, settle*1000, 'kx-', 'LineWidth',2);
ylabel('Settling Time (ms)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_settlingtime_varyLoad.jpg'];
saveas(gcf,filename)

figure(5);
plot(Load, overshoot*100, 'kx-', 'LineWidth',2);
ylabel('Percentage Overshoot (%)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_overshoot_varyLoad.jpg'];
saveas(gcf,filename)

%%
figure(6);
plot(Load, omega, 'kx-', 'LineWidth',2);
ylabel('Oscillation Frequency (Hz)');
xlabel('Load(%)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
filename = ['ideal_boost_oscillation_varyLoad.jpg'];
saveas(gcf,filename)









