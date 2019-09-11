function [] = plasticityFigures(variablesFile) 
load(variablesFile);

figure;
hold on;

stepSize = .01;
histBins = -1:stepSize:1;
histDist = hist(DSIVector(1:excCellsInCorticalGroup,end), histBins); 
normDist = histDist / sum(histDist) * 100;
cumDist = cumsum(normDist);
hold on;

%Figure showing DSI distribution after training%
subplot(3,2,6);
plot(histBins, cumDist, 'LineWidth', 3);
axis([-1 1 0 100]);
xlabel('DSI');
ylabel('Cumulative Percentage');
title('DSI Distribution After Training');


stepSize = .01;
histBins = -1:stepSize:1;
histDist = hist(DSIVector(1:excCellsInCorticalGroup,1), histBins); 
normDist = histDist / sum(histDist) * 100;
cumDist = cumsum(normDist);
hold on;

%Figure showing DSI distribution before training%
subplot(3,2,4);
plot(histBins, cumDist, 'LineWidth', 3);
axis([-1 1 0 100]);
xlabel('DSI');
ylabel('Cumulative Percentage');
title('DSI Distribution Before Training');

%Figure showing change in cortical connection strength throughout training%
subplot(3,2,1);
hold on;
plot(0:numTrials,avgWeightEtoE1(1,:),'r-', 'LineWidth', 3);
plot(0:numTrials,avgWeightE1toE2(1,:),'r--', 'LineWidth', 3);
legend('Average within-column EE connections','Average cross-column EE connections');

if strcmp(ColumnSetupCortex,'Inhibition Stabilized') 
    plot(0:numTrials,avgWeightEtoI1(1,:),'b-', 'LineWidth', 3);
    plot(0:numTrials,avgWeightE1toI2(1,:),'b--', 'LineWidth', 3);
    legend('Average within-column EE connections','Average cross-column EE connections','Average within-column EI connections','Average cross-column EI connections');
end
title('Change in cortical connections');
xlabel('Trial Number');
ylabel('Avg Strength of Connections');

%Figure showing change in LGN to cortex connection strength throughout training%
if trainingLGN == true
    subplot(3,2,2);
    hold on;
    plot(0:numTrials,mean(avgWeightLGNtoGroup1([1,4],:)),'-','Color',[.9 0 .9] , 'LineWidth', 3);
    plot(0:numTrials,mean(avgWeightLGNtoGroup1([2,3],:)),'--','Color',[.9 .9 0] , 'LineWidth', 3);
    plot(0:numTrials,mean(avgWeightLGNtoGroup2([1,4],:)),'--','Color',[.9 0 .9] , 'LineWidth', 3);
    plot(0:numTrials,mean(avgWeightLGNtoGroup2([2,3],:)),'-','Color',[.9 .9 0] , 'LineWidth', 3);
    title('Change in LGN to cortex connections');
    xlabel('Trial Number');
    ylabel('Avg Strength of Connections');
    legend('Down LGN inputs to group 1','Up LGN inputs to group 1','Down LGN inputs to group 2', 'Up LGN inputs to group 2');
end

%Figure showing changes in Firing rates for cortical cells throughout training%
subplot(3,2,3);
hold on;
plot(1:numTrials,AvgFRPrefferedExcCortexMatrixGroup1(1,:),'r-', 'LineWidth', 3);
plot(1:numTrials,AvgFRNullExcCortexMatrixGroup1(1,:),'r--', 'LineWidth', 3);
xlabel('Trial Number');
ylabel('Average Firing Rate');
legend('Avg Exc FR Preferred','Avg Exc FR Null');

if strcmp(ColumnSetupCortex,'Inhibition Stabilized') 
    plot(1:numTrials,AvgFRPrefferedInhCortexMatrixGroup1(1,:),'b-', 'LineWidth', 3);
    plot(1:numTrials,AvgFRNullInhCortexMatrixGroup1(1,:),'b--', 'LineWidth', 3);
    legend('Avg Exc FR Preferred','Avg Exc FR Null', 'Avg Inh FR Preferred','Avg Inh FR Null');
end



%Figure showing change in DSI with training%
subplot(3,2,5);
hold on;
plot(1:numTrials,DSIMatrixGroup1(1,:),'r-', 'LineWidth', 3);
plot(1:numTrials,DSIMatrixGroup2(1,:),'r--', 'LineWidth', 3);
xlabel('Trial Number');
ylabel('DSI');
legend('Avg DSI Group 1','Avg DSI Group 2');

%suptitle('Inhibition-stabilized columns, Cross-column STDP');
end