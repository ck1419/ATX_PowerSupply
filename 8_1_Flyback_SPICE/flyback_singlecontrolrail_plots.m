close all; clear all;

%% VaryVin
data = xlsread('flyback_singlecontrolrail_data.xlsx','A2:E92743');

%%
time = data(:,1);
v_pwm = data(:,2);
vout = data(:,3);
i_prim = data(:,4);
i_sec = data(:,5);
p_in = 400.*i_prim;
p_out = vout.*i_sec;

%% Output voltage
figure(1);
plot(time.*1000, vout, '-');
xlabel('Time(ms)');
xlim([0 0.05]);
ylabel('V_{out} (V)');
saveas(gcf,'fb_singlectonrol_vout.jpeg')

%% Currents
figure(2);
plot(time.*1000, i_prim, '-'); hold on;
plot(time.*1000, i_sec, '-'); hold on;
legend('I_{prim}','I_{sec}')
xlabel('Time(ms)');
xlim([0 0.1]);
ylim([-50 100]);
ylabel('I (A)');
saveas(gcf,'fb_singlectonrol_currents.jpeg')

%% Zoomed Voltage
figure(3);
plot(time.*1000, vout, '-');
xlabel('Time(ms)');
xlim([0 10]);
ylim([2.23 2.27]);
ylabel('V_{out} (V)');
saveas(gcf,'fb_singlectonrol_vout_zoomed.jpeg')

%% PWM
figure(4);
plot(time.*1000, v_pwm, '-');
xlabel('Time(ms)');
xlim([0 0.05]);
ylim([-0.5 1.5]);
ylabel('V_{out} (V)');
saveas(gcf,'fb_singlectonrol_pwm.jpeg')

%% Power
figure(5);
plot(time.*1000, p_in, '-'); hold on;
plot(time.*1000, p_out, '-'); hold on;
legend('P_{in}','P_{out}')
xlabel('Time(ms)');
xlim([0 0.1]);
ylim([-1600 200]);
ylabel('P (W)');
saveas(gcf,'fb_singlectonrol_power.jpeg')
