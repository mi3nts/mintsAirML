
%% MAIN 0:  Definitions 

clc 
clear all
close all 

addpath("../../functions/")

%% P0 - Specifying Parametors  

% Put all data in one time table with the following headers -
% dateTime, pm1, pm2.5 pm10 

% dataFolderPre      = "/home/lhw150030/mintsData";
dataFolderPre   = "/media/teamlary/Team_Lary_2/air930/mintsData"

dataFolder           = dataFolderPre + "/raw";
dataFolderGrimm      = dataFolderPre + "/reference";

dotMatsFolder   = dataFolderPre + "/dotMats" ;

nodeIDMints          = "001e06305a12";

nodeIDAirMar     = "001e0610c0e4";

deliverablesFolder = dataFolderPre + "/deliverables/"

grimmDotMats  = dotMatsFolder +  "/reference/GRIMM" ;
mintsDotMats  = dataFolderPre +  "/dotMats/raw" ;

dtSteps = [seconds(30)] 

dt = dtSteps(1)
dmSteps = [minutes(5), minutes(10)]  ; 

startDate  = datetime(2019,04,30) ;
endDate    = datetime(2019,08,30)
% %% main1_SaveGrimmData  
main1_getMintsData
%% main2_SaveMintsData  
main2_SyncData

% %% main3_SyncData  
% main3_SyncData
