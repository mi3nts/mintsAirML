
%% Saving raw Mints Data as Daily Tables 
clc
clear all
close all 
% 
addpath("/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/mintsAirML/firmware/functions")

% Defining Node IDS 
display("--------MINTS--------")


nodeIDs   = {...
    '001e06305a12',...
%     '001e06323a12',...
%     '001e06318cd1',...
%     '001e06305a61',...
%     '001e06323a05',...
%     '001e06305a57',...
%     '001e063059c2',...
%     '001e06318c28',...
%     '001e06305a6b',...
%     '001e063239e3',...
%     '001e06305a6c'...
    };
 
startDate  = datetime(2019,04,01);
endDate    = datetime(2020,04,25) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
rawFolder        = dataFolder + "/raw";
rawDotMatsFolder = dataFolder + "/rawMats";
stringIn = "mintsDailyRetimed";
stringInSet = "mintsSet1";
timeStep  = seconds(30);
% Going through Each Node 
for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    parfor dateIndex = 1:length(period)
        try
            fileName = getMintsFileNamesStr(period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex,stringIn);
            saveDailyRetimed(fileName,period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex,timeStep); 

        catch exception
            display("No data For "+ fileName)

        end % Try Catch 

    end % Dates    
    
end % Node ID



