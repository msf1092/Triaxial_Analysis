function [mmb_diam, mmb_thick, mmb_E] = fncMembraneCorrection(mmb_no)
% Correction for membrane(s)
% Only cases for 1 or 2 membranes are considered here! For more membranes,
% the function should be modified!

switch mmb_no
    case 1
        defaultanswer = {'182.21','184.25','186.34','34.84','50','100','200','0.64','0.62','0.74'};
        prompt = {'Initial length of membrane (mm)','Length of membrane after 1st weight (mm)','Length of membrane after 2nd weight (mm)', ...
            'Height of clip (mm)','Diameter of membrane (mm)','1st weight (gr)','2nd weight (gr)', ...
            'Thickness of membrane [top] (mm)','Thickness of membrane [middle] (mm)','Thickness of membrane [bottom] (mm)'};
        dlgtitle = 'Membrane correction parameters';
        dims = [1 60];
        mmb1_inputs = inputdlg(prompt,dlgtitle,dims,defaultanswer);

        mmb1_length0 = str2double(mmb1_inputs{1}); % 182.21; % input
        mmb1_length1 = str2double(mmb1_inputs{2}); % 184.25; % input
        mmb1_length2 = str2double(mmb1_inputs{3}); % 186.34; % input
        clip1_height = str2double(mmb1_inputs{4}); % 34.84; % input
        mmb1_diam = str2double(mmb1_inputs{5}); % 35.8; % input (diameter of membrane, mm)
        weight1 = str2double(mmb1_inputs{6}); % 100; % input
        weight2 = str2double(mmb1_inputs{7}); % 200; % input
        mmb1_thick1 = str2double(mmb1_inputs{8}); % 0.64; % input
        mmb1_thick2 = str2double(mmb1_inputs{9}); % 0.62; % input
        mmb1_thick3 = str2double(mmb1_inputs{10}); % 0.74; % input

        mmb1_thick = mean([mmb1_thick1, mmb1_thick2, mmb1_thick3]) / 2;
        mmb1_area = ( ( (mmb1_diam + mmb1_thick) / 2) ^ 2  * pi ) - ( (mmb1_diam / 2) ^ 2 * pi); % AD48 in Excel
        mmb1_lod_E1 = (weight1 / 1000 * 9.81 / mmb1_area) / ( (mmb1_length1 - mmb1_length0) / (mmb1_length0 - clip1_height) ) * 1000; % AE53 in Excel
        mmb1_lod_E2 = (weight2 / 1000 * 9.81 / mmb1_area) / ( (mmb1_length2 - mmb1_length0) / (mmb1_length0 - clip1_height) ) * 1000; % AE54 in Excel
        mmb1_lod_E = mean([mmb1_lod_E1, mmb1_lod_E2]); % AE56 in Excel

        mmb_diam = mmb1_diam;  % M5 in Excel
        mmb_thick = mmb1_thick;
        mmb_E = mmb1_lod_E; % AF58 in Excel
    case 2
        defaultanswer = {'182.21','184.25','186.34','34.84','50','100','200','0.64','0.62','0.74'};
        prompt = {'Initial length of membrane 1 (mm)','Length of membrane 1 after 1st weight (mm)','Length of membrane 1 after 2nd weight (mm)', ...
            'Height of clip 1 (mm)','Diameter of membrane 1 (mm)', ...
            '1st weight for membrane 1 (gr)','2nd weight for membrane 1 (gr)', ...
            'Thickness of membrane 1 [top] (mm)','Thickness of membrane 1 [middle] (mm)','Thickness of membrane 1 [bottom] (mm)'};
        dlgtitle = 'Membrane 1, correction parameters';
        dims = [1 60];
        mmb1_inputs = inputdlg(prompt,dlgtitle,dims,defaultanswer);

        prompt = {'Initial length of membrane 2 (mm)','Length of membrane 2 after 1st weight (mm)','Length of membrane 2 after 2nd weight (mm)', ...
            'Height of clip 2 (mm)','Diameter of membrane 2 (mm)', ...
            '1st weight for membrane 2 (gr)','2nd weight for membrane 2 (gr)', ...
            'Thickness of membrane 2 [top] (mm)','Thickness of membrane 2 [middle] (mm)','Thickness of membrane 2 [bottom] (mm)'};
        dlgtitle = 'Membrane 2, correction parameters';
        dims = [1 60];
        mmb2_inputs = inputdlg(prompt,dlgtitle,dims,defaultanswer);

        mmb1_length0 = str2double(mmb1_inputs{1}); % 182.21; % input
        mmb1_length1 = str2double(mmb1_inputs{2}); % 184.25; % input
        mmb1_length2 = str2double(mmb1_inputs{3}); % 186.34; % input
        clip1_height = str2double(mmb1_inputs{4}); % 34.84; % input
        mmb1_diam = str2double(mmb1_inputs{5}); % 35.8; % input (diameter of membrane, mm)
        mmb1_weight1 = str2double(mmb1_inputs{6}); % 100; % input
        mmb1_weight2 = str2double(mmb1_inputs{7}); % 200; % input
        mmb1_thick1 = str2double(mmb1_inputs{8}); % 0.64; % input
        mmb1_thick2 = str2double(mmb1_inputs{9}); % 0.62; % input
        mmb1_thick3 = str2double(mmb1_inputs{10}); % 0.74; % input

        mmb2_length0 = str2double(mmb2_inputs{1}); % 180; % input
        mmb2_length1 = str2double(mmb2_inputs{2}); % 181; % input
        mmb2_length2 = str2double(mmb2_inputs{3}); % 183; % input
        clip2_height = str2double(mmb2_inputs{4}); % 35; % input
        mmb2_diam = str2double(mmb2_inputs{5}); % 50; % input (diameter of membrane, mm)
        mmb2_weight1 = str2double(mmb2_inputs{6}); % 100; % input
        mmb2_weight2 = str2double(mmb2_inputs{7}); % 200; % input
        mmb2_thick1 = str2double(mmb2_inputs{8}); % 1.2; % input
        mmb2_thick2 = str2double(mmb2_inputs{9}); % 1.0; % input
        mmb2_thick3 = str2double(mmb2_inputs{10}); % 0.8; % input

        mmb1_thick = mean([mmb1_thick1, mmb1_thick2, mmb1_thick3]) / 2;
        mmb2_thick = mean([mmb2_thick1, mmb2_thick2, mmb2_thick3]) / 2;

        mmb1_area = ( ( (mmb1_diam + mmb1_thick) / 2) ^ 2  * pi ) - ( (mmb1_diam / 2) ^ 2 * pi); % AD48 in Excel
        mmb1_lod_E1 = (mmb1_weight1 / 1000 * 9.81 / mmb1_area) / ( (mmb1_length1 - mmb1_length0) / (mmb1_length0 - clip1_height) ) * 1000; % AE53 in Excel
        mmb1_lod_E2 = (mmb1_weight2 / 1000 * 9.81 / mmb1_area) / ( (mmb1_length2 - mmb1_length0) / (mmb1_length0 - clip1_height) ) * 1000; % AE54 in Excel
        mmb1_lod_E = mean([mmb1_lod_E1, mmb1_lod_E2]); % AE56 in Excel

        mmb2_area = ( ( (mmb2_diam + mmb2_thick) / 2) ^ 2  * pi ) - ( (mmb2_diam / 2) ^ 2 * pi); % AD66 in Excel
        mmb2_lod_E1 = (mmb2_weight1 / 1000 * 9.81 / mmb2_area) / ( (mmb2_length1 - mmb2_length0) / (mmb2_length0 - clip2_height) ) * 1000; % AE71 in Excel
        mmb2_lod_E2 = (mmb2_weight2 / 1000 * 9.81 / mmb2_area) / ( (mmb2_length2 - mmb2_length0) / (mmb2_length0 - clip2_height) ) * 1000; % AE72 in Excel
        mmb2_lod_E = mean([mmb2_lod_E1, mmb2_lod_E2]); % AE74 in Excel

        mmb_diam = mean([mmb1_diam, mmb2_diam]); % M5 in Excel
        mmb_thick = mean([mmb1_thick, mmb2_thick]);
        mmb_E = mean([mmb1_lod_E, mmb2_lod_E]); % AF58 in Excel
    otherwise
        disp("Contact 112! Either the app or the membranes number needs to be improved!")
end
end