load('constants');

%Vector and Matrix Setup%
time = 0:dt:tmax;                                      %Time vector for trials
trialLength = length(time);                             %calculates trial length
Vm = zeros(numTotalCells, trialLength);                      %Matrix for cell's membrane voltage over time
SRA = zeros(numTotalCells, trialLength);                     %Matrix for cell's SRA
Iapp = zeros(numTotalCells,trialLength);                     %Matrix for applied current to each cell
inputCurrentVector = zeros(numTotalCells,trialLength);
spikeCount = zeros(numTotalCells,1);                         %Vector for cell's spikecount
spikeCountInstantFR = zeros(numTotalCells,1);
AvgFRPrefferedCortex = zeros(numCorticalCells,numOuterTrials); 
AvgFRPrefferedLGN = zeros(numExcCellsLGN,numOuterTrials); 
AvgFRNullCortex = zeros(numCorticalCells,numOuterTrials);%Vector for cell's average FR
AvgFRNullLGN = zeros(numExcCellsLGN,1);
AvgFRCortex = zeros(numCorticalCells,1);
spikeTrain = zeros(numTotalCells,trialLength);               %Matrix of cell's spiketrains
spikeTime = zeros(numTotalCells,trialLength);                %Matrix with cell's spiketimes
s = zeros(numTotalCells,trialLength);                        %Matrix for cell's synaptic gating variable 
sLGN = zeros(numExcCellsLGN,trialLength);    
sLGNtoIN = zeros(numExcCellsLGN,trialLength);   
totalSynCurrent = zeros(numTotalCells,trialLength);          %Matrix for cell's total input synaptic current
LGNcurrent = zeros(numTotalCells,trialLength);
INcurrent = zeros(numTotalCells,trialLength);
w = zeros(numTotalCells,numTotalCells);                           %Matrix of synaptic weight values
Vsynrev = zeros(numTotalCells,1);                            %Vector with reversal synapses of the cells
tauSyn = zeros(numTotalCells,1);                             %Vector with synaptic time constant for each cell
deltaWLTD = zeros(numTotalCells, numTotalCells);                  %Matrix keeping track of LTD changes per loop iteration
deltaWLTDtotal = zeros(numTotalCells, numTotalCells);             %Matrix keeping track of total LTD changes for trial
deltaWLTP = zeros(numTotalCells, numTotalCells);                  %Matrix keeping track of LTP changes per loop iteration
deltaWLTPtotal = zeros(numTotalCells, numTotalCells);             %Matrix keeping track of total LTP changes for trial
inhLTP = zeros(numTotalCells, numTotalCells);
deltaW = zeros(numTotalCells, numTotalCells);                     %Matrix with total sum of LTP and LTD for trial 
deltaWTotal = zeros(numTotalCells, numTotalCells);   
tripletPotentiation = zeros(numTotalCells, numTotalCells);
tripletDepression = zeros(numTotalCells, numTotalCells);
instantFR = zeros(numTotalCells, floor(trialLength / binSizeFR));
extraCurrentVectPref = zeros(1,5000);
extraCurrentVectNull = zeros(1,5000);
sE = zeros(numTotalCells,1);           % excitatory synaptic conductances
sI = zeros(numTotalCells,1);           % inhibitory synaptic conductances

%Vectors for calculating DSI of various groups%
DSIVector = zeros(numCorticalCells,numTrials);
DSIexcGroup1 = zeros(numCorticalGroups,numTrials);
DSIexcGroup2 = zeros(numCorticalGroups,numTrials);
DSIVectorLGNCond = zeros(numCorticalGroups,numTrials);
DSIVectorTesting = zeros(numCorticalGroups,numTrials);
DSIMatrixGroup1 = zeros(numOuterTrials, numTrials);
DSIMatrixGroup2 = zeros(numOuterTrials, numTrials);

%Vectors for average firing rates%
AvgFRPrefferedExcCortexMatrixGroup1 = zeros(numOuterTrials, numTrials);
AvgFRNullExcCortexMatrixGroup1 = zeros(numOuterTrials, numTrials);
AvgFRPrefferedInhCortexMatrixGroup1 = zeros(numOuterTrials, numTrials);
AvgFRNullInhCortexMatrixGroup1 =zeros(numOuterTrials, numTrials);
AvgFRPrefferedExcCortexMatrixGroup2 = zeros(numOuterTrials, numTrials);
AvgFRNullExcCortexMatrixGroup2 = zeros(numOuterTrials, numTrials);
AvgFRPrefferedInhCortexMatrixGroup2 = zeros(numOuterTrials, numTrials);
AvgFRNullInhCortexMatrixGroup2 =zeros(numOuterTrials, numTrials);
excGroup1AvgFRPref = zeros(1,numTrials);
excGroup2AvgFRPref = zeros(1,numTrials);
excGroup1AvgFRNull = zeros(1,numTrials);
excGroup2AvgFRNull = zeros(1,numTrials);
excGroup1AvgFR = zeros(1,numTrials);
excGroup2AvgFR = zeros(1,numTrials);
AvgFRExcTotal = zeros(1,numTrials);
inhibGroup1AvgFR = zeros(1,numTrials);
inhibGroup2AvgFR = zeros(1,numTrials);
AvgFRInhibTotal = zeros(1,numTrials);

%Vectors for average synaptic weights between groups%
avgLGNtoCortexInputPrefGroup1 = zeros(1,numTrials);
avgLGNtoCortexInputPrefGroup2 = zeros(1,numTrials);
avgLGNtoCortexInputNullGroup1 = zeros(1,numTrials);
avgLGNtoCortexInputNullGroup2 = zeros(1,numTrials);
avgWeightEtoE1 = zeros(1,numTrials+1);
avgWeightEtoE2 = zeros(1,numTrials+1);
avgWeightEtoE = zeros(1,numTrials+1);
avgWeightEtoI1 = zeros(1,numTrials+1);
avgWeightEtoI2 = zeros(1,numTrials+1);
avgWeightE1toE2 = zeros(1,numTrials+1);
avgWeightE2toE1 = zeros(1,numTrials+1);
avgWeightE1toI2 = zeros(1,numTrials+1);
avgWeightE2toI1 = zeros(1,numTrials+1);
avgWeightXEtoE = zeros(1,numTrials+1);
avgWeightXEtoI = zeros(1,numTrials+1);
avgWeightXExc = zeros(1,numTrials+1);
avgWeightI1toE2 = zeros(1,numTrials+1);
avgWeightI2toE1 = zeros(1,numTrials+1);
avgWeightXItoE = zeros(1,numTrials+1);
avgWeightItoE1 = zeros(1,numTrials+1);
avgWeightItoE2 = zeros(1,numTrials+1);
avgWeightItoE = zeros(1,numTrials+1);
avgWeightINtoCortex1 = zeros(1,numTrials+1);
avgWeightINtoCortex2 = zeros(1,numTrials+1);
avgWeightLGNtoCortexEE1 = zeros(1,numTrials+1);
avgWeightLGNtoCortexEE2 = zeros(1,numTrials+1);
avgWeightLGNtoCortexEI1 = zeros(1,numTrials+1);
avgWeightLGNtoCortexIE1 = zeros(1,numTrials+1);
avgWeightLGNtoCortexIE2 = zeros(1,numTrials+1);
avgWeightLGNtoCortexII1 = zeros(1,numTrials+1);
avgWeightLGNtoGroup1 = zeros(numExcCellsLGN,numTrials+1);
avgWeightLGNtoGroup2 = zeros(numExcCellsLGN,numTrials+1);

%Triplet plasticity%
post_2 = zeros(numTotalCells,1);       % depends on postsynaptic spike for LTD
post_3 = zeros(numTotalCells,1);       % depends on prior postsynaptic spike for LTP
pre_2 = zeros(numTotalCells,1);        % depends on presynaptic spike for LTP