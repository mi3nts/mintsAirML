function [ ] = saveDailyRetimed(fileName,period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex,timeStep)
%SAVEDAILYRETIMED Summary of this function goes here
%   Detailed explanation goes here
             display("Going Through: " +fileName)
             if ~(isfile(fileName))
                nodeDataFiles = getMintsFileNamesMat(period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex);
                for fileIndex = 1 : length(nodeDataFiles)
               
                    [fileNameRaw,rawStatus]= getFileNameRaw(nodeDataFiles,fileIndex);

                    if(rawStatus)
                        display("Seeking: " +fileNameRaw)
                        [currentData,sensor] = getVarNamesWithDataAndSensor(load(fileNameRaw));
                        

                        currentDataTT = table2timetable(currentData.mintsData.readall);
                        if sensor=="GPSGPGGA2"
                            currentDataTT = removevars(currentDataTT,{'latitudeDirection_GPSGPGGA2',...
                                                                      'longitudeDirection_GPSGPGGA2',...
                                                                      'altitudeUnits_GPSGPGGA2',...
                                                                      'undulationUnits_GPSGPGGA2',...
                                                                      'age_GPSGPGGA2',...
                                                                      'stationID_GPSGPGGA2'});

                        end
                        if sensor=="GPSGPRMC2"
                            currentDataTT = removevars(currentDataTT,{...
                                                        'status_GPSGPRMC2',...
                                                        'latitudeDirection_GPSGPRMC2',...
                                                        'longitudeDirection_GPSGPRMC2',...
                                                        'trueCourse_GPSGPRMC2',...
                                                        'magVariation_GPSGPRMC2',...
                                                        'magVariationDirection_GPSGPRMC2'});

                        end

                        currentDataRetimed   = retime(currentDataTT,'regular',@nanmean,'TimeStep',timeStep);
                        if(fileIndex==1)
                            mintsDailyRetimed = currentDataRetimed;
                        else
                            mintsDailyRetimed   = outerjoin(mintsDailyRetimed,currentDataRetimed,'Keys',{'dateTime'},'mergeKeys',true);
                        end
                        
                    else
                        display("file "+fileNameRaw +" not Raw" )
                    end % Raw Status
                    
                end % Files
                 
%  
                if(length(nodeDataFiles)>0)
                    save(fileName, 'mintsDailyRetimed');
                end
                
            else
                display(fileName+ " Already exists");
            end % File Name Existance
end

