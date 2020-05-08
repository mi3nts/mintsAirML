function [] = saveAllForToday(dataFolder,dotMatsFolder,nodeID)
%SAVEALLGRIM Summary of this function goes here
%   Detailed explanation goes here
    datesPM = datetime('now','TimeZone','UTC')
    nodeDataFolder = dataFolder+  "/"+nodeID; 
    nodeDataAll    = dir(nodeDataFolder+ "/"+...
                            num2str(datesPM.Year,'%04d')+"/"+ ...
                              num2str(datesPM.Month,'%02d')+"/"+...
                               num2str(datesPM.Day,'%02d'))
                              


%     mintsDataAll    = dir(nodeDataAll)
     mintsDataTable  = struct2table(nodeDataAll)

     mintsDataWanted = mintsDataTable (endsWith(mintsDataTable.name,'.csv'),:)


%                               ;
%         nodeDataTable  = unique(struct2table(nodeDataAll),'rows');
% 
% 
%     mintsDataWanted   = getMintsSensorFiles(dataFolder,nodeID,sensorName);
%     mintsDataWanted(contains(string(mintsDataWanted.folder),"mints@"),:)=[];
% %     mintsDataWanted
%     
%     string(mintsDataWanted.folder)
%     string(mintsDataWanted.name)
      mintsDataFiles    = string(mintsDataWanted.folder) +"/"+ string(mintsDataWanted.name);
      saveNamesPre      = string(mintsDataWanted.folder) +"/"+ strrep(string(mintsDataWanted.name),"csv","mat");
      saveNamesDotMat   = strrep(saveNamesPre , dataFolder , dotMatsFolder);

%% Create Dot Mat Files  

    for n =1 :length(mintsDataFiles)
        saveNamesDotMat(n)
        
        
        namesSpace = strsplit(string(mintsDataWanted.name(n)),"_")
        sensorName =  namesSpace(3)
        
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
    


