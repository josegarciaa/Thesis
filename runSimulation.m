setupConstants %Setup constants for simulation
initVectors %Initialize vectors and matrixes 

%Setup experiment%
%Adjust settings for current simulation here%
trainingCond = trainingConds(4); %Set input to cortex during training 
testingCond = trainingConds(4); %Set input to cortex during testing  
STDPsetting = STDPsettings(2);  %Set STDP rule
ColumnSetupCortex = ColumnSettingsCortex(2); %Connection matrix settings 
STDPAmplitude = STDPAmplitudeSettings(2); %Large amplitude for testing hypothesese, small for running experiments/ collecting data
crossColumnSettingCortex = crossColumnSettings(2); %Initial connections between cortical groups
ColumnSetupLGN = ColumnSettingLGN(1); %Initial connections between LGN cells
LGNtoCortexSetup = LGNtoCortexSettings(1); %Initial connections from LGN to cortex
inhibLTPCondition = 'Off'; 
POSDLTPiCondition = 'Off';
trainingCortex = true; %Set intracortical plasticity on/off
trainingLGN = true; %Set plasticity from LGN to Cortex on/off
save('settings','trainingCond','testingCond','STDPsetting','ColumnSetupCortex','STDPAmplitude','crossColumnSettingCortex',...
    'LGNtoCortexSetup','inhibLTPCondition','POSDLTPiCondition','trainingCortex','trainingLGN');

setupInitWeightValues %Set values for initial matrix based on settings
setupInitValues %Setup vectors, matrixes, and initial conditions

outerTrialCount = 1; %Repeat trials only once
save('variables');%save current variables to mat file
variableFile = matfile('variables.mat','Writable',true);

for trialCounter = 1:numTrials %Repeat entire experiment for as many trials as required
   variableFile.trialCounter = trialCounter;
   setupTrial('variables'); %Reset variables and set conditions for each trial
   simulate('variables'); %Run simulated trial and saves results to 'variables.mat'
   postTrialCalc('variables'); %Calculates stats from simulated trial and updates 'variables.mat' with results
end

plasticityFigures('variables') %Plot figures showing plasticity results 