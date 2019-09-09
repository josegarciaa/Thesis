%Setup constants for simulation%

%Experiment Parameters%
dt = 0.1;               % timestep in ms
tmax = 1500;            % trial timme in ms
numTrainingTrials = 5; %120; %40; %75; %50;  % number of trials where training conditions apply
numTestingTrials = 0; %300; %15; %10; %15;   % number of trials where testing conditions apply 
numTrials = numTrainingTrials + numTestingTrials;          % number of trials
numOuterTrials = 1; %15;
binSizeFR = 250 / dt; %100 / dt;
breakpoint = 7500;

%Parameters for Cortical Groups%
percentExcCortex = .8;        %Sets percent of cells in each group to be excitatory
numCorticalGroups = 2;% 2;          %Total groups cells
cellsInCorticalGroup = 50;      %Cells per group
numCorticalCells = numCorticalGroups * cellsInCorticalGroup;    %Calculate total number of cells
excCellsInCorticalGroup = round(cellsInCorticalGroup * percentExcCortex);     %calculates # of exc cells in each group
inhCellsInCorticalGroup = cellsInCorticalGroup - excCellsInCorticalGroup;       %makes rest of cells in each group inhib
numExcCellsCortex = excCellsInCorticalGroup * numCorticalGroups;              %calc total # of exc cells
numInhCellsCortex = inhCellsInCorticalGroup * numCorticalGroups;              %calc total $ of inhib cells

%Parameters for LGN Groups%
numLGNGroups = 2;
excCellsInLGNGroup = 2;
numInhIN = 1;
cellsInLGNGroup = excCellsInLGNGroup;
numLGNCells = numLGNGroups *  cellsInLGNGroup;
numExcCellsLGN = excCellsInLGNGroup * numLGNGroups;
lagSize = 100 / dt; %Size of lag between LGN cells in ms

%Totals%
numTotalGroups = numCorticalGroups + numLGNGroups;
numTotalCells = numCorticalCells + numLGNCells + numInhIN;

%Cell parameters%
gL = 12;                %Leak conductance (microS)
Cm = 200;               %Capacitance (nF) 
EL = -70;               %Leak potential (mV)
VThresh = -50;          %Threshold potential (mV)
VReset = -75;           %Reset potential (mV)
Vexc = 0;               %Rev potential for exc cells (mV)
Vinh = -70;             %Rev potential for inhib cells (mV)
Vmax = 20;              %Max voltage during spike (mV)
deltaT = 2;             %Threshold shift factor (mV)
tauSRA = 20;            %Adaptation time constant (ms)
a = 4;                  %Adaptation recovery 
b = 0;%50;                 %Adaptation strength
tauAMPA = 50;%20;           %Time constant for exc synapses 
tauGABA = 5;%100;          %Time constant for inhib synapses 
Delta_s = .5;           %Amount of vesicles released per spike 

%Settings for simulations%
trainingConds = {'Bi-directional Square','Bi-directional Sine', 'Constant Current', 'LGN Bi-directional', 'LGN Uni-directional'};
ColumnSettingsCortex = {'No Connections','Recurrent','Inhibition Stabilized','Stronger Recurrent'};
ColumnSettingLGN = {'Recurrent'};
LGNtoCortexSettings = {'Feedforward to Exc'};
STDPsettings = {'Standard','Triplet Per-trial','Triplet Continous', 'None'};
STDPAmplitudeSettings = {'Small','Large'};
crossColumnSettings = {'No Connections','EE','EI','IE'};

%Input Current Parameters%
constantCurrent = 60;
originalOnBiasCurrent = 20 + constantCurrent;
originalOffBiasCurrent = 0 + constantCurrent;
offBiasCurrent = originalOffBiasCurrent;
onBiasCurrent = originalOnBiasCurrent; 
noiseCurrent = 1800; %Noisy current size (nA) Above Threshold non-discriminate firing

tauLTD = 20;            %Time constant for LTD
tauLTP = 20;            %Time constant for LTP
depress_bias = .15;%.05;     %Bias for LTD over LTP 
deltaWMax = 1;%.1;               %Maximum weight change allowed between synapses
wMaxTotal = 25; %25; %10; %3;%8;
wMaxTriplet = 10;%.01;
wMaxLGN = 5;
wMaxIN = 25;

tau_post_2 = 20; %Time window of 2 spikes for depression (sec)
tau_pre_2 =  20; %Time window of 2 spikes for potentiation (sec)
tau_post_3 = 100; %Time window of 2 post-spikes for potentiation (sec)

%Additional plasticity parameters%
ampLTPi = .0001; %Potentiation of inhibitory synapses following presynaptic spike according to veto rule
POSDLTPiAmp = 1.001; %Multiplicative ratio for strengthening inhitiory synapses according to POSDLTPi rule

save constants.mat; %Save variables as mat file

