function currentFileName = getMintsFileNamesStr(period,dateIndex,folder,nodeIDs,nodeIndex,stringIn)
        currentDate         = period(dateIndex);
        nodeDataFolder      = folder+ "/"+nodeIDs(nodeIndex);
        currentFileName     = nodeDataFolder+ "/"+...
                                num2str(year(currentDate),'%04.f')+"/"+...
                                    num2str(month(currentDate),'%02.f')+"/"+...
                                        num2str(day(currentDate),'%02.f')+"/"+...
                                          stringIn+"_"+....
                                            nodeIDs(nodeIndex)+"_"+....
                                                num2str(year(currentDate),'%04.f')+"_"+...
                                                    num2str(month(currentDate),'%02.f')+"_"+...
                                                        num2str(day(currentDate),'%02.f')+...
                                                            ".mat";
    if ~exist(fileparts(currentFileName), 'dir')
       mkdir(fileparts(currentFileName));
    end
end