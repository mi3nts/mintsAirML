
%% Saving raw Mints Data as Daily Tables 

% Defining Node IDS 
display("--------MINTS--------")


nodeIDs   = {'001e063059c2'};
 
startDate  = datetime(2020,01,01) ;
endDate    = datetime(2020,01,01) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
rawFolder        = dataFolder + "/raw";
rawDotMatsFolder = rawFolder + "/rawDotMats";

% Going through Each Node 
for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    for dateIndex = 1:length(period)
        nodeDataFiles = getMintsFileNames(period,dateIndex,rawFolder,nodeIDs,nodeIndex)
        
        
           for fileIndex = 1 : length(nodeDataFiles)   
           fileName = strcat(nodeDataFiles(fileIndex).folder,"/",nodeDataFiles(fileIndex).name);
           fileNameMat = strrep(strrep(fileName,'raw','rawTTMats'),'csv','mat')  ;
           if ~(isfile(fileNameMat))
               display("Saving "+ fileName )
               mintsData = tabularTextDatastore(fileName, 'TreatAsMissing', 'NA');
%                mkdir(fileparts(fileNameMat));
%                save(fileNameMat,'mintsData');
           end
%            
     end
        
        
        
        
        
        
        
        
        saveAsDataStoreRawMats(nodeDataFiles)   
    end % Dates 
end % Node ID