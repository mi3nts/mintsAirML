clc
clear all
close all 

%% Saving raw Palas Data as Daily Tables 

display("--------MINTS--------")

dataFolder          = "/media/teamlary/Team_Lary_2/air930/mintsData";
referenceFolder     = dataFolder + "/reference";
referenceMatsFolder = dataFolder + "/referenceMats";
palasFolder         = referenceFolder       + "/palasStream";
palasMatsFolder     = referenceMatsFolder   + "/palasStream";

palasFiles       = dir(palasFolder+"/*.txt");

parfor fileIndex = 1: length(palasFiles)
   try
    tic
        fileName = strcat(palasFiles(fileIndex).folder,"/",palasFiles(fileIndex).name);
        fileNameMat = strrep(strrep(fileName,"reference","referenceMats"),"txt","mat");
        savePalasStreamFile(fileName,fileNameMat,seconds(30));
    toc
   catch ME
       fid = fopen('errorLog.txt', 'wt');
       errorLog  = strcat("Error With File: '",fileName,"'") ;
       display(errorLog)
   end
    
end
% Close the txt file

%% Concatinate All Palas Stream Data 



