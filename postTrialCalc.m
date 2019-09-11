function [] = postTrialCalc(variablesFile) 
load(variablesFile);

w(:,:) = w(:,:) + deltaWTotal(:,:); %Adjust w matrix at end of trial

%Calculate change in synaptic weights from LTPi if turned on%
if strcmp(inhibLTPCondition,'On') %If LTPi is on
   w = LTPi(w,Vm,spikeTime,spikeCount,'constants');
end

if strcmp(POSDLTPiCondition,'On') %If POSDLTPi condition is on
   w = POSDLTPi(w,spikeTrain,'constants');
end

%For loop checks that no synapse goes above max or below min value at end of trial
for ji = 1:numTotalCells-1 %For each post-synaptic cell
    for i = 1:numTotalCells-1 %For each pre-synaptic cell
        if w(i,ji) > wMaxTotal %if current synapse is above Wmax
            w(i,ji) = wMaxTotal; %set synapse equal to Wmax
        end
        if w(i,ji) < 0 %If synaptic strength is below 0 
            w(i,ji) = 0; %Set to 0 
        end
    end
end

%Calculate average firing rate for preferred and null stimulus for each
%cortical cell%
AvgFRPrefferedCortex(1:excCellsInCorticalGroup,trialCounter) = sum(spikeTrain(1:excCellsInCorticalGroup,2501:7500),2) * 2;
AvgFRPrefferedCortex(numExcCellsCortex + 1:numExcCellsCortex + inhCellsInCorticalGroup,trialCounter) = sum(spikeTrain(numExcCellsCortex + 1:numExcCellsCortex + inhCellsInCorticalGroup,2501:7500),2) * 2;

AvgFRNullCortex(1:excCellsInCorticalGroup,trialCounter) = sum(spikeTrain(1:excCellsInCorticalGroup,10001:15000),2) * 2;
AvgFRNullCortex(numExcCellsCortex + 1:numExcCellsCortex + inhCellsInCorticalGroup,trialCounter) = sum(spikeTrain(numExcCellsCortex + 1:numExcCellsCortex + inhCellsInCorticalGroup,10001:15000),2) * 2;

AvgFRPrefferedCortex(excCellsInCorticalGroup + 1:numExcCellsCortex, trialCounter) = sum(spikeTrain(excCellsInCorticalGroup + 1:numExcCellsCortex,10001:15000),2) * 2;
AvgFRPrefferedCortex(numExcCellsCortex + inhCellsInCorticalGroup + 1:numCorticalCells, trialCounter) = sum(spikeTrain(numExcCellsCortex + inhCellsInCorticalGroup + 1:numCorticalCells,10001:15000),2) * 2;

AvgFRNullCortex(excCellsInCorticalGroup + 1:numExcCellsCortex,trialCounter) = sum(spikeTrain(excCellsInCorticalGroup + 1:numExcCellsCortex,2501:7500),2) * 2;
AvgFRNullCortex(numExcCellsCortex + inhCellsInCorticalGroup + 1:numCorticalCells,trialCounter) = sum(spikeTrain(numExcCellsCortex + inhCellsInCorticalGroup + 1:numCorticalCells,2501:7500),2) * 2; 

AvgFRPrefferedExcCortexMatrixGroup1(outerTrialCount,trialCounter) = mean(AvgFRPrefferedCortex(1:excCellsInCorticalGroup,trialCounter));
AvgFRNullExcCortexMatrixGroup1(outerTrialCount,trialCounter) = mean(AvgFRNullCortex(1:excCellsInCorticalGroup,trialCounter));
AvgFRPrefferedInhCortexMatrixGroup1(outerTrialCount,trialCounter) = mean(AvgFRPrefferedCortex(numExcCellsCortex+1:numExcCellsCortex + inhCellsInCorticalGroup,trialCounter));
AvgFRNullInhCortexMatrixGroup1(outerTrialCount,trialCounter) = mean(AvgFRNullCortex(numExcCellsCortex+1:numExcCellsCortex + inhCellsInCorticalGroup,trialCounter));

AvgFRPrefferedExcCortexMatrixGroup2(outerTrialCount,trialCounter) = mean(AvgFRPrefferedCortex(excCellsInCorticalGroup+1:numExcCellsCortex,trialCounter));
AvgFRNullExcCortexMatrixGroup2(outerTrialCount,trialCounter) = mean(AvgFRNullCortex(excCellsInCorticalGroup+1:numExcCellsCortex,trialCounter));
AvgFRPrefferedInhCortexMatrixGroup2(outerTrialCount,trialCounter) = mean(AvgFRPrefferedCortex(numExcCellsCortex+inhCellsInCorticalGroup +1:numCorticalCells, trialCounter));
AvgFRNullInhCortexMatrixGroup2(outerTrialCount,trialCounter) = mean(AvgFRNullCortex(numExcCellsCortex+inhCellsInCorticalGroup + 1:numCorticalCells,trialCounter));

%Calculate avg synaptic weight values at end of every trial%
avgWeightEtoE1(trialCounter+1) =  mean(mean(w(1:excCellsInCorticalGroup,1:excCellsInCorticalGroup),1),2);
avgWeightEtoE2(trialCounter+1) = mean(mean(w(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,excCellsInCorticalGroup+1:excCellsInCorticalGroup*2),1),2);
avgWeightEtoE(trialCounter+1) =  (avgWeightEtoE1(trialCounter+1) + avgWeightEtoE2(trialCounter+1)) / 2; 

avgWeightEtoI1(trialCounter+1) = mean(mean(w(1:excCellsInCorticalGroup,numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup),1),2);
avgWeightEtoI2(trialCounter+1) = mean(mean(w(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells),1),2);

avgWeightItoE1(trialCounter+1) = mean(mean(w(numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup,1:excCellsInCorticalGroup),1),2);
avgWeightItoE2(trialCounter+1) =  mean(mean(w(numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells,excCellsInCorticalGroup+1:excCellsInCorticalGroup*2),1),2);
avgWeightItoE(trialCounter+1) = (avgWeightItoE1(trialCounter+1) +  avgWeightItoE2(trialCounter+1)) / 2;

avgWeightI1toE2(trialCounter+1) = mean(mean(w(numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup,excCellsInCorticalGroup+1:excCellsInCorticalGroup*2),1),2);
avgWeightI2toE1(trialCounter+1) = mean(mean(w(numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells,1:excCellsInCorticalGroup),1),2);
avgWeightXItoE(trialCounter+1) = (avgWeightI1toE2(trialCounter+1) + avgWeightI2toE1(trialCounter+1)) / 2; 

avgWeightE1toE2(trialCounter+1) = mean(mean(w(1:excCellsInCorticalGroup,excCellsInCorticalGroup+1:excCellsInCorticalGroup*2),1),2);
avgWeightE2toE1(trialCounter+1) = mean(mean(w(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,1:excCellsInCorticalGroup),1),2);
avgWeightE1toI2(trialCounter+1) = mean(mean(w(1:excCellsInCorticalGroup,numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells),1),2);
avgWeightE2toI1(trialCounter+1) = mean(mean(w(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup),1),2);
avgWeightXEtoE(trialCounter+1) = (avgWeightE1toE2(trialCounter+1) * excCellsInCorticalGroup + avgWeightE2toE1(trialCounter+1) * excCellsInCorticalGroup) / numExcCellsCortex;
avgWeightXEtoI(trialCounter+1) = (avgWeightE1toI2(trialCounter+1) * inhCellsInCorticalGroup + avgWeightE2toI1(trialCounter+1) * inhCellsInCorticalGroup) / numInhCellsCortex;
avgWeightXExc(trialCounter+1) = (avgWeightE1toE2(trialCounter+1) * numExcCellsCortex + avgWeightE2toE1(trialCounter+1) * numExcCellsCortex + ...
avgWeightE1toI2(trialCounter+1) * numInhCellsCortex + avgWeightE2toI1(trialCounter+1) * numInhCellsCortex) / numCorticalCells;

avgWeightLGNtoCortexEE1(trialCounter+1) = mean(mean(w(numCorticalCells+1:numCorticalCells+numExcCellsLGN,1:excCellsInCorticalGroup),1),2);
avgWeightLGNtoCortexEE2(trialCounter+1) = mean(mean(w(numCorticalCells+1:numCorticalCells+numExcCellsLGN,excCellsInCorticalGroup + 1:excCellsInCorticalGroup * 2),1),2);

avgWeightLGNtoGroup1(:,trialCounter+1) = mean(w(numCorticalCells+1:numCorticalCells+numExcCellsLGN,1:excCellsInCorticalGroup), 2);
avgWeightLGNtoGroup2(:,trialCounter+1) = mean(w(numCorticalCells+1:numCorticalCells+numExcCellsLGN,excCellsInCorticalGroup+1:numExcCellsCortex), 2);    

avgWeightINtoCortex1(trialCounter+1) = mean(w(end,1:excCellsInCorticalGroup));
avgWeightINtoCortex2(trialCounter+1) = mean(w(end,excCellsInCorticalGroup + 1:numExcCellsCortex));

%Calculate DSI values at the end of each trial%
DSIVector(:,trialCounter) = (AvgFRPrefferedCortex(:,trialCounter) - AvgFRNullCortex(:,trialCounter)) ...
    ./ (AvgFRPrefferedCortex(:,trialCounter) + AvgFRNullCortex(:,trialCounter));
DSIVector(isnan(DSIVector)) = 0;

DSIexcGroup1(outerTrialCount,trialCounter) = mean(DSIVector(1:excCellsInCorticalGroup,trialCounter));
DSIexcGroup2(outerTrialCount,trialCounter) = mean(DSIVector(excCellsInCorticalGroup + 1:numExcCellsCortex,trialCounter));

DSIMatrixGroup1(outerTrialCount,trialCounter) = DSIexcGroup1(outerTrialCount, trialCounter);
DSIMatrixGroup2(outerTrialCount,trialCounter) = DSIexcGroup2(outerTrialCount, trialCounter);

%Calculate average strength of LGN input to cortical groups%
avgLGNtoCortexInputPrefGroup1(trialCounter) = mean(mean(LGNcurrent(1:excCellsInCorticalGroup,2501:7500),2));
avgLGNtoCortexInputPrefGroup2(trialCounter) = mean(mean(LGNcurrent(excCellsInCorticalGroup + 1:numExcCellsCortex,10001:end),2));
avgLGNtoCortexInputNullGroup1(trialCounter) = mean(mean(LGNcurrent(1:excCellsInCorticalGroup,10001:end),2));
avgLGNtoCortexInputNullGroup2(trialCounter) = mean(mean(LGNcurrent(excCellsInCorticalGroup + 1:numExcCellsCortex,2501:7500),2));

save variables.mat; %Update variables .mat file
end