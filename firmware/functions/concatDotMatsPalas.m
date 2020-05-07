function palasDataAll = concatDotMatsPalas(dotMatsFolder,nodeID,sensor,startDate,endDate)
%GETALLGRIMMDATA 
% concatinates all dotmats into one for he given dates range 

% dotMats       =  dataFolder+  "/dotMats"
% % 
% % grimmDotMats  = dotMats + "/Spectrometor"
% 
% startDate  = datetime(2019,02,12) 
% endDate    = datetime(2019,02,12)


%% Saving All Files As .mat for the Grimm Device
% 
% saveAllGrim(dataFolder);


%% Load the files you need as one 


    duration = startDate:endDate;
    palasDataAll = [];
  

    
    for n =1:length(duration)   
        fileName = dotMatsFolder +"/"+ num2str(year(duration(n)),'%04.f')+"/" +num2str(month(duration(n)),'%02.f')+"/"+num2str(day(duration(n)),'%02.f')+ "/"+...
                   "MINTS_PALAS_"+sensor+"_"+ num2str(year(duration(n)),'%04.f')+"_" +num2str(month(duration(n)),'%02.f')+"_"+num2str(day(duration(n)),'%02.f') +...
                   ".mat";
           

        if (exist(fileName , 'file') == 2)
                load(fileName) 
                
                if sensor=="PM"
                   palasDataAll = [palasDataAll; palasMintsPM];
                end
                
                if sensor=="Weather"
                   palasDataAll = [palasDataAll; palasMintsWeather];
                end
                
        end

        clearvars palasMintsPM  palasMintsWeather

    end 

        
    


end
