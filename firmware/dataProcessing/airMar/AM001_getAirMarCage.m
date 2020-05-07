
%% Saving raw Mints Data as Daily Tables 

% Defining Node IDS 
display("--------MINTS--------")


nodeIDs   = {'001e0610c0e4',...
             };
 
startDate  = datetime(2019,01,01) ;
endDate    = datetime(2020,05,01) ;

period     = startDate:endDate;

dataFolder          = "/media/teamlary/Team_Lary_2/air930/mintsData/"
airMarFolder        = dataFolder + "reference/001e0610c0e4";
referenceFolder     = dataFolder + "reference"
referenceMatsFolder = dataFolder + "referenceMats/001e0610c0e4";

% Going through Each Node 
for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    parfor dateIndex = 1:length(period)
        nodeDataFiles = getMintsFileNames(period,dateIndex,referenceFolder,nodeIDs,nodeIndex)
        saveAsDataStoreReferenceMats(nodeDataFiles)   
    end % Dates 
end % Node ID