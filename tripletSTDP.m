function [deltaW] = tripletSTDP(n,pre_2,post_2,post_3,numCorticalCells,numTotalCells,trainingCortex,trainingLGN,numExcCellsCortex,dW_stdpp_2,dW_stdpp_3,dW_stdpm,numExcCellsLGN)

if n <= numCorticalCells %repeat only for cortical cells
    deltaW = zeros(numTotalCells,numTotalCells); %Reset deltaW after each timeStep  

    if trainingCortex == true %If cortical plasticity is on
        %Calculate synaptic potentiation between 
        %cortical cells after postsynaptic spike%
        deltaW(1:numExcCellsCortex,n) = deltaW(1:numExcCellsCortex,n)+...
         (pre_2(1:numExcCellsCortex) * (dW_stdpp_2 + dW_stdpp_3 * post_3(n)'));

        %Calculate synaptic depression between cortical
        %cells after presynaptic spike%
        deltaW(n,1:numCorticalCells) = deltaW(n,1:numCorticalCells) - dW_stdpm * (post_2(1:numCorticalCells)');
    end

    if trainingLGN == true %If LGN --> Cortex plasticity is on
        %Calculate synaptic potentiation from LGN to
        %cortex after postsynaptic spike%
        deltaW(numCorticalCells+1:numCorticalCells+numExcCellsLGN,n) =  deltaW(numCorticalCells+1:numCorticalCells+numExcCellsLGN,n) + ...
            (pre_2(numCorticalCells+1:numCorticalCells+numExcCellsLGN) * (dW_stdpp_2 + dW_stdpp_3 * post_3(n)'));
    end              
end
                    
end
