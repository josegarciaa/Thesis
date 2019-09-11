%Initial Values Setup%
Vm(:,:) = EL; %Set initial value of Vm to reversal potential for all cells
Vsynrev(1:numExcCellsCortex) = Vexc; %Set the reversal potential of exc cells to correct value
Vsynrev(numCorticalCells+1:numCorticalCells+numExcCellsLGN) = Vexc; %Repeat for group 2
Vsynrev(numExcCellsCortex + 1:numCorticalCells) = Vinh; %Set the reversal potential of exc cells to correct value
Vsynrev(numCorticalCells+numExcCellsLGN+1:numTotalCells) = Vinh; %Repeat for group 2

tauSyn(1:numExcCellsCortex) = tauAMPA; %Set the time constant for exc synapses to correct value
tauSyn(numCorticalCells+1:numCorticalCells+numExcCellsLGN) = tauAMPA; %Repeat for group 2
tauSyn(numExcCellsCortex + 1:end) = tauGABA; %Set the time constant for inhib synapses to correct value
tauSyn(numCorticalCells+numExcCellsLGN+1:numTotalCells) = tauGABA; %Repeat for group 2

%STDP Parameters%
if strcmp(STDPAmplitude,'Small') 
    ampLTD = .0016;%.08;%.25;           %Amplitude of LTD
    ampLTP = .001;%.05;%.20;           %Amplitude of LTP
end

if strcmp(STDPAmplitude,'Large')
    ampLTD =  .0016; %.016;%.08;%.25;           %Amplitude of LTD
    ampLTP = .001; %.01;%.05;%.20;           %Amplitude of LTP
end


if strcmp(STDPAmplitude,'Large') && strcmp(ColumnSetupCortex,'Recurrent')  
    dW_stdpp_3 =  .001; %Maximum increase in strength for each triplet (S)
    dW_stdpp_2 =  .01; %Maximum increase in strength for each pairing (S)
    dW_stdpm =    .013; %Maximum decrease in strength for each pairing (S)
end

if strcmp(STDPAmplitude,'Small') && strcmp(ColumnSetupCortex,'Recurrent') 
    dW_stdpp_3 =  .0001; %Maximum increase in strength for each triplet (S)
    dW_stdpp_2 =  .001; %Maximum increase in strength for each pairing (S)
    dW_stdpm =    .0013; %Maximum decrease in strength for each pairing (S)
end

if strcmp(STDPAmplitude,'Large') && strcmp(ColumnSetupCortex,'Inhibition Stabilized')  
    dW_stdpp_3 =  .0005; %Maximum increase in strength for each triplet (S)
    dW_stdpp_2 =  .003; %Maximum increase in strength for each pairing (S)
    dW_stdpm =    .003; %Maximum decrease in strength for each pairing (S)
end

if strcmp(STDPAmplitude,'Small') && strcmp(ColumnSetupCortex,'Inhibition Stabilized')  
    dW_stdpp_3 =  .0005; %Maximum increase in strength for each triplet (S)
    dW_stdpp_2 =  .003; %Maximum increase in strength for each pairing (S)
    dW_stdpm =    .003; %Maximum decrease in strength for each pairing (S)
end

%Setup input current for trial%
extraCurrentVectPref(:) = onBiasCurrent;
extraCurrentVectNull(:) = offBiasCurrent;
sineWave = sin(1:1/(12*pi):(5000/(12*pi)+ 1)) +1 ;
sineCurrentPref = extraCurrentVectPref .* sineWave(1:5000);
sineCurrentNull = extraCurrentVectNull .* sineWave(1:5000);

inputCurrentVector(1:excCellsInCorticalGroup,2501:7500) = inputCurrentVector(1:excCellsInCorticalGroup,2501:7500) + ...
    (ones(excCellsInCorticalGroup,1) * sineCurrentPref); %Add on-bias current group 1 exc cells
inputCurrentVector(1:excCellsInCorticalGroup,10001:15000) = inputCurrentVector(1:excCellsInCorticalGroup,10001:15000) + ...
    (ones(excCellsInCorticalGroup,1) * sineCurrentNull); %Add off-bias current group 1 exc cells
inputCurrentVector(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,2501:7500) = inputCurrentVector(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,2501:7500) ...
    + (ones(inhCellsInCorticalGroup,1) * sineCurrentPref); %Add on-bias current group 1 inhib cells
inputCurrentVector(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,10001:15000) = inputCurrentVector(numExcCellsCortex +1:numExcCellsCortex +inhCellsInCorticalGroup,10001:15000)...
    + (ones(inhCellsInCorticalGroup,1) * sineCurrentNull); %Add off-bias current group 1 inhib cells

inputCurrentVector(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,2501:7500) = inputCurrentVector(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,2501:7500) +...
    (ones(excCellsInCorticalGroup,1) * sineCurrentNull); %Add off-bias current to group 2 exc cells
inputCurrentVector(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,10001:15000) = inputCurrentVector(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,10001:15000) +...
    (ones(excCellsInCorticalGroup,1) * sineCurrentPref); %Add on-bias current to group 2 exc cells
inputCurrentVector(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,2501:7500) = inputCurrentVector(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,2501:7500)...
    + (ones(inhCellsInCorticalGroup,1) * sineCurrentNull); %Add off-bias current to group 2 inhib cells
inputCurrentVector(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,10001:15000) = inputCurrentVector(numExcCellsCortex +inhCellsInCorticalGroup+1:numCorticalCells,10001:15000)...
    + (ones(inhCellsInCorticalGroup,1) * sineCurrentPref); %Add on-bias current to group 2 inhib cells

%Setup initial synaptic weight matrix values%
for groupCounter = 0:numCorticalGroups-1
    
    %Set up Variables 
    startExc = groupCounter*excCellsInCorticalGroup + 1;
    endExc = (groupCounter+1)*excCellsInCorticalGroup;
    prevExcCellsEnd = groupCounter*excCellsInCorticalGroup;
    nextExcCellStart = endExc + 1;
    startInhib = (numExcCellsCortex +1) + groupCounter * inhCellsInCorticalGroup;
    endInhib = numExcCellsCortex  + (groupCounter+1) * inhCellsInCorticalGroup;
    prevInhibCellStart = numExcCellsCortex + 1;
    prevInhibCellEnd = startInhib - 1; 
    nextInhibCellStart = endInhib + 1;
   
    %set up EE connections%
    w(startExc:endExc,startExc:endExc) = ones(size(w(startExc:endExc,startExc:endExc))) * 2 * weightEEinCortexGroup; %Set up initial EE weights within group
    w(startExc:endExc,1:prevExcCellsEnd) = ones(size(w(startExc:endExc,1:prevExcCellsEnd))) * 2 * weightEEoutCortexGroup; %Set up initial EE weights to previous groups
    w(startExc:endExc,nextExcCellStart:numExcCellsCortex) = ones(size(w(startExc:endExc,nextExcCellStart:numExcCellsCortex))) * 2 * weightEEoutCortexGroup; %Set up initiak EE weights to next groups 

    %set up EI connections%
    w(startExc:endExc,startInhib:endInhib) = ones(size(w(startExc:endExc,startInhib:endInhib))) * 2 * weightEIinCortexGroup; %Set up initial EI connections within group
    w(startExc:endExc,prevInhibCellStart:prevInhibCellEnd) = ones(size(w(startExc:endExc,prevInhibCellStart:prevInhibCellEnd))) * 2 * weightEIoutCortexGroup;%Set up initial EI connections to previous groups
    w(startExc:endExc,nextInhibCellStart:end) = ones(size(w(startExc:endExc,nextInhibCellStart:end))) * 2 * weightEIoutCortexGroup; %Set up initial EI connections to next groups
      
    %set up IE connections%
    w(startInhib:endInhib,startExc:endExc) = ones(size(w(startInhib:endInhib,startExc:endExc))) * 2 * weightIEinCortexGroup; %Set up initial IE connections within group
    w(startInhib:endInhib,1:prevExcCellsEnd) = ones(size(w(startInhib:endInhib,1:prevExcCellsEnd))) * 2 * weightIEoutCortexGroup; %Set up initial IE connections to previous groups
    w(startInhib:endInhib,nextExcCellStart:numExcCellsCortex) = ones(size(w(startInhib:endInhib,nextExcCellStart:numExcCellsCortex))) * 2 * weightIEoutCortexGroup;%Set up initial IE connections to previous groups
    
    %set up II connections%
    w(startInhib:endInhib,startInhib:endInhib) = ones(size(w(startInhib:endInhib,startInhib:endInhib))) * 2 * weightIIinCortexGroup; %Set up initial II connections within group
    w(startInhib:endInhib,prevInhibCellStart:prevInhibCellEnd) = ones(size(w(startInhib:endInhib,prevInhibCellStart:prevInhibCellEnd)))* 2 * weightIIoutCortexGroup; %Set up initial II connections to previous groups
    w(startInhib:endInhib,nextInhibCellStart:end) = ones(size(w(startInhib:endInhib,nextInhibCellStart:end))) * 2 * weightIIoutCortexGroup; %Set up initial II connections to previous groups

end

%Setup synaptic weights between LGN and cortex%
w(numCorticalCells+1:numCorticalCells+numExcCellsLGN,1:numCorticalCells) =  2 * weightLGNtoCortexBase; %Base strength of LGN input to cortex
w([102 103],[1:excCellsInCorticalGroup numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup]) =...
    w([102 103],[1:excCellsInCorticalGroup numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup]) + group1Bias; %Make synapses stronger from pref LGN input to group 1
w([101 104],[excCellsInCorticalGroup + 1:numExcCellsCortex numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells]) = ...
    w([101 104],[excCellsInCorticalGroup + 1:numExcCellsCortex numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells]) + group2Bias; %Make synapses stronger from pref LGN input to group 2
w(numCorticalCells+1:numCorticalCells+numExcCellsLGN, end) = 2 * weightLGNtoIN; %Initial strength of LGN input to inhibitory IN
w(end,1:numCorticalCells) = 2 * weightINtoCortex; %Initial strength of inhib IN to cortex

%Calculate starting average connection strength between various groups%
avgWeightEtoE1(1) =  mean(mean(w(1:excCellsInCorticalGroup,1:excCellsInCorticalGroup),1),2);
avgWeightEtoE2(1) = mean(mean(w(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,excCellsInCorticalGroup+1:excCellsInCorticalGroup*2),1),2);
avgWeightEtoE(1) =  (avgWeightEtoE1(1) + avgWeightEtoE2(1)) / 2; 

avgWeightEtoI1(1) = mean(mean(w(1:excCellsInCorticalGroup,numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup),1),2);
avgWeightEtoI2(1) = mean(mean(w(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells),1),2);

avgWeightItoE1(1) = mean(mean(w(numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup,1:excCellsInCorticalGroup),1),2);
avgWeightItoE2(1) =  mean(mean(w(numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells,excCellsInCorticalGroup+1:excCellsInCorticalGroup*2),1),2);
avgWeightItoE(1) = (avgWeightItoE1(1) +  avgWeightItoE2(1)) / 2;


avgWeightE1toE2(1) = mean(mean(w(1:excCellsInCorticalGroup,excCellsInCorticalGroup+1:excCellsInCorticalGroup*2),1),2);
avgWeightE2toE1(1) = mean(mean(w(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,1:excCellsInCorticalGroup),1),2);
avgWeightE1toI2(1) = mean(mean(w(1:excCellsInCorticalGroup,numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells),1),2);
avgWeightE2toI1(1) = mean(mean(w(excCellsInCorticalGroup+1:excCellsInCorticalGroup*2,numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup),1),2);
avgWeightXEtoE(1) = (avgWeightE1toE2(1) * excCellsInCorticalGroup + avgWeightE2toE1(1) * excCellsInCorticalGroup) / numExcCellsCortex;
avgWeightXEtoI(1) = (avgWeightE1toI2(1) * inhCellsInCorticalGroup + avgWeightE2toI1(1) * inhCellsInCorticalGroup) / numInhCellsCortex;
avgWeightXExc(1) = (avgWeightE1toE2(1) * excCellsInCorticalGroup + avgWeightE2toE1(1) * excCellsInCorticalGroup + ...
    avgWeightE1toI2(1) * inhCellsInCorticalGroup + avgWeightE2toI1(1) * inhCellsInCorticalGroup) / numCorticalCells;

avgWeightI1toE2(1) = mean(mean(w(numExcCellsCortex+1:numExcCellsCortex+inhCellsInCorticalGroup,excCellsInCorticalGroup+1:excCellsInCorticalGroup*2),1),2);
avgWeightI2toE1(1) = mean(mean(w(numExcCellsCortex+inhCellsInCorticalGroup+1:numCorticalCells,1:excCellsInCorticalGroup),1),2);
avgWeightXItoE(1) = (avgWeightI1toE2(1) + avgWeightI2toE1(1)) / 2; 

avgWeightLGNtoCortexEE1(1) = mean(mean(w(numCorticalCells+1:numCorticalCells+numExcCellsLGN,1:excCellsInCorticalGroup),1),2);
avgWeightLGNtoCortexEE2(1) = mean(mean(w(numCorticalCells+1:numCorticalCells+numExcCellsLGN,excCellsInCorticalGroup + 1:excCellsInCorticalGroup * 2),1),2);

avgWeightLGNtoCortexIE1(1) = mean(mean(w(numCorticalCells + numExcCellsLGN +1:numTotalCells,1:excCellsInCorticalGroup),1),2);
avgWeightLGNtoCortexIE2(1) = mean(mean(w(numCorticalCells + numExcCellsLGN +1:numTotalCells,excCellsInCorticalGroup + 1:excCellsInCorticalGroup * 2),1),2);

avgWeightLGNtoGroup1(:,1) = mean(w(numCorticalCells+1:numCorticalCells+numExcCellsLGN,1:excCellsInCorticalGroup), 2);
avgWeightLGNtoGroup2(:,1) = mean(w(numCorticalCells+1:numCorticalCells+numExcCellsLGN,excCellsInCorticalGroup+1:numExcCellsCortex), 2);

avgWeightINtoCortex1(1) = mean(w(end,1:excCellsInCorticalGroup));
avgWeightINtoCortex2(1) = mean(w(end,excCellsInCorticalGroup + 1:numExcCellsCortex));

