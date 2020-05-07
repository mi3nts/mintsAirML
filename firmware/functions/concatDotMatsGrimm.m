function grimmDataAll = concatDotMatsGrimm(dotMatsFolder,startDate,endDate)
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
    grimmDataAll = [];
    
    for n =1:length(duration)   
        fileName = dotMatsFolder+ "/Spectrometor_"+ num2str(year(duration(n)),'%04.f')+"-" +num2str(month(duration(n)),'%02.f')+"-"+num2str(day(duration(n)),'%02.f')+"-M.mat"  
       
        if (exist(fileName , 'file') == 2)
                load(fileName) 
                grimmDataAll = [grimmDataAll; grimmData];
        end

        clearvars grimmData 

    end 



end

