function [] = saveDaily(fileName,period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex)
            if ~(isfile(fileName))
                nodeDataFiles = getMintsFileNamesMat(period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex);
                for fileIndex = 1 : length(nodeDataFiles)
               
                    fileNameRaw         = strcat(nodeDataFiles(fileIndex).folder,"/",nodeDataFiles(fileIndex).name);
                    if(fileIndex==1)
                        mintsDaily   = getVarNamesWithData(load(fileNameRaw)).mintsData.readall;
                    else
                        currentData  = getVarNamesWithData(load(fileNameRaw)).mintsData.readall;
                        mintsDaily   = outerjoin(mintsDaily,currentData,'Keys',{'dateTime'},'mergeKeys',true);
                    end    


                end % Files
                 
 
                if(length(nodeDataFiles)>0)
                    
                    save(fileName, 'mintsDaily');
                end
                
            else
                display(fileName+ " Already exists");
            end % File Name Existance
end
