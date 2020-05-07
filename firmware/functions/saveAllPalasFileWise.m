
function [] = saveAllPalasFileWise(palasDataFolder,dotMatFolder)
%SAVEALLGRIM Summary of this function goes here
%   Detailed explanation goes here

% dotMatFolder    = dataFolder + "/dotMats";
% palasDataFolder = dataFolder + "/palasFrog";
palasDataAll    = dir(palasDataFolder);
palasDataTable  = struct2table(palasDataAll);

palasDataWanted = palasDataTable(endsWith(palasDataTable.name,'.txt'),:);
palasDataFiles    = strcat(palasDataWanted.folder,"/",palasDataWanted.name);
 

         for m =1 :length(palasDataFiles)
             [palasDataPM,palasDataWeather] = savePalasFile(palasDataFiles(m));        
             [palasDataPMDaily     ,datesPM,indexesPM] = splitToDates(palasDataPM);
             [palasDataWeatherDaily,datesW,indexesW]   = splitToDates(palasDataWeather);
         
         
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
                         clear palasMintsPM saveName
                  end
             
             
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

                clear palasDataPM palasDataWeather palasDataPMDaily   datesPM indexesPM palasDataWeatherDaily datesW indexesW
         end
  
  
     
end

