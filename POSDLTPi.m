function [w] = POSDLTPi(w,spikeTrain,constantsFile) 
load(constantsFile,'numCorticalCells','POSDLTPiAmp');

%Calculates POSDLTPi based exclusively on postsynaptic activity%  
for n = 1:numCorticalCells %Loop for each cortical cell 
    if any(spikeTrain(n,2501:8000) == 1) %If a cell spikes at any point during first half of trial 
        w(end,n) = w(end,n) * POSDLTPiAmp; %Potentiate inhibitory synapses
    end

    if any(spikeTrain(n,10000:end) == 1) %If a cell spikes at any point during second half of trial 
        w(end,n) = w(end,n) * POSDLTPiAmp; %Potentiate inhibitory synapses again
    end
end

end