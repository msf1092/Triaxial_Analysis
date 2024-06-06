function [Sr] = fncBarvo()
% The function computes the saturation ratio of the sample!
% The Sr is calculated based on the pore pressure measurements, within
% 95-98% range of pore pressure measurements.

[file, path] = uigetfile({'*.txt', 'B-value (*.txt)';'*.*','All Files (*.*)'}, 'Select B-arvo file');
file_path_name = fullfile(path, file);
T = readtable(file_path_name, "Encoding","UTF-8","FileType","text", "Delimiter","\t","ReadVariableNames",false);
T.Properties.VariableNames = {'Time Day-hr.min.sec,_','Increased pore pressure (kPa)','Increased cell pressure (kPa)'};
B_pore_pressure = str2double(strrep(T{:,2}, ',','.'));
B_inc_cell_pressure = str2double(strrep(T{:,3}, ',','.'));
% time
newStr = split(T{:,1},["-"]);
newStr = strrep(newStr, ',','.');
[Y, M, D, H, MN, S] = datevec(char(newStr{:,2}), 'HH.MM.SS.FFF');
time_sec = H*3600+MN*60+S;
time_sec = time_sec - time_sec(1);
time_min = H*60 + MN + S/60;
time_min = time_min - time_min(1);

% Saturation check
n = length(time_min);
lowInd = round(n * 0.95);
upInd = round(n * 0.98);
cell_press9095 = mean(B_inc_cell_pressure(lowInd:upInd,1));
pore_press9095 = mean(B_pore_pressure(lowInd:upInd,1));
Sr = (pore_press9095 / cell_press9095) * 100;

% figure(); y1 = B_inc_cell_pressure; y2 = B_pore_pressure;
% plot(time_min, y1); hold on; plot(time_min, y2);
end


