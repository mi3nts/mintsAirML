function currentFileName = getMintsFileNameFigPre(folder,nodeIDs,nodeIndex,...
                                                            target,stringIn)
        nodeDataFolder      = folder+ "/"+nodeIDs(nodeIndex);
        currentFileName     = nodeDataFolder+"/"+stringIn + "_" +...
                                    nodeIDs(nodeIndex)+ "_" + ...
                                          target ;
                                          
    if ~exist(fileparts(currentFileName), 'dir')
       mkdir(fileparts(currentFileName));
    end
end
