
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
 
startDate  = datetime(2018,04,04);
endDate    = datetime(2020,08,01) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/carMints";
referenceFolder        = dataFolder + "/reference";
referenceDotMatsFolder = dataFolder + "/referenceMats";
stringIn = "gpsMintsRetimed";
% stringInSet = "mintsSet1";
timeStep  = seconds(30);
% Going through Each Node 
for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    for dateIndex = 1:length(period)
%          try
            fileName = getMintsFileNamesStr(period,dateIndex,referenceDotMatsFolder,nodeIDs,nodeIndex,stringIn);
            saveDailyGPSRetimed(fileName,period,dateIndex,referenceDotMatsFolder,nodeIDs,nodeIndex,timeStep); 
%          catch exception
%             display("No data For "+ fileName)
%          end % Try Catch 
    end % Dates      
end % Node ID

function [] = saveDailyGPSRetimed(fileName,period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex,timeStep)
%SAVEDAILYRETIMED Summary of this function goes here
%   Detailed explanation goes here
             display("Going Through: " +fileName)
             if ~(isfile(fileName))
                nodeDataFiles = getMintsFileNamesGPSAllMat(period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex);
 
                for fileIndex = 1 : length(nodeDataFiles)
                    [fileNameRaw,rawStatus]= getFileNameRaw(nodeDataFiles,fileIndex)
                    if(rawStatus)
                        display("Seeking: " +fileNameRaw)
                        sensor = getSensorName(fileNameRaw,3)
                        currentDataTT = table2timetable(load(fileNameRaw).mintsData.readall);
                                             
                        if sensor=="GPSAllGPGGA"
                            currentDataTT = removevars(currentDataTT,{'latitudeDirection',...
                                                                      'longitudeDirection',...
                                                                      'altitudeUnits',...
                                                                      'undulationUnits',...
                                                                      'age',...
                                                                      'stationID'});

                        end
                        if sensor=="GPSAllGPRMC"
                            currentDataTT = removevars(currentDataTT,{...
                                                        'status',...
                                                        'latitudeDirection',...
                                                        'longitudeDirection',...
                                                        'trueCourse',...
                                                        'magVariationDirection'});

                        end
                        
                        if sensor=="GPSAllGPGGA" || sensor=="GPSAllGPRMC"
                            currentDataRetimed   = retime(currentDataTT,'regular',@nanmean,'TimeStep',timeStep);
                            if(fileIndex==1)
                                mintsDailyRetimed = currentDataRetimed;
                            else
                                mintsDailyRetimed   = outerjoin(mintsDailyRetimed,currentDataRetimed,'Keys',{'dateTime'},'mergeKeys',true);
                            end
                        end % GPS Files Only 
%                     
                    else
                        display("file "+fileNameRaw +" not Raw" )
                    end % Raw Status
%                       
                end % Files
  
                if(length(nodeDataFiles)>0)
                    save(fileName, 'mintsDailyRetimed');
                end
                
            else
                display(fileName+ " Already exists");
            end % File Name Existance
end



