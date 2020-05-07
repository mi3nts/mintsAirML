
%% Saving raw Mints Data as Daily Tables 

% Defining Node IDS 
display("--------MINTS--------")


nodeIDs   = {'001e06305a12',...
             '001e06323a12',...
             '001e06318cd1',...
             '001e06305a61',...
             '001e06323a05',...
             '001e06305a57',...
             '001e063059c2',...
             '001e06318c28',...
             '001e06305a6b',...
             '001e063239e3',...
             '001e06305a6c',...
             };
 
startDate  = datetime(2019,01,01) ;
endDate    = datetime(2020,05,01) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
rawFolder        = dataFolder + "/raw";
rawDotMatsFolder = rawFolder + "/rawDotMats";

% Going through Each Node 
for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    for dateIndex = 1:length(period)
        nodeDataFiles = getMintsFileNames(period,dateIndex,rawFolder,nodeIDs,nodeIndex)
        saveAsDataStoreRawMats(nodeDataFiles)   
    end % Dates 
end % Node ID