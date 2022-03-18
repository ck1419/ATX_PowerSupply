clc; clear all; clf; close all;

Load = [100 90 80 70 60 50];

V_in = 100;

Vout_max = [485.341	498.195	513.034	528.503	546.173	565.842];
Vout_avg = [401.129	401.965	402.895	403.308	404.457	406.036];
ir_avg = [1.597173757724227,1.440132358164183,1.284127576642334,1.124119810618936,0.966953410468953,0.806910835516448];
iL_avg = [6.68056	6.03437	5.38621	4.71488	4.06455	3.41128];
settle = [0.00208792	0.00213792	0.00216801	0.00282035	0.00293035	0.00366795];
rise = [0.00037111	0.000369667	0.000350881	0.000340591	0.000339021	0.00032086];
pout = Vout_avg.* ir_avg;
pin = V_in .* iL_avg;
eff = pout./pin;

overshoot = (Vout_max-Vout_avg)./Vout_avg;
damping = log(overshoot)./sqrt(pi^2+1);
omega = 3./damping./settle;


%%

figure(1);
plot(Load, pout, 'kx-');
ylabel('P_{out} (W)');
xlabel('Load(%)');
filename = ['realBoost_varyLoad_power.jpg'];
saveas(gcf,filename)

%%

figure(2);
plot(Load, eff.*100, 'kx-');
ylabel('Efficiency (%)');
xlabel('Load(%)');
filename = ['realBoost_varyLoad_efficiency.jpg'];
saveas(gcf,filename)

figure(3);
plot(Load, rise*1000, 'kx-');
ylabel('Rise Time (ms)');
xlabel('Load(%)');
filename = ['realBoost_varyLoad_risetime.jpg'];
saveas(gcf,filename)

figure(4);
plot(Load, settle*1000, 'kx-');
ylabel('Settling Time (ms)');
xlabel('Load(%)');
filename = ['realBoost_varyLoad_settlingtime.jpg'];
saveas(gcf,filename)

figure(5);
plot(Load, overshoot*100, 'kx-');
ylabel('Percentage Overshoot (%)');
xlabel('Load(%)');
filename = ['realBoost_varyLoad_overshoot.jpg'];
saveas(gcf,filename)

%%
figure(6);
plot(Load, omega, 'kx-');
ylabel('Oscillation Frequency (Hz)');
xlabel('Load(%)');
filename = ['realBoost_varyLoad_oscillation.jpg'];
saveas(gcf,filename)










