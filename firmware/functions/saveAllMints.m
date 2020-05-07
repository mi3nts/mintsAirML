function [] = saveAllMints(dataFolder,dotMatsFolder,nodeID,sensorName)
%SAVEALLGRIM Summary of this function goes here
%   Detailed explanation goes here
    mintsDataWanted   = getMintsSensorFiles(dataFolder,nodeID,sensorName);
    mintsDataWanted(contains(string(mintsDataWanted.folder),"mints@"),:)=[];
%     mintsDataWanted
    
    string(mintsDataWanted.folder)
    string(mintsDataWanted.name)
    mintsDataFiles    = string(mintsDataWanted.folder) +"/"+ string(mintsDataWanted.name);
    saveNamesPre      = string(mintsDataWanted.folder) +"/"+ strrep(string(mintsDataWanted.name),"csv","mat");
    saveNamesDotMat   = strrep(saveNamesPre , dataFolder , dotMatsFolder);



%% Create Dot Mat Files  

    for n =1 :length(mintsDataFiles)
        saveNamesDotMat(n)
        if(sensorName =="GPSGPGGA")
            mintsData =  getMintsGPSGPGGA(mintsDataFiles(n));
        elseif(sensorName =="GPSGPRMC")
            mintsData =  getMintsGPSGPRMC(mintsDataFiles(n));
        elseif(sensorName =="GPSGPRMC2")
            mintsData =  getMintsGPSGPRMC2(mintsDataFiles(n));    
        elseif(sensorName =="GPSGPGGA2")
            mintsData =  getMintsGPSGPGGA2(mintsDataFiles(n));   
        else
            mintsData =  getMintsSensorData(mintsDataFiles(n),sensorName);
        end
        
            mkdir(fileparts(saveNamesDotMat(n)));
            save(char(saveNamesDotMat(n)),'mintsData');
            clear mintsData
    
        end
    
end


