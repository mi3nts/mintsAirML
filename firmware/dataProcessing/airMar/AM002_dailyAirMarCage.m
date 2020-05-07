
%% Saving raw Mints Data as Daily Tables 
clc
clear all
close all 
% 
addpath("/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/mintsAirML/firmware/functions")

% Defining Node IDS 
display("--------MINTS--------")


nodeIDs   = {'001e0610c0e4',...
             };
 
startDate  = datetime(2019,01,01) ;
endDate    = datetime(2020,05,01) ;
period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
referenceDotMatsFolder = dataFolder + "/referenceMats";

timeStep  = seconds(30);
stringIn = "mintsDailyRetimed" +  string(timeStep);
% Going through Each Node 
for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    parfor dateIndex = 1:length(period)
        tic
        try
            fileName = getMintsFileNamesStr(period,dateIndex,referenceDotMatsFolder,nodeIDs,nodeIndex,stringIn);
            saveDailyRetimedAirMar2(fileName,period,dateIndex,referenceDotMatsFolder,nodeIDs,nodeIndex,timeStep); 

        catch exception
            display("No data For "+ fileName)

        end % Try Catch 
        toc
    end % Dates    
    
end % Node ID


function [] = saveDailyRetimedAirMar2(fileName,period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex,timeStep)
%SAVEDAILYRETIMED Summary of this function goes here
%   Detailed explanation goes here
             display("Going Through: " +fileName)
             if ~(isfile(fileName))
                
                nodeDataFiles = getMintsFileNamesMat(period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex);
                firstIn = true;
                for fileIndex = 1 : length(nodeDataFiles)
               
                    [fileNameRaw,rawStatus]= getFileNameRaw(nodeDataFiles,fileIndex);

                    if(rawStatus)
                        display("Seeking: " +fileNameRaw)
                        [currentData,sensor] = getVarNamesWithDataAndSensor(load(fileNameRaw));
               
                        currentDataTT = table2timetable(currentData.mintsData.readall);
                      
                        if sensor=="GPZDA"
                            currentDataTT(:,:) = [];                           
                        end                      
                        
                        if sensor=="HCHDT"
                            currentDataTT(:,:) = [];                           
                        end
                        
                        if sensor=="GPGGA"
                            currentDataTT = getAirMarGPGGA2(currentDataTT) ;
                        end
                        
                        if sensor=="GPVTG"
                            currentDataTT = getAirMarGPVTG2(currentDataTT) ;
                        end

          
                        if sensor=="WIMDA"
                            currentDataTT = getAirMarWIMDA2(currentDataTT) ;
                        end
                        
                        if sensor=="WIMWV"
                            currentDataTT = getAirMarWIMWV2(currentDataTT) ;                           
                        end
                        
                        if sensor=="YXXDR"
                            currentDataTT = getAirMarYXXDR2(currentDataTT) ;                           
                        end
                        
                        if(height(currentDataTT)>0)
                            currentDataRetimed   = retime(currentDataTT,'regular',@nanmean,'TimeStep',timeStep);

                            if(firstIn)
                                mintsDailyRetimed = currentDataRetimed;
                                firstIn = false; 
                            else
                                mintsDailyRetimed   = outerjoin(mintsDailyRetimed,currentDataRetimed,'Keys',{'dateTime'},'mergeKeys',true);
                            end
                        end % Height 
                    else
                        display("file "+fileNameRaw +" not Raw" )
                    end % Raw Status
                     
                end % Files

                if(length(nodeDataFiles)>0)
                    save(fileName, 'mintsDailyRetimed');
                end
            else
                display(fileName+ " Already exists");
            end % File Name Existance
end

function mintsData= getAirMarGPGGA2(mintsData)
  
        mintsData(isnan(mintsData.gpsQuality_GPGGA),:) = [];
        mintsData(mintsData.gpsQuality_GPGGA==0,:)     = [];
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.longitude_GPGGA =  getLongitudeAirMar(mintsData.longitude_GPGGA,mintsData.lonDirection_GPGGA);
        mintsData.latitude_GPGGA  =  getLatitudeAirMar(mintsData.latitude_GPGGA,mintsData.latDirection_GPGGA);
        mintsData.latDirection_GPGGA=[];
        mintsData.lonDirection_GPGGA=[];
        mintsData.AUnits_GPGGA=[];
        mintsData.GSUnits_GPGGA=[];
        mintsData.ageOfDifferential_GPGGA=[];
        mintsData.stationID_GPGGA=[];
        mintsData.checkSum_GPGGA=[];
  
end

function mintsData = getAirMarGPVTG2(mintsData)
  
        mintsData(isnan(mintsData.courseOGTrue_GPVTG),:) = [];
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.relativeToTN_GPVTG=[];
        mintsData.relativeToMN_GPVTG=[];
        mintsData.SOGKUnits_GPVTG=[];
        mintsData.SOGKMPHUnits_GPVTG=[];
        mintsData.mode_GPVTG=[];
        mintsData.checkSum_GPVTG=[];
  
end
        

function mintsData= getAirMarHCHDT2(mintsData)
  
        mintsData(isnan(mintsData.heading_HCHDT),:) = [];
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.HID_HCHDT=[];
        mintsData.checkSum_HCHDT=[];
  
end
        

 function mintsData= getAirMarWIMDA2(mintsData)
  
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.BPMUnits_WIMDA=[];
        mintsData.BPBUnits_WIMDA=[];
        mintsData.ATUnits_WIMDA=[];
        mintsData.waterTemperature_WIMDA=[];
        mintsData.WTUnits_WIMDA=[];
        mintsData.absoluteHumidity_WIMDA=[];
        mintsData.DPUnits_WIMDA=[];
        mintsData.WDMUnits_WIMDA=[];
        mintsData.windSpeedKnots_WIMDA=[];
        mintsData.windDirectionTrue_WIMDA=[];
        mintsData.windDirectionMagnetic_WIMDA=[];
        mintsData.WDTUnits_WIMDA=[];
        mintsData.WSKUnits_WIMDA=[];
        mintsData.windSpeedMetersPerSecond_WIMDA=[];
        mintsData.WSMPSUnits_WIMDA=[]; 
        mintsData.checkSum_WIMDA=[];


 end
        

function mintsData= getAirMarWIMWV2(mintsData)
  
        mintsData(isnan(mintsData.windAngle_WIMWV),:) = [];
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.WAReference_WIMWV=[];
        mintsData.WSUnits_WIMWV=[];
        mintsData.status_WIMWV=[];
        mintsData.checkSum_WIMWV=[];

end
        
function mintsData= getAirMarYXXDR2(mintsData)
  
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.TUnits_YXXDR=[];
        mintsData.RWCTID_YXXDR=[];
        mintsData.RWCTUnits_YXXDR=[];
        mintsData.theoreticalWindChillTemperature_YXXDR=[];
        mintsData.TUnits2_YXXDR=[];
        mintsData.TWCTUnits_YXXDR =[];
        mintsData.relativeWindChillTemperature_YXXDR=[];
        mintsData.TWCTID_YXXDR=[];
        mintsData.HIUnits_YXXDR =[];
        mintsData.temperature_YXXDR =[];     
        mintsData.heatIndex_YXXDR=[];
        mintsData.HIID_YXXDR=[];
        mintsData.pressureUnits_YXXDR=[];
        mintsData.BPBUnits_YXXDR=[];
        mintsData.BPBID_YXXDR =[];
        mintsData.checkSum_YXXDR=[];
  
end 
 
 

