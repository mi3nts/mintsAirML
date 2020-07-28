

clc
clear all
close all

display("------ MINTS ------")

addpath("../functions/")
startDate  = datetime('today','TimeZone','utc')-year(1) ;
endDate    = datetime('today','TimeZone','utc')  ;

%modelsFolder = "/media/teamlary/teamlary3/air930/mintsData/modelsMats/";

modelsFolder = "/home/teamlarylive/minstData/modelsMats/";

period     = endDate:-day(1):startDate;

dataFolder         =  "/media/teamlary/Team_Lary_2/air930/mintsData"
rawFolder          =  dataFolder + "/raw";
rawDotMatsFolder   =  dataFolder + "/rawMats";
liveResultsFolder  =  dataFolder + "/liveUpdate/results" ;

stringIn = "mintsDailyRetimed";
stringInLive = "calibrated_UTC";
timeStep  = seconds(30);

% currentHour = 25;
doPlots = false ; 

display(newline)
display("Data Folder Located @: "+ dataFolder)
display("Raw Data Located @: "+ dataFolder)
display("Raw DotMat Data Located @: "+ rawDotMatsFolder)
display("Models Located @: "+ modelsFolder)
display("Live Data Located @: "+ liveResultsFolder)
display(newline)
 
% syncFromMints(rawFolder)

nodeIDs   = {...
                '001e06323a12',...
                '001e06318cd1',...
                '001e06305a61',...
                '001e06323a05',...
                '001e06305a57',...
                '001e063059c2',...
                '001e06318c28',...
                '001e06305a6b',...
                '001e063239e3',...
                '001e06305a6c'...
                };
            
startDate  = datetime(2020,04,01,'TimeZone','utc');
endDate    = datetime('today','TimeZone','utc')  ;

period     = startDate : day(1) :endDate;

for dateIndex = 1:length(period)
    parfor nodeIndex = 1: length(nodeIDs)
        % Going through Each Date ;
        try
            nodeDataFiles = getMintsFileNames(period,dateIndex,rawFolder,nodeIDs,nodeIndex);
            saveAsDataStoreRawMatsAll(nodeDataFiles)  
% 
            fileName = getMintsFileNamesStr(period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex,stringIn);
            saveDailyRetimedAll(fileName,period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex,timeStep); 

         catch exception %#ok<NASGU>
            display("No data For Current Node") %#ok<DISPLAYPROG>

        end % Try Catch 
    end % Dates 
end % Node ID