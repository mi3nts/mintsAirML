clc
clear all
close all 

%% Saving raw Palas Data as Daily Tables 

display("--------MINTS--------")

dataFolder          = "/media/teamlary/Team_Lary_2/air930/mintsData";
rawFolder     = dataFolder + "/raw";
rawMatsFolder = dataFolder + "/rawMats";
aeroqualFolder         = rawFolder       + "/aeroqual";
aeroqualMatsFolder     = rawMatsFolder   + "/aeroqual";

aeroqualFiles       = dir(aeroqualFolder+"/*/*.csv");

for fileIndex = 1: length(aeroqualFiles)
    try
        fileName = strcat(aeroqualFiles (fileIndex).folder,"/",aeroqualFiles(fileIndex).name);
        aeroqual{fileIndex} = aeroqualReader(fileName);
        
    catch ME
        fid = fopen('errorLog.txt', 'wt');
        errorLog  = strcat("Error With File: '",fileName,"'") ;
        display(errorLog)
    end
    
end


evalString  = "aeroqualAll = [";


for fileIndex = 1: length(aeroqualFiles)
    evalString = strcat(evalString,"aeroqual{",string(fileIndex),"};");  
end

evalString = strcat(evalString,"];");

display(evalString);

eval(evalString);

aeroqualUnique = unique(aeroqualAll); 

aeroqualUnique(aeroqualUnique.dateTime<datetime(2020,07,01,'TimeZone','utc'),:) = [];

aeroqualUnique.LocationID = [];

auroqual1 = table2timetable(aeroqualUnique(aeroqualUnique.MonitorID ==1,:));
auroqual2 = table2timetable(aeroqualUnique(aeroqualUnique.MonitorID ==2,:));
auroqual4 = table2timetable(aeroqualUnique(aeroqualUnique.MonitorID ==4,:));

save('auroqualAll.mat','auroqual1','auroqual2','auroqual4');










