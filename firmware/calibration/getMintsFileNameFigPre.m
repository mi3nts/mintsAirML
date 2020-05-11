function currentFileName = getMintsFileNameFigPre(folder,nodeIDs,nodeIndex,...
                                                            target,stringIn)
        nodeDataFolder      = folder+ "/"+nodeIDs(nodeIndex);
        currentFileName     = nodeDataFolder+"/"+target+"/"+stringIn + "_" +...
                                    nodeIDs(nodeIndex)+ "_" + ...
                                          target +"_";
                                          
    if ~exist(fileparts(currentFileName), 'dir')
       mkdir(fileparts(currentFileName));
    end
end
