

%% Saving raw Mints Data as Daily Tables 

% Defining Node IDS 

% Creating Data Store Files for Each day 

display("--------MINTS--------")
addpath("../../functions/")

gateWayPis = ...
            {'b827ebf74482'
                'b827eb52fc29'}
loraIDs   = {...
                '475A5FE30031001B',...
                '475A5FE300320019',...
                '477B41F200290024',...
                '475A5FE3002E0023',...
                '475A5FE3002A0019',...
                '475A5FE3003E0023',...
                '475A5FE30031001B',...
                '475A5FE300320019',...
                '475A5FE300380019',...
                '477B41F200290024',...
                '475A5FE3002E001F',...
                '477B41F20047002E',...
                '475A5FE30021002D',...
                '475A5FE30031001F',...
                '475A5FE30028001F',...
                '478B5FE30040004B',...
                '472B544E00250037',...
                '47EB5580003C001A',...
                '47DB5580001E0039',...
                '479B558000380033',...
                '472B544E00230033',...
                '478B558000330027',...
                '475A5FE30035001B',...
                '472B544E0024004B'...
                                 };
 
startDate  = datetime(2018,04,01) ;
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
        saveAsDataStoreRawMats(nodeDataFiles)   
    end % Dates 
end % Node ID


% What Professor Lary Had 

% gps=sortrows(unique(gather(tall(datastore(fn_mask_gps)))));


