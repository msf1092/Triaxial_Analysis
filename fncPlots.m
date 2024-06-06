function fncPlots(results)
% The function draws plots based on the derived results from different
% tests in same chart.

% The number of rows in 'results':
n = size(results);
n = n(1,1);

% Plot the results
figure("Name","results", "Units","centimeters", "Position",[2 4 8 22]);
tiledlayout(4,1,"TileSpacing","compact","Padding","compact")

nexttile(1)
for i = 1 : n
    eps1 = results{i,2};    tau_max = results{i,3};
    x = eps1;   y = tau_max;
    plot(x,y, "Marker","o", "MarkerEdgeColor",[0.0000 0.7000 0.2000], "MarkerSize",6);     hold on
    plot(x,y, "LineStyle","-", "Color",[0.0000 0.0000 0.0000], "LineWidth",0.85);
    xmin = min(cat(1,results{:,2}));    xmax = max(cat(1,results{:,2}));    ymin = min(cat(1,results{:,3}));    ymax = max(cat(1,results{:,3}));    xlim([xmin-0.05*(xmax-xmin) xmax+0.05*(xmax-xmin)]);    ylim([ymin-0.05*(ymax-ymin) ymax+0.05*(ymax-ymin)]);
    xlabel("\epsilon_{corr} (%)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");    ylabel("\tau (kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");
    legend("\tau_{max}", "AutoUpdate","on", "Location","southeast");
    ax = get(gca, "XTickLabel");    set(gca, "XTickLabel", ax, "FontSize",9, "FontName","times");
    ax = get(gca, "YTickLabel");    set(gca, "YTickLabel", ax, "FontSize",9, "FontName","times");
    grid on;    grid minor;    hold on
end

nexttile(2)
for i = 1 : n
    T1 = results{i,1};
    x = T1(:,2); y = T1(:,4);
    plot(x,y, "Marker","o", "MarkerEdgeColor",[0.0000 0.7000 0.2000], "MarkerSize",6);     hold on
    plot(x,y, "LineStyle","-", "Color",[0.0000 0.0000 0.0000], "LineWidth",0.85);
    T1_all = cat(1,results{:,1});   xmin = min(T1_all(:,2));    xmax = max(T1_all(:,2));    ymin = min(T1_all(:,4));    ymax = max(T1_all(:,4));    xlim([xmin-0.05*(xmax-xmin) xmax+0.05*(xmax-xmin)]);    ylim([ymin-0.05*(ymax-ymin) ymax+0.05*(ymax-ymin)]);
    xlabel("\epsilon_{meas} (%)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");    ylabel("u (kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");
    legend("u", "AutoUpdate","on", "Location","northeast");
    ax = get(gca, "XTickLabel");    set(gca, "XTickLabel", ax, "FontSize",9, "FontName","times");
    ax = get(gca, "YTickLabel");    set(gca, "YTickLabel", ax, "FontSize",9, "FontName","times");
    grid on;    grid minor;    hold on
end

nexttile(3)
for i = 1 : n
    T1 = results{i,1};
    x = T1(:,2); y = T1(:,5);
    plot(x,y, "Marker","o", "MarkerEdgeColor",[0.0000 0.7000 0.2000], "MarkerSize",6);     hold on
    plot(x,y, "LineStyle","-", "Color",[0.0000 0.0000 0.0000], "LineWidth",0.85);
    T1_all = cat(1,results{:,1});   xmin = min(T1_all(:,2));    xmax = max(T1_all(:,2));    ymin = min(T1_all(:,5));    ymax = max(T1_all(:,5));    xlim([xmin-0.05*(xmax-xmin) xmax+0.05*(xmax-xmin)]);    ylim([ymin-0.05*(ymax-ymin) ymax+0.05*(ymax-ymin)]);
    xlabel("\epsilon_{meas} (%)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");    ylabel("\sigma'_3 (kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");
    legend("u", "AutoUpdate","on", "Location","best");
    ax = get(gca, "XTickLabel");    set(gca, "XTickLabel", ax, "FontSize",9, "FontName","times");
    ax = get(gca, "YTickLabel");    set(gca, "YTickLabel", ax, "FontSize",9, "FontName","times");
    grid on;    grid minor;    hold on
end

%%%%%%%%%% Finding c & phi
% by user:
% Interactive plot: Manual selection of C and phi:
[c_est, phi_est] = FncUserCnPhi(results)
pause()

c_est_manually = evalin('base', 'c_est_manually');
phi_est_manually = evalin('base', 'phi_est_manually');
phi_est_manually_rad = phi_est_manually / 180 * pi;
M_slope = 6 * sin(phi_est_manually_rad) / (3 - sin(phi_est_manually_rad)); 
nexttile(4)
for i = 1 : n
    p_prime = results{i,4};     q_prime = results{i,5};
    x = p_prime;   y = q_prime;
    plot(x,y, "Marker","o", "MarkerEdgeColor",[0.0000 0.7000 0.2000], "MarkerSize",6);     hold on
    plot(x,y, "LineStyle","-", "Color",[0.0000 0.0000 0.0000], "LineWidth",0.85);          hold on
    x1 = [0 1.2*max(x)];    y1 = c_est_manually + M_slope * x1;
    plot(x1,y1, "LineStyle","-", "Color",[0.0000 0.0000 1.0000], "LineWidth",0.85)
    xmin = min(cat(1,results{:,4}));    xmax = max(cat(1,results{:,4}));    ymin = min(cat(1,results{:,5}));    ymax = max(cat(1,results{:,5}));    xlim([0-0.05*(xmax-0) xmax+0.05*(xmax-xmin)]);    ylim([ymin-0.05*(ymax-ymin) ymax+0.05*(ymax-ymin)]);
    xlabel("\itp' \rm(kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");    ylabel("\itq' \rm(kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");
    legend("\itp'-q'", "AutoUpdate","on", "Location","southeast");
    ax = get(gca, "XTickLabel");    set(gca, "XTickLabel", ax, "FontSize",9, "FontName","times");
    ax = get(gca, "YTickLabel");    set(gca, "YTickLabel", ax, "FontSize",9, "FontName","times");
    grid on;    grid minor;    hold on
    str = {['\itc_{est} \rm(kPa) = ',num2str(c_est_manually,"%4.1f")], ['\it\phi_{est} \rm(deg) = ',num2str(phi_est_manually,"%4.1f")]};
    annotation("textbox", "Position",[0.19 0.12 0.1 0.1], "String",str, "FontSize",9, "FontName","times", "LineWidth",0.25, "LineStyle","none","BackgroundColor",[1 1 1], "FaceAlpha",0.7);
end
end