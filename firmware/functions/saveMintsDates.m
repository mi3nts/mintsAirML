
function [] = saveMintsDates(dataFolder,dotMatsFolder,nodeID,sensorName,startDate,endDate)
%SAVEALLGRIM Summary of this function goes here
%   Detailed explanation goes here
    
    
    datesAll = startDate:days(1):endDate ;

    for n =1 : length(datesAll)
        currentDate =  datesAll(n);
        checkSet(n) = strcat(num2str(year(currentDate),'%02d'),"_",...
                         num2str(month(currentDate),'%02d'),"_",...
                         num2str(day(currentDate),'%02d')...
                         );

    end


    mintsDataWanted   = getMintsSensorFiles(dataFolder,nodeID,sensorName)
    mintsDataWanted(contains(string(mintsDataWanted.folder),"mints@"),:)=[];
%     mintsDataWanted
    display(".folder")
    string(cell2mat(mintsDataWanted.folder))

    
    
    display(".name")
    mintsDataWanted.name
    
    
    display(".nameCell")
%     string(cell2mat(mintsDataWanted.name))
    string(string(mintsDataWanted.name))
    
    
    
    mintsDataFiles    = string(cell2mat(mintsDataWanted.folder)) +"/"+ string(mintsDataWanted.name);
    saveNamesPre      = string(cell2mat(mintsDataWanted.folder)) +"/"+ strrep(string(mintsDataWanted.name),"csv","mat");
    saveNamesDotMat   = strrep(saveNamesPre , dataFolder , dotMatsFolder);

    wantedI= contains(mintsDataFiles,checkSet);


    
%% Create Dot Mat Files  

    for n =1 :length(mintsDataFiles)
        if(wantedI(n))
            saveNamesDotMat(n)
            if(sensorName =="GPSGPGGA")
                  mintsData =  getMintsGPSGPGGA(mintsDataFiles(n));
               elseif(sensorName =="GPSGPRMC")
                  mintsData =  getMintsGPSGPRMC(mintsDataFiles(n));
                elseif(sensorName =="GPSGPGGA2")
                  mintsData =  getMintsGPSGPGGA2(mintsDataFiles(n));
               elseif(sensorName =="GPSGPRMC2")
                  mintsData =  getMintsGPSGPRMC2(mintsDataFiles(n));                    
               else
                  mintsData =  getMintsSensorData(mintsDataFiles(n),sensorName);
            end
                  mkdir(fileparts(saveNamesDotMat(n)));
                  save(char(saveNamesDotMat(n)),'mintsData');
                  clear mintsData
        end
    end              
    
end


