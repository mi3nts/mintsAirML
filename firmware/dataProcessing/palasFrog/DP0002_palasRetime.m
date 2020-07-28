clc
clear all
close all 

%% Saving raw Palas Data as Daily Tables 

% display("--------MINTS--------")
% 
% nodeIDs   = {'001e063059c2'};
%  
% dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
% referenceFolder  = dataFolder + "/reference";
% palasFolder      = referenceFolder + "/palas/mintsData";
% 
% palasFiles       = dir(palasFolder+"/*.txt")
% 
% palasAirAll          = [] 
% palasWeatherAll      = [] 
% 
% for fileIndex = 1: length(palasFiles)
%     fileName = strcat(palasFiles(fileIndex).folder,"/",palasFiles(fileIndex).name);
%     display("Reading "+ fileName)
%     [palasAir,palasWeather] = importPalasData(fileName) ;
%     palasAirAll     = [palasAirAll ;palasAir] ;
%     palasWeatherAll = [palasWeatherAll ;palasWeather] ;          
%     
% end
% 
% save("palasSet1.mat",'palasAirAll','palasWeatherAll')


palasAirAllRetimed     = retime(table2timetable(unique(palasAirAll)),'regular',@mean,'TimeStep',seconds(30));
palasWeatherAllRetimed = retime(table2timetable(unique(palasWeatherAll)),'regular',@mean,'TimeStep',seconds(30));

save("palasSetJuly2020Retimed.mat",'palasAirAllRetimed','palasWeatherAllRetimed')


% for fileIndex = 1: length(palasFiles)
%     fileName     = strcat(palasFiles(fileIndex).folder,"/",palasFiles(fileIndex).name);
%     fileNameMove = strcat(palasFiles(fileIndex).folder,"/read/");
%     [status,msg] = movefile(fileName,fileNameMove)      
%     
% end
% 
% 
figure
plot(palasAirAll.dateTime,palasAirAll.pm1_PALAS,'b.')
hold on 
plot(palasAirAll.dateTime,palasAirAll.pm2_5_palas,'g.')
plot(palasAirAll.dateTime,palasAirAll.pm10_palas,'r.')

plot(palasAirAllRetimed.dateTime,palasAirAllRetimed.pm1_PALAS,'k-')
hold on 
plot(palasAirAllRetimed.dateTime,palasAirAllRetimed.pm2_5_palas,'y-')
plot(palasAirAllRetimed.dateTime,palasAirAllRetimed.pm10_palas,'i-')

