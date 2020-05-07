function currentFileName = getMintsFileNameTraining(folder,nodeIDs,nodeIndex,...
                                                            target,stringIn)
        nodeDataFolder      = folder+ "/"+nodeIDs(nodeIndex);
        currentFileName     = nodeDataFolder+"/"+stringIn + "_" +...
                                    nodeIDs(nodeIndex)+ "_" + ...
                                          target +"_"+...
                                              ".mat";
                                          
    if ~exist(fileparts(currentFileName), 'dir')
       mkdir(fileparts(currentFileName));
    end
end