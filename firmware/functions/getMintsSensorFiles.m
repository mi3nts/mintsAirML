function sensorFiles = getMintsSensorFiles(dataFolder,nodeID,sensorName)
%GETMINTSSENSORFILES Summary of this function goes here

    nodeDataTable = getMintsDataFiles(dataFolder,nodeID);
    sensorFiles   = nodeDataTable(contains(nodeDataTable.name,sensorName),:);
    
end

