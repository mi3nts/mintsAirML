function nodeDataFiles = getMintsFileNamesMat(period,dateIndex,rawFolder,nodeIDs,nodeIndex)
        currentDate         = period(dateIndex);
        nodeDataFolder      = rawFolder+ "/"+nodeIDs(nodeIndex);
        currentFileName     = nodeDataFolder+ "/"+...
                                num2str(year(currentDate),'%04.f')+"/"+...
                                    num2str(month(currentDate),'%02.f')+"/"+...
                                        num2str(day(currentDate),'%02.f')+"/*.mat";
        
        nodeDataFiles    = dir(currentFileName);
end
