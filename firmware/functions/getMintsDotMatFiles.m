function nodeDataTable = getMintsDotMatFiles(dataFolder,nodeID)
%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
nodeDataFolder = dataFolder+  "/"+nodeID;
nodeDataAll    = dir(nodeDataFolder+ "/**/**/*.mat");
nodeDataTable  = unique(struct2table(nodeDataAll),'rows');


end
