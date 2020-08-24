% 

 
% # ***************************************************************************
% #  mintsAIRML
% #   ---------------------------------
% #   Written by: Lakitha Omal Harindha Wijeratne
% #   - for -
% #   Mints: Multi-scale Integrated Sensing and Simulation
% #   ---------------------------------
% #   Date: August 23rd, 2020
% #   ---------------------------------
% #   This module is written for generic implimentation of MINTS projects
% #   --------------------------------------------------------------------------
% #   https://github.com/mi3nts
% #   http://utdmints.info/
% #  ***************************************************************************
% 

%% Calibration of Aeroqual PM sensor
% The current file maps Aeroqual inputs to PM values read on Fidas® Frog
% portable fine dust measurement device 

%% Operation
% 1)Run the current code 
% 2)Select the aeroqual csv file
% 3)A .csv file with predictions for PM1, PM2.5, PM4 and PM10 are written on 
%   the same folder the original file is found  



clc
clear all 
close all 

addpath("../functions/");

[file,path] = uigetfile('*.csv');

if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end

display("--------MINTS--------")

fileName = strcat(path,file);


% % Loading Mints Data 
% rawMatsFolder = "/media/teamlary/Team_Lary_2/air930/mintsData/rawMats/";
% 
% mergedMatsFolder     = "/media/teamlary/Team_Lary_2/air930/mintsData/mergedMats/";
% 
% trainingMatsFolder   = "/media/teamlary/Team_Lary_2/air930/mintsData/trainingMats";

modelsMatsFolder     = "modelsMats/aeroqual";

% plotsFolder          = "/media/teamlary/Team_Lary_2/air930/mintsData/visualAnalysis/aeroqual";

 
fileName = strcat(path,file);

try

    
    aeroqualPredicted = aeroqualReader(fileName);
    
    mintsInputs          =  {'PM10ppm' ,'PM25ppm'};
    aeroqualIndex = aeroqualPredicted.MonitorID(end-1);


    inputData =  table2array(aeroqualPredicted(:, mintsInputs));

%% Definitions  
    nodeIDs   = {...
                      'aeroqual1',...
                      'aeroqual2',...
                      'aeroqual4'...
                    };

    mintsTargets         =  {'pm1_PALAS','pm2_5_palas','pm4_palas','pm10_palas'}  ;    
    mintsTargetLabels    =  {...
                                'PM_{1}'                  ,...
                                'PM_{2.5}'                ,...
                                'PM_{4}'                  ,...
                                'PM_{10}'                 ,...
                            };

    predictedLabels      =  {'PM1_Predicted','PM2_5_Predicted','PM4_Predicted','PM10_Predicted'} ;                  

    nodeIndex= getAeroqualID(aeroqualIndex) ;

    nodeID = nodeIDs{nodeIndex};

    versionStr = ['modelVersionNN_2020_08_23'];
    disp("Model Version: " + versionStr)

    %% Loading ML Models 
    
    for targetIndex = 1: length(mintsTargets)    
       target = mintsTargets{targetIndex};
       targetLabel = mintsTargetLabels{targetIndex};

       display(newline)
       display("Gainin Model for Node "+ nodeID + " with target output " + target)
       loadName = getMintsFileNameGeneral(modelsMatsFolder,nodeIDs,nodeIndex,...
                                                            target,versionStr);
       display("Loading :" + loadName) 
       load(loadName)                                                 

       evalStr = strcat("aeroqualPredicted.",predictedLabels{targetIndex},"=predictrnn(Mdl, inputData);");
%        display("evalString: " + evalStr)
       eval(evalStr)

       display(newline);
       close all
       clearvars -except...
                   versionStr ...
                   rawMatsFolder mergedMatsFolder ...
                   trainingMatsFolder modelsMatsFolder...
                   nodeIDs nodeIndex nodeID ...
                   mintsInputs mintsInputLabels ...
                   mintsTargets mintsTargetLabels targetIndex ...
                   binsPerColumn numberPerBin pValid ...
                   plotLimitsH plotLimitsL plotsFolder ...
                  targetUnits gapsX gapsY...
                  predictedLabels inputData aeroqualPredicted fileName 


    end

    
    display("Gaining Prediction")
    aeroqualPrePredicted  = aeroqualPredicted;
    predictionCorrection = zeros(height(aeroqualPredicted),1);

    %% Zero Correction 
    %sum(aeroqualPredicted.PM1_Predicted<0)
    predictionCorrection = predictionCorrection |(aeroqualPredicted.PM1_Predicted<0);
    aeroqualPredicted.PM1_Predicted((aeroqualPredicted.PM1_Predicted<0),:)=0;

    %sum(aeroqualPredicted.PM2_5_Predicted<0)
    predictionCorrection = predictionCorrection | (aeroqualPredicted.PM2_5_Predicted<0);
    aeroqualPredicted.PM2_5_Predicted((aeroqualPredicted.PM2_5_Predicted<0),:)=0;

    %sum(aeroqualPredicted.PM4_Predicted<0)
    predictionCorrection = predictionCorrection | (aeroqualPredicted.PM4_Predicted<0);
    aeroqualPredicted.PM4_Predicted((aeroqualPredicted.PM4_Predicted<0),:)=0;

    %sum(aeroqualPredicted.PM10_Predicted<0)
    predictionCorrection = predictionCorrection | (aeroqualPredicted.PM10_Predicted<0);
    aeroqualPredicted.PM10_Predicted((aeroqualPredicted.PM10_Predicted<0),:)=0;

    %% PM Corrections 

    %sum((aeroqualPredicted.PM2_5_Predicted>aeroqualPredicted.PM10_Predicted))
    predictionCorrection = predictionCorrection | (aeroqualPredicted.PM2_5_Predicted>aeroqualPredicted.PM10_Predicted);
    aeroqualPredicted.PM10_Predicted((aeroqualPredicted.PM2_5_Predicted>aeroqualPredicted.PM10_Predicted),:) =...
                               aeroqualPredicted.PM2_5_Predicted((aeroqualPredicted.PM2_5_Predicted>aeroqualPredicted.PM10_Predicted),:) ;  

    %sum((aeroqualPredicted.PM1_Predicted>aeroqualPredicted.PM2_5_Predicted))                       
    predictionCorrection = predictionCorrection | (aeroqualPredicted.PM1_Predicted>aeroqualPredicted.PM2_5_Predicted);                       
    aeroqualPredicted.PM1_Predicted((aeroqualPredicted.PM1_Predicted>aeroqualPredicted.PM2_5_Predicted),:) =...
                                aeroqualPredicted.PM2_5_Predicted((aeroqualPredicted.PM1_Predicted>aeroqualPredicted.PM2_5_Predicted),:) ;

    %sum((aeroqualPredicted.PM4_Predicted>aeroqualPredicted.PM10_Predicted))                          
    predictionCorrection = predictionCorrection | (aeroqualPredicted.PM4_Predicted>aeroqualPredicted.PM10_Predicted);  
    aeroqualPredicted.PM4_Predicted((aeroqualPredicted.PM4_Predicted>aeroqualPredicted.PM10_Predicted),:) =...
                                aeroqualPredicted.PM10_Predicted((aeroqualPredicted.PM4_Predicted>aeroqualPredicted.PM10_Predicted),:) ;

    %sum((aeroqualPredicted.PM2_5_Predicted>aeroqualPredicted.PM4_Predicted))                          
    predictionCorrection = predictionCorrection | (aeroqualPredicted.PM2_5_Predicted>aeroqualPredicted.PM4_Predicted);  
    aeroqualPredicted.PM4_Predicted((aeroqualPredicted.PM2_5_Predicted>aeroqualPredicted.PM4_Predicted),:) =...
                                aeroqualPredicted.PM10_Predicted((aeroqualPredicted.PM2_5_Predicted>aeroqualPredicted.PM4_Predicted),:) ;

%% Checks                      
%     sum(aeroqualPredicted.PM1_Predicted<0)                            
%     sum(aeroqualPredicted.PM2_5_Predicted<0)
%     sum(aeroqualPredicted.PM4_Predicted<0)
%     sum(aeroqualPredicted.PM10_Predicted<0) 
% 
%     sum((aeroqualPredicted.PM1_Predicted>aeroqualPredicted.PM2_5_Predicted))                            
%     sum((aeroqualPredicted.PM2_5_Predicted>aeroqualPredicted.PM4_Predicted))
%     sum((aeroqualPredicted.PM4_Predicted>aeroqualPredicted.PM10_Predicted))   

    aeroqualPredicted.Corrected   =  predictionCorrection;
    aeroqualPrePredicted.Validity =  ~predictionCorrection;

    aeroqualPrePredictedFN = strrep(fileName,'.csv','_Pre_Predicted.csv');
    aeroqualPredictedFN = strrep(fileName,'.csv','_Predicted.csv');

%% Visual Inspection    
%     plot(aeroqualPredicted.dateTime,aeroqualPredicted.PM1_Predicted,'y-')
%     hold on 
%     plot(aeroqualPredicted.dateTime,aeroqualPredicted.PM2_5_Predicted,'g-')
%     plot(aeroqualPredicted.dateTime,aeroqualPredicted.PM4_Predicted,'b-')
%     plot(aeroqualPredicted.dateTime,aeroqualPredicted.PM10_Predicted,'r-')

%% Publishing Results      
    display("Writing CSVs for Node "+ nodeID)
    writetable(aeroqualPrePredicted,aeroqualPrePredictedFN)
    writetable(aeroqualPredicted,aeroqualPredictedFN)

catch
   uiwait(msgbox('Invalid File!'));

end



 function  nodeIndex  = getAeroqualID(aeroqualIndex)
 
     nodeIndex    = NaN;
     if (aeroqualIndex ==1)
          nodeIndex    = NaN;
     end

     if (aeroqualIndex ==1)
          nodeIndex    = 1;
     end 

     if (aeroqualIndex ==2)
          nodeIndex    = 2;
     end 

     if (aeroqualIndex ==4)
          nodeIndex    = 3;
     end 
                                                
 end
 
 
 
 
 
 
 
 