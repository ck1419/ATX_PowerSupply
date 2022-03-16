close all; clear all;

%% VaryVin
data = xlsread('BasicFlyBackData.xlsx','A2:L30000');
%%

time = data(:,1);
vout_plus5 = data(:,2);
vout_plus12 = data(:,3);
vout_minus5 = data(:,4);
vout_minus12 = data(:,5);
vout_33 = data(:,6);
iout_plus12 = data(:,7);
iout_plus5 = data(:,8);
iout_33 = data(:,9);
iout_minus5 = data(:,10);
iout_minus12 = data(:,11);
i_in = data(:,12);

%% Output voltages
figure(1);
plot(time.*1000, vout_plus5, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(time.*1000, vout_minus5, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(time.*1000, vout_plus12, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(time.*1000, vout_minus12, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(time.*1000, vout_33, '-', 'LineWidth',2, 'MarkerSize',1);
legend('+5V','-5V','+12V','-12V','3V')
xlabel('Time(ms)');
xlim([0 2]);
ylabel('V_{out} (V)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
saveas(gcf,'basic_fb_vout.jpeg')

%% Curents
figure(2);
plot(time.*1000, iout_plus5, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(time.*1000, iout_minus5, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(time.*1000, iout_plus12, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(time.*1000, iout_minus12, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(time.*1000, iout_33, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
plot(time.*1000, i_in, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
legend('I_{+5V}','I_{-5V}','I_{+12V}','I_{-12V}','I_{3V}', 'I_{in}')
xlabel('Time(ms)');
xlim([0 2]);
ylim([0 400]);
ylabel('I (A)');
set(gca,'FontSize',12);
set(gca,'FontWeight','bold');
set(gca,'LineWidth',2);
saveas(gcf,'basic_fb_currents.jpeg')