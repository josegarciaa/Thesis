function [] = setupTrial(variablesFile,trialCounter) 
load(variablesFile);

%Reset variables at start of trial%
spikeCount(:) = 0; 
spikeTrain(:,:) = 0;
spikeTime(:,:) = 0;
binCount = 1;
extraCurrentVectPref(:) = onBiasCurrent;
extraCurrentVectNull(:) = offBiasCurrent;
sineCurrentPref = extraCurrentVectPref .* sineWave(1:5000);
sineCurrentNull = extraCurrentVectNull .* sineWave(1:5000);
deltaWLTP(:,:) = 0;
deltaWLTD(:,:) = 0;
deltaWLTDtotal(:,:) = 0;
deltaWLTPtotal(:,:) = 0;
deltaW(:,:) = 0;
deltaWTotal(:,:) = 0;
Vm(:,1) = EL;
s(:,1) = 0;    
sLGN(:,:) = 0;
sLGNtoIN(:,:) = 0;
post_2(:,:) = 0;       % depends on postsynaptic spike for LTD
post_3(:,:) = 0;       % depends on prior postsynaptic spike for LTP
pre_2(:,:) = 0;        % depends on presynaptic spike for LTP

%Generate new noisy current for each trial%
Iapp(1:numCorticalCells,1:trialLength) = (rand(numCorticalCells,trialLength) - .4) .* noiseCurrent;
Iapp(numCorticalCells+1:numTotalCells,:) = 0; %Ensure LGN cells do not receive input current

%Determine if testing or training trial%
if trialCounter > numTrainingTrials
    trainingCond = testingCond; 
end

%Setup input currents for cortical cells before each trial%
if strcmp(trainingCond,'Bi-directional Square')    
%Set up square input current%
    Iapp(1:excCellsInCorticalGroup,2501:7500) = Iapp(1:excCellsInCorticalGroup,2501:7500) + (ones(excCellsInCorticalGroup,1) * extraCurrentVectPref); %Add on-bias current group 1 exc cells
    Iapp(1:excCellsInCorticalGroup,10001:15000) = Iapp(1:excCellsInCorticalGroup,10001:15000) + (ones(excCellsInCorticalGroup,1) * extraCurrentVectNull); %Add off-bias current group 1 exc cells
    Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,2501:7500) = Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,2501:7500) + (ones(inhCellsInCorticalGroup,1) * extraCurrentVectPref); %Add on-bias current group 1 inhib cells
    Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,10001:15000) = Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,10001:15000) + (ones(inhCellsInCorticalGroup,1) * extraCurrentVectNull); %Add off-bias current group 1 inhib cells

    if numCorticalGroups == 2
        Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,2501:7500) = Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,2501:7500) + (ones(excCellsInCorticalGroup,1) * extraCurrentVectNull); %Add off-bias current to group 2 exc cells
        Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,10001:15000) = Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,10001:15000) + (ones(excCellsInCorticalGroup,1) * extraCurrentVectPref); %Add on-bias current to group 2 exc cells
        Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,2501:7500) = Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,2501:7500) + (ones(inhCellsInCorticalGroup,1) * extraCurrentVectNull); %Add off-bias current to group 2 inhib cells
        Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,10001:15000) = Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,10001:15000) + (ones(inhCellsInCorticalGroup,1) * extraCurrentVectPref); %Add on-bias current to group 2 inhib cells
    end
end

if strcmp(trainingCond,'Bi-directional Sine')    
    %Set up sine input current%
    Iapp(1:excCellsInCorticalGroup,2501:7500) = Iapp(1:excCellsInCorticalGroup,2501:7500) + (ones(excCellsInCorticalGroup,1) * sineCurrentPref); %Add on-bias current group 1 exc cells
    Iapp(1:excCellsInCorticalGroup,10001:15000) = Iapp(1:excCellsInCorticalGroup,10001:15000) + (ones(excCellsInCorticalGroup,1) * sineCurrentNull); %Add off-bias current group 1 exc cells
    Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,2501:7500) = Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,2501:7500) + (ones(inhCellsInCorticalGroup,1) * sineCurrentPref); %Add on-bias current group 1 inhib cells
    Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,10001:15000) = Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,10001:15000) + (ones(inhCellsInCorticalGroup,1) * sineCurrentNull); %Add off-bias current group 1 inhib cells

    if numCorticalGroups == 2
        Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,2501:7500) = Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,2501:7500) + (ones(excCellsInCorticalGroup,1) * sineCurrentNull); %Add off-bias current to group 2 exc cells
        Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,10001:15000) = Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,10001:15000) + (ones(excCellsInCorticalGroup,1) * sineCurrentPref); %Add on-bias current to group 2 exc cells
        Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,2501:7500) = Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,2501:7500) + (ones(inhCellsInCorticalGroup,1) * sineCurrentNull); %Add off-bias current to group 2 inhib cells
        Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,10001:15000) = Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,10001:15000) + (ones(inhCellsInCorticalGroup,1) * sineCurrentPref); %Add on-bias current to group 2 inhib cells
    end
end

if strcmp(trainingCond,'Constant Current')    
    %Set up constant current%
    Iapp(1:excCellsInCorticalGroup,2501:7500) = Iapp(1:excCellsInCorticalGroup,2501:7500) + (ones(excCellsInCorticalGroup,1) * extraCurrentVectPref); %Add on-bias current group 1 exc cells
    Iapp(1:excCellsInCorticalGroup,10001:15000) = Iapp(1:excCellsInCorticalGroup,10001:15000) + (ones(excCellsInCorticalGroup,1) * extraCurrentVectPref); %Add off-bias current group 1 exc cells
    Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,2501:7500) = Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,2501:7500) + (ones(inhCellsInCorticalGroup,1) * extraCurrentVectPref); %Add on-bias current group 1 inhib cells
    Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,10001:15000) = Iapp(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,10001:15000) + (ones(inhCellsInCorticalGroup,1) * extraCurrentVectPref); %Add off-bias current group 1 inhib cells

    if numCorticalGroups == 2
        Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,2501:7500) = Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,2501:7500) + (ones(excCellsInCorticalGroup,1) * extraCurrentVectPref); %Add off-bias current to group 2 exc cells
        Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,10001:15000) = Iapp(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,10001:15000) + (ones(excCellsInCorticalGroup,1) * extraCurrentVectPref); %Add on-bias current to group 2 exc cells
        Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,2501:7500) = Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,2501:7500) + (ones(inhCellsInCorticalGroup,1) * extraCurrentVectPref); %Add off-bias current to group 2 inhib cells
        Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,10001:15000) = Iapp(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,10001:15000) + (ones(inhCellsInCorticalGroup,1) * extraCurrentVectPref); %Add on-bias current to group 2 inhib cells
    end
end

if strcmp(trainingCond,'LGN Bi-directional')
    %Setup predefined LGN spikes for bi-directional trials%
    spikeTime(numCorticalCells + 1:numCorticalCells + excCellsInLGNGroup, 1:2) = ...
        ones(excCellsInLGNGroup,1) * [2501 5001] + (0:lagSize:lagSize*(excCellsInLGNGroup-1))' * ones(1,2);
    spikeTime(numCorticalCells + 1:numCorticalCells + excCellsInLGNGroup, 3:4) = ...
        ones(excCellsInLGNGroup,1) * [10001 12501] + flipud((0:lagSize:lagSize*(excCellsInLGNGroup-1))') * ones(1,2);
    spikeTime(numCorticalCells + excCellsInLGNGroup + 1:end - 1, 1:4) = spikeTime(numCorticalCells + 1:numCorticalCells + excCellsInLGNGroup, 1:4) + lagSize;
end 

if strcmp(trainingCond,'LGN Uni-directional')  
    %Setup predefined LGN spikes for uni-directional trials%
    spikeTime(numCorticalCells + 1:numCorticalCells + excCellsInLGNGroup,1:4) = ...
        ones(excCellsInLGNGroup,1) * [2501 5001 10001 12501] + (0:lagSize:lagSize*(excCellsInLGNGroup-1))' * ones(1,4);
    spikeTime(numCorticalCells + excCellsInLGNGroup + 1:end - 1, 1:4) = spikeTime(numCorticalCells + 1:numCorticalCells + excCellsInLGNGroup, 1:4) + lagSize;
end

save variables.mat;
end