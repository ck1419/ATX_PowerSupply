%% Very Low Load

data = xlsread('simulation_timeresults_veryLowLoads.xlsx','A3:AM71457');

%% Adjust which waveform to view
% 2: VIN, 3:VOUT, 4: IC1, 5: ID1, 6: IL1, 7: IRload
for j=2:7
    close all;
    ylabel_str = "";
    filename = "";
    switch j
        case 2
            ylabel_str = 'V_{in} (V)';
            filename = 'ideal_boost_veryLowLoad_startup_VIN.jpg';
        case 3
            ylabel_str = 'V_{out} (V)';
            filename = 'ideal_boost_veryLowLoad_startup_VOUT.jpg';
        case 4
            ylabel_str = 'I_{C} (A)';
            filename = 'ideal_boost_veryLowLoad_startup_IC.jpg';
        case 5
            ylabel_str = 'I_{diode} (A)';
            filename = 'ideal_boost_veryLowLoad_startup_Idiode.jpg';
       case 6
            ylabel_str = 'I_{L} (A)';
            filename = 'ideal_boost_veryLowLoad_startup_Iind.jpg';
        case 7
            ylabel_str = 'I_{R_{Load}} (A)';
            filename = 'ideal_boost_veryLowLoad_startup_Irload.jpg';
    end


    vout1_time = data(:,1);
    vout1_data = data(:,j);
    vout2_time = data(:,9);
    vout2_data = data(:,j+8);
    vout3_time = data(:,17);
    vout3_data = data(:,j+16);
    vout4_time = data(:,25);
    vout4_data = data(:,j+24);
    vout5_time = data(:,33);
    vout5_data = data(:,j+32);

    figure(1);
    plot(vout1_time.*1000, vout1_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
    plot(vout2_time.*1000, vout2_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
    plot(vout3_time.*1000, vout3_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
    plot(vout4_time.*1000, vout4_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
    plot(vout5_time.*1000, vout5_data, '-', 'LineWidth',2, 'MarkerSize',1); hold on;
    legend('10%','5%','2%','1%','0.1%')
    xlabel('Time(ms)');
    ylabel(ylabel_str);
    xlim([0 4]);
    set(gca,'FontSize',12);
    set(gca,'FontWeight','bold');
    set(gca,'LineWidth',2);
    saveas(gcf,filename)
end