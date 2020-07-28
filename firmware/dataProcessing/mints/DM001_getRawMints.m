
%% Saving raw Mints Data as Daily Tables 

% Defining Node IDS 
display("--------MINTS--------")
addpath("../../functions/")

nodeIDs   = {...
    '001e06305a12',...
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
 
startDate  = datetime(2020,04,01) ;
endDate    = datetime(2020,08,01) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
rawFolder        = dataFolder + "/raw";
rawDotMatsFolder = rawFolder + "/rawDotMats";

% Going through Each Node 
for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    parfor dateIndex = 1:length(period)
        nodeDataFiles = getMintsFileNames(period,dateIndex,rawFolder,nodeIDs,nodeIndex);
        saveAsDataStoreReferenceMats(nodeDataFiles)   
    end % Dates 
end % Node ID

function [] = saveAsDataStoreReferenceMats(nodeDataFiles)
%SAVEASDATASTORERAWMATS Summary of this function goes here
%   Detailed explanation goes here
     for fileIndex = 1 : length(nodeDataFiles)   
           fileName = strcat(nodeDataFiles(fileIndex).folder,"/",nodeDataFiles(fileIndex).name);
           fileNameMat = strrep(strrep(fileName,'reference','referenceMats'),'csv','mat')  ;
           if ~(isfile(fileNameMat))
               display("Saving "+ fileName )
               mintsData = tabularTextDatastore(fileName, 'TreatAsMissing', 'NA');

               if ~exist(fileparts(fileNameMat), 'dir')
                   mkdir(fileparts(fileNameMat));
               end

               save(fileNameMat,'mintsData');
           end
%            
     end
end