function nodeDataTable = getMintsDataFiles(dataFolder,nodeID)
%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
nodeDataFolder = dataFolder+  "/"+nodeID;
nodeDataAll    = dir(nodeDataFolder+ "/**/**/*.csv");
nodeDataTable  = unique(struct2table(nodeDataAll),'rows');


end

