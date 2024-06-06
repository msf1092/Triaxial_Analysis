function [sample_height_err, area_err, sensor_coeff, sellipaine, sellipaine_ending, ...
    sample_diam_init, sample_height_init, sample_weight_init, sample_mid_water_level, ...
    con_vol_compression, con_vol_change, weight_can, weight_can_wet, weight_can_dry] = fncTestInputs(T1)
% The function takes measured input data for each test!

defaultanswer = {'0','0','1',sprintf('%d', mean(T1(:,5))),sprintf('%d', mean(T1(:,5))),'51','110','411.77','10.5','0.12','1.4','10.15','420.74','312.50'};
prompt = {'Sample height error','Area error','Sensor coefficient','Sellipaine (kPa)','Ending sellipaine (kPa)', ...
    'Initial diameter (mm)','Initial height (mm)','Initial weight (gr)','Water level (in the middle of specimen) (cm)', ...
    'volumetric compression (mm)','Volume change (ml)','Weight of can (gr)','Weight of can + wet soil (gr)','Weight of can + dry soil (gr)'};
dlgtitle = 'Test input parameters';
dims = [1 60];
test_inputs = inputdlg(prompt,dlgtitle,dims,defaultanswer);

sample_height_err = str2double(test_inputs{1});
area_err = str2double(test_inputs{2});
sensor_coeff = str2double(test_inputs{3});
sellipaine = str2double(test_inputs{4});
sellipaine_ending = str2double(test_inputs{5});
sample_diam_init = str2double(test_inputs{6});
sample_height_init = str2double(test_inputs{7});
sample_weight_init = str2double(test_inputs{8});
sample_mid_water_level = str2double(test_inputs{9});
con_vol_compression = str2double(test_inputs{10});
con_vol_change = str2double(test_inputs{11});
weight_can = str2double(test_inputs{12});
weight_can_wet = str2double(test_inputs{13});
weight_can_dry = str2double(test_inputs{14});

end