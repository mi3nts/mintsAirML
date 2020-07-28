
%% Saving raw Mints Data as Daily Tables 

% Defining Node IDS 
% Defining Node IDS 
display("--------MINTS--------")
addpath("../../functions/")

nodeIDs   = {...
                '001e0610c2e7',...
                    };
 
startDate  = datetime(2018,04,01) ;
endDate    = datetime(2020,08,01) ;

period     = startDate:endDate;

dataFolder             = "/media/teamlary/Team_Lary_2/carMints";
% rawFolder              = dataFolder + "/raw";
% rawDotMatsFolder       = dataFolder + "/rawDotMats";
referenceFolder        = dataFolder + "/reference";
referenceDotMatsFolder = dataFolder + "/referenceDotMats";

% Going through Each Node 
for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    for dateIndex = 1:length(period)
        nodeDataFiles = getMintsFileNames(period,dateIndex,referenceFolder,nodeIDs,nodeIndex);
        saveAsDataStoreReferenceMats(nodeDataFiles)   
        
        %% For GPGGA Data 
        saveMintsGPSGPGGAMat(period,dateIndex,referenceFolder,nodeIDs,nodeIndex)
        saveMintsGPSGPRMCMat(period,dateIndex,referenceFolder,nodeIDs,nodeIndex)
         
    end % Dates 
end % Node ID


function [] = saveAsDataStoreReferenceMats(nodeDataFiles)
%SAVEASDATASTORERAWMATS Summary of this function goes here
%   Detailed explanation goes here
     for fileIndex = 1 : length(nodeDataFiles)   
           fileName = strcat(nodeDataFiles(fileIndex).folder,"/",nodeDataFiles(fileIndex).name);

          if nodeDataFiles(fileIndex).bytes<1   
            delete(fullfile(nodeDataFiles(fileIndex).folder, nodeDataFiles(fileIndex).name))
          else
              
              fileNameMat = strrep(strrep(fileName,'reference','referenceMats'),'csv','mat')  ;
              
              if ~(isfile(fileNameMat))
                   display("Saving "+ fileName )
                   mintsData = tabularTextDatastore(fileName, 'TreatAsMissing', 'NA');
                   if ~exist(fileparts(fileNameMat), 'dir')
                       mkdir(fileparts(fileNameMat));
                   end
                   save(fileNameMat,'mintsData');
              end
         end  
     end
end


function [] = saveMintsGPSGPGGAMat(period,dateIndex,rawFolder,nodeIDs,nodeIndex)

        currentDate         = period(dateIndex);
        nodeDataFolder      = rawFolder+ "/"+nodeIDs(nodeIndex);
        files     = nodeDataFolder+ "/"+...
                                num2str(year(currentDate),'%04.f')+"/"+...
                                    num2str(month(currentDate),'%02.f')+"/"+...
                                        num2str(day(currentDate),'%02.f')+"/*_GPSGPGGA*.csv";

        nodeDataFiles  = dir(files);
        if(length(nodeDataFiles)>0)                            
            %% Getting the file name from the first file 
            fileName = strcat(nodeDataFiles(1).folder,"/",nodeDataFiles(1).name);
            fileNameMat = strrep(eraseBetween(strrep(strrep(fileName,'reference','referenceMats'),...
                                                                   'csv','mat'),...
                                                                   'GPSGPGGA',strcat('_',num2str(year(currentDate),'%04.f'))),....
                                                                   'GPSGPGGA','GPSAllGPGGA');
            if ~(isfile(fileNameMat))
                   display("Saving "+ fileNameMat )
                   mintsData = tabularTextDatastore(files, 'TreatAsMissing', 'NA');

                   if ~exist(fileparts(fileNameMat), 'dir')
                       mkdir(fileparts(fileNameMat));
                   end

                   save(fileNameMat,'mintsData');
            end
        end
               
end


function [] = saveMintsGPSGPRMCMat(period,dateIndex,rawFolder,nodeIDs,nodeIndex)

        currentDate         = period(dateIndex);
        nodeDataFolder      = rawFolder+ "/"+nodeIDs(nodeIndex);
        files     = nodeDataFolder+ "/"+...
                                num2str(year(currentDate),'%04.f')+"/"+...
                                    num2str(month(currentDate),'%02.f')+"/"+...
                                        num2str(day(currentDate),'%02.f')+"/*_GPSGPRMC*.csv";

        nodeDataFiles  = dir(files);
        if(length(nodeDataFiles)>0)                            
            %% Getting the file name from the first file 
            fileName = strcat(nodeDataFiles(1).folder,"/",nodeDataFiles(1).name);
            fileNameMat = strrep(eraseBetween(strrep(strrep(fileName,'reference','referenceMats'),...
                                                                   'csv','mat'),...
                                                                   'GPSGPRMC',strcat('_',num2str(year(currentDate),'%04.f'))),....
                                                                   'GPSGPRMC','GPSAllGPRMC');
            if ~(isfile(fileNameMat))
                   display("Saving "+ fileNameMat )
                   mintsData = tabularTextDatastore(files, 'TreatAsMissing', 'NA');

                   if ~exist(fileparts(fileNameMat), 'dir')
                       mkdir(fileparts(fileNameMat));
                   end

                   save(fileNameMat,'mintsData');
            end
        end
               
end


