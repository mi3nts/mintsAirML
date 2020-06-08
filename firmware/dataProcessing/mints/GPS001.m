% Convert from old format to new 

%% Saving raw Mints Data as Daily Tables 

% Defining Node IDS 
display("--------MINTS--------")
addpath("../../functions/")

nodeIDs   = {...
    '001e06305a12',...

    };
 
startDate  = datetime(2019,01,01) ;
endDate    = datetime(2020,05,01) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
rawFolder        = dataFolder + "/raw";

for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    parfor dateIndex = 1:length(period)
        
        nodeDataFiles = getMintsFileNames(period,dateIndex,rawFolder,nodeIDs,nodeIndex);
        % Going through each file 
        for fileIndex = 1: length(nodeDataFiles)
            try
            if(contains(string(nodeDataFiles(fileIndex).name),"_GPSGPGGA_"));
                fileName = string(nodeDataFiles(fileIndex).folder) + "/" +string(nodeDataFiles(fileIndex).name) 
                writeGPSGPGGA2csv(fileName)
            end
            if(contains(string(nodeDataFiles(fileIndex).name),"_GPSGPRMC_"));
                fileName = string(nodeDataFiles(fileIndex).folder) + "/" +string(nodeDataFiles(fileIndex).name) 
                writeGPSGPRMC2csv(fileName)
            end
      
            catch exception
                   display("No data For "+ fileName)

            end % Try Catch    
        end    
        % saveAsDataStoreRawMats(nodeDataFiles)   
    end % Dates 
end % Node ID