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