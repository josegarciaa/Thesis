load('settings');

%Weight Matrix initial Parameters%
if strcmp(ColumnSetupCortex,'No Connections')   
    weightEEinCortexGroup = 0;%1;%.35;%1;%2;%2;%.2;%2;%1;          %Initial weight of EE connections within group
    weightEIinCortexGroup = 0;%1.5;%3;%3;%.20;%.35;%.22;%.35      %Initial weight of EI connections within group
    weightIEinCortexGroup = 0;%7.5;%15;%15;%20;%.95;%.68;%.75      %Initial weight of IE connections within group
    weightIIinCortexGroup = 0;% 1.5;%3;%3;%.55;            %Initial weight of II connections within group
end

if strcmp(ColumnSetupCortex,'Recurrent')   
    weightEEinCortexGroup = .025; %Initial weight of EE connections within group
    weightEIinCortexGroup = 0.025; %Initial weight of EI connections within group
    weightIEinCortexGroup = 0; %Initial weight of IE connections within group
    weightIIinCortexGroup = 0; %Initial weight of II connections within group
end

if strcmp(ColumnSetupCortex,'Stronger Recurrent')    
    weightEEinCortexGroup = .05; %Initial weight of EE connections within group
    weightEIinCortexGroup = .05; %Initial weight of EI connections within group
    weightIEinCortexGroup = 0; %Initial weight of IE connections within group
    weightIIinCortexGroup = 0; %Initial weight of II connections within group
end

if strcmp(ColumnSetupCortex,'Inhibition Stabilized')   
    weightEEinCortexGroup = .08; %Initial weight of EE connections within group
    weightEIinCortexGroup = .06; %Initial weight of EI connections within group
    weightIEinCortexGroup = 2; %Initial weight of IE connections within group
    weightIIinCortexGroup = 0; %Initial weight of II connections within group
end
  
if strcmp(crossColumnSettingCortex,'No Connections') 
    weightEEoutCortexGroup = 0; %Initial weight of EE connections between groups
    weightEIoutCortexGroup = 0; %Initial weight of EI connections between groups
    weightIEoutCortexGroup = 0; %Initial weight of IE connections between groups
    weightIIoutCortexGroup = 0; %Initial weight of II connections between groups
end

if strcmp(crossColumnSettingCortex,'EE') 
    weightEEoutCortexGroup = .02; %Initial weight of EE connections between groups
    weightEIoutCortexGroup = 0; %Initial weight of EI connections between groups
    weightIEoutCortexGroup = 0; %Initial weight of IE connections between groups
    weightIIoutCortexGroup = 0; %Initial weight of II connections between groups
end

if strcmp(crossColumnSettingCortex,'EI') 
    weightEEoutCortexGroup = 0; %Initial weight of EE connections between groups
    weightEIoutCortexGroup = .15; %Initial weight of EI connections between groups
    weightIEoutCortexGroup = 0; %Initial weight of IE connections between groups
    weightIIoutCortexGroup = 0; %Initial weight of II connections between groups
end

if strcmp(ColumnSetupLGN,'Recurrent')  
    weightEEinLGNGroup =0; %Initial weight of EE connections within group
    weightEIinLGNGroup =0; %Initial weight of EI connections within group
    weightIEinLGNGroup = 0; %Initial weight of IE connections within group
    weightIIinLGNGroup = 0; %Initial weight of II connections within group
end

if strcmp(LGNtoCortexSetup,'Feedforward to Exc')    
    weightLGNtoIN = 8.5; 
    weightINtoCortex = .01;
    group1Bias = 1.5; 
    group2Bias = 1.5; 
    weightLGNtoCortexBase = 1; 
end

 OriginalweightEEinCortexGroup = weightEEinCortexGroup; 
 OriginalweightEEoutCortexGroup = weightEEoutCortexGroup;
 OriginalweightEIinCortexGroup = weightEIinCortexGroup;
 OriginalweightEIoutCortexGroup = weightEIoutCortexGroup;
 OriginalweightIEinCortexGroup = weightIEinCortexGroup;
 OriginalweightIEoutCortexGroup = weightIEoutCortexGroup;
 OriginalweightIIinCortexGroup = weightIIinCortexGroup;
 OriginalweightIIoutGroup = weightIIoutCortexGroup;
 OriginalweightLGNtoCortex = weightLGNtoCortexBase;
 
 save('initWeightVal');
