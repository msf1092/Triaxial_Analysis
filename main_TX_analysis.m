clear; all_fig = findall(0, 'type', 'figure'); close(all_fig); format compact; clc

in_path = 'C:/Users/qdmofa/OneDrive - TUNI.fi/FINCONE II/FINCONE II - Data/Test sites/Ulvila/Laboratory Program n results/Triaxial/Raw data/Triaxial';
out_path = 'C:/Users/qdmofa/OneDrive - TUNI.fi/Fincone II-adjunct/Lab data Analysis/Triaxial/TX analysis/Output';
if ~exist(out_path, 'dir')
    mkdir(out_path)
end

TX_type = input('Enter the type of triaxial test [CICU, CICD, CACU, CACD]: \n','s')
switch TX_type
    case "CICU"
        Tests_no = input("For how many tests do you wanna draw the stress paths? \n");
        if Tests_no ~= 0
            for i = 1 : Tests_no

                %%%%%%%%%% Correction of tau for membrane
                mmb_no = input(sprintf("How many membranes have you used for test %d? \n", i));
                [mmb_diam, mmb_thick, mmb_E] = fncMembraneCorrection(mmb_no);

                %%%%%%%%%% Read data from file
                % Measurements
                [file,path] = uigetfile({'*.asc', 'Measurements (*.asc)';'*.*','All Files (*.*)'}, 'Input [measurements file]');
                file_dscr = replace(file,"ASC","INF");        path_dscr = path;
                file_path_name = fullfile(path, file);
                T = readtable(file_path_name, "Encoding","UTF-8","FileType","text", "Delimiter","\t");
                T.Properties.VariableNames = {'Time (sec)','e1 (sec)','tau (sec)','u (sec)','s3 (sec)','ev (sec)','Load (sec)','disp. (sec)','vaaka (sec)','Voltage (sec)'};
                T1 = table2array(T);
                % Description
                file_path_name_dscr = fullfile(path_dscr, file_dscr);
                T_dscr = readtable(file_path_name_dscr, "FileType","text", "Delimiter","", "VariableNamingRule","preserve");

                %%%%%%%%%% Correction of tau for anisotropic consolidation [This part should be developed for Anisotropic tests!!!]
                tau_ajoutee_aniso(1:length(T1),1) = 0;

                tau_corr(1:length(T1), 1) = T1(:,3) - 4 * (mmb_thick * mmb_E / mmb_diam * (T1(:,2) / 100) / 2 * mmb_no + tau_ajoutee_aniso);
                T = addvars(T,tau_corr,'After',"Voltage (sec)"); % adding tau_corr to the data table T
                T.tau_corr = tau_corr;
                T1 = [T1 tau_corr];

                %%%%%%%%%% Test input parameters
                [sample_height_err, area_err, sensor_coeff, sellipaine, sellipaine_ending, ...
                    sample_diam_init, sample_height_init, sample_weight_init, sample_mid_water_level, ...
                    con_vol_compression, con_vol_change, weight_can, weight_can_wet, weight_can_dry] = fncTestInputs(T1);

                %%%%%%%%%% Weight-Volume relationships
                sample_area_init = ((sample_diam_init / 2) ^ 2) * pi() / 100;
                sample_vol_init = sample_area_init * sample_height_init / 10;
                sample_weight_consolidated = sample_weight_init - con_vol_change;
                weight_dry = weight_can_dry - weight_can;
                weight_water = sample_weight_init - weight_dry;
                water_content = (weight_water / weight_dry) * 100;
                unit_weight = sample_weight_init / sample_vol_init;
                bulk_density = unit_weight * 9.81;
                unit_weight_dry = weight_dry / sample_vol_init;
                bulk_density_dry = unit_weight_dry * 9.81;
                Sr_Barvo = fncBarvo();
                Gs = weight_dry / (sample_vol_init - weight_water);
                e = weight_water / (sample_vol_init - weight_water);
                porosity = e + 1;
                Gs_presumed = 2.7; % the following '_presumption' params are based on this Gs_presumed!
                Sr_presumption = water_content * Gs_presumed / e; % [%]
                e_presumption = (sample_vol_init * Gs_presumed / weight_dry) - 1;
                porosity_presumption = e_presumption + 1;
                unit_weight_comp = sample_weight_consolidated / (sample_vol_init - con_vol_change) * 9.81; % [kN/m3]
                unit_weight_dry_comp = weight_dry / (sample_vol_init  - con_vol_change) * 9.81; % [kN/m3]
                compression = con_vol_compression / sample_height_init * 100; % [%]
                vol_change = con_vol_change / sample_vol_init * 100; % [%]
                % final state
                weight_wet_final = weight_can_wet - weight_can;
                weight_water_final = weight_wet_final - weight_dry;
                water_content_final = weight_water_final / weight_dry * 100; % [%]
                WVparams = table(sample_area_init,sample_vol_init, ...
                    sample_weight_consolidated,weight_dry,weight_water,unit_weight,bulk_density,unit_weight_dry,bulk_density_dry, ...
                    Sr_Barvo,Gs,e,porosity,Gs_presumed,Sr_presumption,e_presumption,porosity_presumption, ...
                    unit_weight_comp,unit_weight_dry_comp,compression,vol_change, ...
                    weight_wet_final,weight_water_final,water_content_final, ...
                    'VariableNames',["Initial sample area","Initial sample volume", ...
                    "Consolidated sample's weight","Dry weight of sample","Water weight","Unit weight of sample","Bulk density","Dry unit weight","Dry bulk density", ...
                    "Saturation ratio based on B-value","Specific gravity, G_s","Void ratio, e","Porosity, n","Presumed specific gravity, G_{s, pres}","Saturation ratio based on G_{s, pres}","Void ratio based on G_{s, pres}","Porosity based on G_{s, pres}", ...
                    "Computed unit weight","Computed dry unit weight","Compression percentage after consolidation","Volume change after consolidation", ...
                    "Wet weight of soil at the end of TX test","Water weight at the end of TX test","Water content at the end of TX test"]);

                %%%%%%%%%% Drawing eps-tau chart
                eps1 = zeros(length(T1)+1,1);
                eps1(2:end,1) = T1(1:end,1) / (1 + sample_height_err / 100);
                tau_max = zeros(length(T1)+1,1);
                tau_max(2:end,1) = tau_corr(1:end,1) / (1 + area_err / 100) * sensor_coeff;

                %%%%%%%%%% Drawing p-q chart
                s3_ave_meas = mean(T1(:,5)); % input
                %                 sellipaine = str2double(sellipaine); % input (But I guess it should be tuned, based on the )
                s3_var = sellipaine - s3_ave_meas;
                sellipaine_corr = zeros(length(T1)+1,1);
                sellipaine_corr(1,1) = sellipaine;
                sellipaine_corr(2:end,1) = T1(:,5) + s3_var;
                sellipaine_eff = sellipaine_corr(1:end-1,1) - T1(:,4);
                q_prime = 2 * tau_max(1:end-1,1);
                p_prime = sellipaine_eff + q_prime / 3;

                %%%%%%%%%% Drawing Mohr-Coulomb chart
                % FELAN BIKHIALESH MISHAM
                s3 = zeros(length(T1)+1,1);
                s3(2:end, 1) = T1(:,5);
                s1 = zeros(length(T1)+1,1);
                s1(2:end, 1) = 2 * tau_max(2:end,1) + s3(2:end,1); % sigma'_1

                %%%%%%%%%% Save the computed results in workspace (to be plotted altogether)
                results{i,1} = T1;
                results{i,2} = eps1;
                results{i,3} = tau_max;
                results{i,4} = p_prime;
                results{i,5} = q_prime;
                results{i,6} = WVparams;

                %%%%%%%%%% Clear parameters for next loop
                clearvars -except results Tests_no

            end
            % plots & c|phi estimation
            fncPlots(results)
            for i = 1:Tests_no;     results{i,7} = [c_est_manually phi_est_manually];   end;
        else
            disp("Should I do any triaxial test for you?")
        end
    case "CICD"
        disp("Not developed yet!")
    case "CACU"
        disp("Not developed yet!")
    case "CACD"
        disp("Not developed yet!")
    otherwise
        disp("Not considered at all! Check the spelling!")
end