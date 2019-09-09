function [w] = LTPi(w,Vm,spikeTime,spikeCount,constantsFile) 
load(constantsFile,'numCorticalCells','numExcCellsCortex','dt','ampLTPi');

%Calculates LTPi based on veto rule% 
for i=numExcCellsCortex+1:numCorticalCells %Parallel for loop across each inhibitory presynaptic cortical cell
    for j =1:numExcCellsCortex %Loop across each excitatory postsynaptic cortical cell
        for n = 1:spikeCount(i) %Loop across each spike for current presynaptic cell
            if any(abs(spikeTime(j,1:spikeCount(j)) -spikeTime(i,n)) < 20/dt) %If any postSynaptic spike is within 20 ms of preSyn spike
                continue; %Veto LTPi for current spike 
            else
                if Vm(j, spikeTime(i,n)) <= -55 && Vm(j, spikeTime(i,n)) >= -60 %If postSynaptic membrane potential is -60 or below at time of inhibitory spike 
                    w(i,j) = w(i,j) + ampLTPi; %Strengthen inhibitory synapse 
                end
            end
        end
    end
end 

end
