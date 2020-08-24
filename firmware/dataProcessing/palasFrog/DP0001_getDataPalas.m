clc
clear all
close all 

%% Saving raw Palas Data as Daily Tables 

display("--------MINTS--------")

addpath('../../functions')
 
dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
referenceFolder  = dataFolder + "/reference";
palasFolder      = referenceFolder + "/palas";

palasFiles       = dir(palasFolder+"/*.txt")

palasAirAll          = [] 
palasWeatherAll      = [] 

for fileIndex = 1: length(palasFiles)
    fileName = strcat(palasFiles(fileIndex).folder,"/",palasFiles(fileIndex).name);
    display("Reading "+ fileName)
    [palasAir,palasWeather] = importPalasData(fileName) ;
    palasAirAll     = [palasAirAll ;palasAir] ;
    palasWeatherAll = [palasWeatherAll ;palasWeather] ;          
    
end

save("palasSetAug_22_2020.mat",'palasAirAll','palasWeatherAll')


% for fileIndex = 1: length(palasFiles)
%     fileName     = strcat(palasFiles(fileIndex).folder,"/",palasFiles(fileIndex).name);
%     fileNameMove = strcat(palasFiles(fileIndex).folder,"/read/");
%     [status,msg] = movefile(fileName,fileNameMove)      
%     
% end
% 

plot(palasAirAll.dateTime,palasAirAll.pm1_PALAS,'b.')
hold on 
plot(palasAirAll.dateTime,palasAirAll.pm2_5_palas,'g.')
plot(palasAirAll.dateTime,palasAirAll.pm10_palas,'r.')
