function [] = simulate(variablesFile) 
load(variablesFile);

for t = 2:trialLength %For loop containing calculations done at every timestep
    
    %reset values to initial within simulation%
    %Used for bi-directional training to reset variables before opposite
    %direction input% 
    
    if t == breakpoint %breakpoint should be halfway through trial between up and down inputs%
        Vm(:,t-1) = EL; %reset membrane potential of each cell to rest%
        s(:,t-1) = 0; %reset synaptic outputs of cortical cells%
        sLGN(:,t-1) = 0; %reset synaptic outputs of LGN cells%
    end
    
    %Synaptic output for each cell is transformed into a square matrix as
    %output is the same for each postsynaptic cell. Square output matrix is
    %then multiplied by synaptic weight matrix to account for connection
    %strength between pairs of neurons. Synaptic input is then summed
    %across each presynaptic cell to get total input current at a given
    %timestep%
    
    %Calculates total input current from LGN to each cortical cell%
    LGNcurrent(1:numCorticalCells, t-1) = (sum (w(numCorticalCells + 1:end -1,1:numCorticalCells)...
        .* ((sLGN(:,t-1) * ones(1,numCorticalCells)) .* (Vsynrev(numCorticalCells + 1:end-1)...
        * ones(1,numCorticalCells) - ones(numExcCellsLGN,1) * Vm(1:numCorticalCells,t-1)' ))))';

    %Calculates total input current from cortical cells to inhibitory IN%
    INcurrent(:,t-1) = w(end,:) .* ((s(end,t-1) * ones(1,numTotalCells)) .* (Vsynrev(end) * ones(1,numTotalCells) - Vm(:,t-1)' ));

    %Calculates total input current by summing cortical input and LGN input%
    totalSynCurrent(:,t-1) = (sum (w(:,:) .* ((s(:,t-1) * ones(1,numTotalCells)) .* (Vsynrev(:)...
        * ones(1,numTotalCells) - ones(numTotalCells,1) * Vm(:,t-1)' ))))' + LGNcurrent(:,t-1);
    
    %Calculates membrane potential for each cell at current timestep%
    %membrane potential decays towards resting potential according to
    %timeconstant, and is also affected by input currents including
    %synaptic inputs and externally applied currents%
    Vm([1:numCorticalCells end] ,t) = Vm([1:numCorticalCells end],t-1) + dt/Cm *( gL*(EL-Vm([1:numCorticalCells end],t-1)...
    + deltaT*exp((Vm([1:numCorticalCells end],t-1)-VThresh)/deltaT) ) ...
    + Iapp([1:numCorticalCells end],t-1) + totalSynCurrent([1:numCorticalCells end],t-1) - SRA([1:numCorticalCells end],t-1));

    %Calculates the Spike Rate Adaptation variable for each cell%
    %Spike rate adaptation causes diminished spiking with constant
    %activation%
    SRA(:,t) = SRA(:,t-1) + dt*( a*(Vm(:,t-1)-EL) - SRA(:,t-1) )/tauSRA; 

    %Calculates the decay in synaptic output for each cell based on
    %synaptic time constant%
    s(:,t) = s(:,t-1) - ((s(:,t-1)) * dt ./ tauSyn(:)); 
    
    %calculate decay in sLGN synaptic output unless the cell is currently
    %spiking%
    %for loop ensures predefined spike times of LGN cells are uneffected%
    for n = 1:length(sLGN(:,t))                                             %for each cell
        if sLGN(n,t) < sLGN(n,t-1)                                          %if sLGN did not increase due to spike 
            sLGN(n,t) = sLGN(n,t-1) - ((sLGN(n,t-1)) * dt / tauAMPA);       %allow sLGN to decay 
        end
    end
            
     sLGNtoIN(:,t) = sLGNtoIN(:,t - 1) - ((sLGNtoIN(:,t-1)) * dt / tauAMPA); %calculate decay in LGN synaptic output to inhibitory interneuron% 
     
     %Calculates postsynaptic and presynaptic decaying variables for triplet STDP%       
     if strcmp(STDPsetting,'Triplet Per-trial') || strcmp(STDPsetting,'Triplet Continous') 
        post_2(:,:) = post_2(:,:)*exp(-dt/tau_post_2); %decaying variable tracks time since last postsynaptic spike
        post_3(:,:) = post_3(:,:)*exp(-dt/tau_post_3); %decaying variable tracks time since second last postsynaptic spike for triplet calculation
        pre_2(:,:) = pre_2(:,:)*exp(-dt/tau_pre_2); %decaying variable tracks time since last presynaptic spike
     end
        
     %Adjust variables for LGN cells after spike%
     if strcmp(trainingCond,'LGN Bi-directional') || strcmp(trainingCond,'LGN Uni-directional') %If training condition involves simulated LGN input
         for n = 1:numExcCellsLGN %For each LGN cell
            if any (spikeTime(n+numCorticalCells,1:4) == t) %If a given LGN cell is currently above threshold
                 sLGN(n,t) = sLGN(n,t) + Delta_s * (1-sLGN(n,t)); %Increase synaptic gating variable (Simulate release of synaptic vesicles)
                 sLGNtoIN(n,t) = sLGNtoIN(n,t) + Delta_s * (1-sLGNtoIN(n,t)); %Repeat for synaptic gating variable to interneuron
                 
                  if ((strcmp(STDPsetting,'Triplet Per-trial') || strcmp(STDPsetting,'Triplet Continous')) && trainingLGN == true) %If plasticity in LGN is on
                      
                      deltaWTotal(n+numCorticalCells,1:numCorticalCells) = deltaWTotal(n+numCorticalCells,1:numCorticalCells)...
                          - (10 * dW_stdpm * (post_2(1:numCorticalCells)')); %Calculate synaptic depression from LGN to cortex and add to deltaWtotal
                      
                      %Reset pre and postsynaptic gating variables for each
                      %LGN cell that spikes%
                      post_3(n + numCorticalCells) = 1;
                      post_2(n+ numCorticalCells) = 1;
                      pre_2(n+ numCorticalCells) = 1;
                  end
            end
         end
     end     
    
     
     %Adjusts variables for cortical cells following a spike%
     for n = 1: numTotalCells %For every cell 
         
        if Vm(n,t) > Vmax %If a particular cell is currently spiking
                
            Vm(n,t) = VReset; %Reset membrane potential to VReset 
            %SRA(n,t) = SRA(n,t) + b; %Adjust spike rate adaptation
            s(n,t) = s(n,t) + Delta_s * (1-s(n,t)); %Adjust synaptic gating variable
            spikeCount(n) = spikeCount(n) + 1; %Increase spikecount by 1 for current cell
            spikeTrain(n,t) = 1; %Adjust spikeTrain to show spike at time t for current cell
            spikeTime(n,spikeCount(n)) = t; %Save time of spike (t) in spikeTime array

            %Modified Triplet STDP code to add weight changes at end of
            %trial%
            if trialCounter <= numTrainingTrials %If current trial is training trial 
                if strcmp(STDPsetting,'Triplet Per-trial') %If using triplet per-trial plasticity rules
                    deltaW = tripletSTDP(n,pre_2,post_2,post_3,numCorticalCells,numTotalCells,trainingCortex,trainingLGN,numExcCellsCortex,dW_stdpp_2,dW_stdpp_3,dW_stdpm,numExcCellsLGN);
                    
                    %Adjust synaptic decaying variables for each cell after
                    %spike%
                    post_2(n) = 1;
                    post_3(n) = 1;
                    pre_2(n) = 1;
                            
                end
                
                deltaWTotal(:,:) = deltaWTotal(:,:) + deltaW(:,:); %Add synaptic change at current timestep to total synaptic change for trial     
            end
          
        end
     end
    
    
    
    
end

save variables.mat;
end
    

  
    
          