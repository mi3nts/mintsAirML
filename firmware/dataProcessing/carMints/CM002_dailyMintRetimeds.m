
%% Saving raw Mints Data as Daily Tables 
clc
clear all
close all 
% 
addpath("/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/mintsAirML/firmware/functions")

% Defining Node IDS 
display("--------MINTS--------")


nodeIDs   = {...
             '001e0610c2e7',...
               };
 
startDate  = datetime(2018,04,01);
endDate    = datetime(2020,08,01) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/carMints";
referenceFolder        = dataFolder + "/reference";
referenceDotMatsFolder = dataFolder + "/referenceMats";
stringIn = "carMintsRetimed";
% stringInSet = "mintsSet1";
timeStep  = seconds(30);
% Going through Each Node 
for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    parfor dateIndex = 1:length(period)
        try
            fileName = getMintsFileNamesStr(period,dateIndex,referenceDotMatsFolder,nodeIDs,nodeIndex,stringIn)
            
            
            
            saveDailyCarRetimed(fileName,period,dateIndex,referenceDotMatsFolder,nodeIDs,nodeIndex,timeStep); 
        catch exception
            display("No data For "+ fileName)
        end % Try Catch 
    end % Dates      
end % Node ID



function [ ] = saveDailyCarRetimed(fileName,period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex,timeStep)
%SAVEDAILYRETIMED Summary of this function goes here
%   Detailed explanation goes here
             display("Going Through: " +fileName)
             if ~(isfile(fileName))
                nodeDataFiles = getMintsFileNamesMat(period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex);
                for fileIndex = 1 : length(nodeDataFiles)
               
                    [fileNameRaw,rawStatus]= getFileNameRaw(nodeDataFiles,fileIndex);

                    if(rawStatus)
                        display("Seeking: " +fileNameRaw)
                        datastore(fn_mask_gps)
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



