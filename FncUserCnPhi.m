function [c_e, phi_e] = FncUserCnPhi(results)
% Interactive C and Phi estimation visually, by user!

% The number of rows in 'results':
n = size(results);
n = n(1,1);

fig = uifigure("Name","Select C and Phi values manually!","Units","normalized", "Position",[0.7 0.5 0.29 0.38]);
ax = uiaxes(fig,"Position",[250 200 500 300]);
% p-q curves:
for i = 1 : n
    p_prime = results{i,4};     q_prime = results{i,5};
    x = p_prime;   y = q_prime;
    plot(ax,x,y,"LineStyle","-","Color",[0.0000 0.6000 0.0000],"LineWidth",0.7,"Marker","+","MarkerEdgeColor",[0.7000 0.7000 0.2000],"MarkerSize",4); hold(ax,"on");
    xmin = min(cat(1,results{:,4}));    xmax = max(cat(1,results{:,4}));    ymin = min(cat(1,results{:,5}));    ymax = max(cat(1,results{:,5}));    ax.XLim = [min(0,xmin)-0.3*xmin xmax+0.1*xmax];  ax.YLim = [min(0,ymin)-0.3*ymin ymax+0.1*ymax];
    xlabel(ax, "\itp' \rm(kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");    ylabel(ax, "\itq' \rm(kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");
end
% failure line
c = 0; phi = 20; slope = tan((phi / 180) * pi);
x1 = ([0 1.2*max(q_prime)]);    y1 = c + slope * x1;
plot(ax,x1,y1); hold(ax,"off");

%slider
% pnl = uipanel(fig,"Title","C and phi", "Units", "normalized", "Position",[0.1 0.1 0.85 0.2]);
lbl_c = uilabel(fig, "Position",[940 70 50 20]);
sld_c = uislider(fig, "Position",[80 80 840 3],"Limits",[0 30], "ValueChangingFcn",@(sld_c,event_c) sliderMoving_c(event_c,ax,lbl_c));
c_e = [];
lbl_phi = uilabel(fig, "Position",[940 30 50 20]);
sld_phi = uislider(fig, "Position",[80 40 840 3],"Limits",[0 60], "ValueChangingFcn",@(sld_phi,event_phi) sliderMoving_phi(event_phi,ax,lbl_phi));
phi_e = [];

% Save button
btn = uibutton(fig,'push', 'Text','Save Value', 'Position', [80 300 100 30],'ButtonPushedFcn', @(btn,event) plotButtonPushed(btn,fig,lbl_c,lbl_phi));

    function sliderMoving_c(event_c,ax,lbl_c)
        for i = 1 : n
            p_prime = results{i,4};     q_prime = results{i,5};
            x = p_prime;   y = q_prime;
            plot(ax,x,y,"LineStyle","-","Color",[0.0000 0.6000 0.0000],"LineWidth",0.7,"Marker","+","MarkerEdgeColor",[0.7000 0.7000 0.2000],"MarkerSize",4); hold(ax,"on");
            xmin = min(cat(1,results{:,4}));    xmax = max(cat(1,results{:,4}));    ymin = min(cat(1,results{:,5}));    ymax = max(cat(1,results{:,5}));    ax.XLim = [min(0,xmin)-0.3*xmin xmax+0.1*xmax];  ax.YLim = [min(0,ymin)-0.3*ymin ymax+0.1*ymax];
            xlabel(ax, "\itp' \rm(kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");    ylabel(ax, "\itq' \rm(kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");
        end
        c = event_c.Value;      slope = tan((phi / 180) * pi);
        y1 = c + slope * x1;
        plot(ax,x1,y1); hold(ax,"off");
        %labels:
        lbl_c.Text = string(event_c.Value);
    end

    function sliderMoving_phi(event_phi,ax,lbl_phi)
        for i = 1 : n
            p_prime = results{i,4};     q_prime = results{i,5};
            x = p_prime;   y = q_prime;
            plot(ax,x,y,"LineStyle","-","Color",[0.0000 0.6000 0.0000],"LineWidth",0.7,"Marker","+","MarkerEdgeColor",[0.7000 0.7000 0.2000],"MarkerSize",4); hold(ax,"on");
            xmin = min(cat(1,results{:,4}));    xmax = max(cat(1,results{:,4}));    ymin = min(cat(1,results{:,5}));    ymax = max(cat(1,results{:,5}));    ax.XLim = [min(0,xmin)-0.3*xmin xmax+0.1*xmax];  ax.YLim = [min(0,ymin)-0.3*ymin ymax+0.1*ymax];
            xlabel(ax, "\itp' \rm(kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");    ylabel(ax, "\itq' \rm(kPa)", "FontSize",10, "FontName","times", "Color","k", "Visible","on");
        end
        phi = event_phi.Value;      slope = tan((phi / 180) * pi);
        y1 = c + slope * x1;
        plot(ax,x1,y1); hold(ax,"off");
        %labels:
        lbl_phi.Text = string(event_phi.Value);
    end

lbl_c = uilabel(fig,"Text","$c (kPa)$", "Position",[20 70 50 20]);    lbl_c.Interpreter = "latex";
lbl_phi = uilabel(fig,"Text","$M (^{\circ})$", "Position",[20 30 100 20]);   lbl_phi.Interpreter = "latex";

% Button to close GUI and save the threshold value
    function button = plotButtonPushed(btn,fig,lbl_c,lbl_phi)
        c_e = str2double(lbl_c.Text)
        phi_e = str2double(lbl_phi.Text) % M

        M = tan(phi_e / 180 * pi);
        phi_est = asin( 3*M / (6+M) ) * 180/pi % M

        assignin("base","c_est_manually",c_e)
        assignin("base","phi_est_manually",phi_est)
        close(fig)
    end
end