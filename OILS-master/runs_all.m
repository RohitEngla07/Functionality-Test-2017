constants_v15

tic
mdl = 'adcs_v15_integral';
load_system(mdl)
simMode = get_param(mdl, 'SimulationMode');
set_param(mdl, 'SimulationMode', 'rapid')
simOut = sim(mdl, 120000);
clc
toc
 
% simNum = 102;
% plotall
