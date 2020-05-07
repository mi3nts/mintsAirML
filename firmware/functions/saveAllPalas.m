
function [] = saveAllPalas(palasDataFolder,dotMatFolder)
%SAVEALLGRIM Summary of this function goes here
%   Detailed explanation goes here

% dotMatFolder    = dataFolder + "/dotMats";
% palasDataFolder = dataFolder + "/palasFrog";
palasDataAll    = dir(palasDataFolder);
palasDataTable  = struct2table(palasDataAll);

palasDataWanted = palasDataTable(endsWith(palasDataTable.name,'.txt'),:);
palasDataFiles    = strcat(palasDataWanted.folder,"/",palasDataWanted.name);
 


%% Create Dot Mat Files  

    % Concatinating Data Files 
     palasDataPMAll       = [] ;
     palasDataWeatherAll  = [] ;



         parfor n =1 :length(palasDataFiles)
             [palasDataPM,palasDataWeather] = savePalasFile(palasDataFiles(n));
              palasDataPMAll       = [palasDataPMAll;palasDataPM] ;
              palasDataWeatherAll  = [palasDataWeatherAll;palasDataWeather ] ;

%               clear palasDataPM palasDataWeather
         end


         
     palasDataPMAll              = sortrows(table2timetable(palasDataPMAll));
     palasDataWeatherAll         = sortrows(table2timetable(palasDataWeatherAll));
     [palasDataPMDaily     ,datesPM,indexesPM] = splitToDates(palasDataPMAll);
     [palasDataWeatherDaily,datesW,indexesW] = splitToDates(palasDataWeatherAll);

     
    %% Writing Dot Mats 
     
    %% PM Data  
     
     for  n=1:indexesPM
         palasMintsPM  = palasDataPMDaily{n};
         saveName    = strcat(dotMatFolder,"/", num2str(datesPM.Year(n),'%04d'),"/",...
                                                     num2str(datesPM.Month(n),'%02d'),"/",...
                                                     num2str(datesPM.Day(n),'%02d'),"/",...
                                                     "MINTS_PALAS_PM_",...
                                                     num2str(datesPM.Year(n),'%02d'),"_",...
                                                     num2str(datesPM.Month(n),'%02d'),"_",...
                                                     num2str(datesPM.Day(n),'%02d'),".mat"...
                                                 )        
         mkdir(fileparts(saveName));
         save(char(saveName),'palasMintsPM');
         
%          clear palasMintsPM saveName
         
         
     end
   
     
    %% Weather Data  
     
      for  n=1:indexesW
         palasMintsWeather  = palasDataWeatherDaily{n};
         saveName    = strcat(dotMatFolder,"/", num2str(datesPM.Year(n),'%04d'),"/",...
                                                     num2str(datesPM.Month(n),'%02d'),"/",...
                                                     num2str(datesPM.Day(n),'%02d'),"/",...
                                                     "MINTS_PALAS_Weather_",...
                                                     num2str(datesPM.Year(n),'%02d'),"_",...
                                                     num2str(datesPM.Month(n),'%02d'),"_",...
                                                     num2str(datesPM.Day(n),'%02d'),".mat"...
                                                 )         
         mkdir(fileparts(saveName));
         save(char(saveName),'palasMintsWeather');
         
         clear palasMintsWeather saveName
         
         
     end
     
     
     
     
     
     
     
     
     
     
  
     
end

