function [] = saveAllAirMarMints(dataFolder,dotMatsFolder,nodeID,sensorName)
%SAVEALLGRIM Summary of this function goes here
%   Detailed explanation goes here
    mintsDataWanted   = getMintsSensorFiles(dataFolder,nodeID,sensorName)
    mintsDataWanted(contains(string(mintsDataWanted.folder),"mints@"),:)=[];
%     mintsDataWanted
    
    string(cell2mat(mintsDataWanted.folder));
    string(cell2mat(mintsDataWanted.name));
    mintsDataFiles    = string(cell2mat(mintsDataWanted.folder)) +"/"+ string(cell2mat(mintsDataWanted.name));
    saveNamesPre      = string(cell2mat(mintsDataWanted.folder)) +"/"+ strrep(string(cell2mat(mintsDataWanted.name)),"csv","mat");
    saveNamesDotMat   = strrep(saveNamesPre , dataFolder , dotMatsFolder);



%% Create Dot Mat Files  

    for n =1 :length(mintsDataFiles)
        saveNamesDotMat(n)
        eval(strcat("mintsData =  getAirMar",sensorName,"('",mintsDataFiles(n),"');"));
        mkdir(fileparts(saveNamesDotMat(n)));
        save(char(saveNamesDotMat(n)),'mintsData');
        clear mintsData
    end
    
end
