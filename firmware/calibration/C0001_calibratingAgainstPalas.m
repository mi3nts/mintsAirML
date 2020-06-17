clc
close all
clear all 

% Data Pre Processing for Pre Car Calibration 
% Defining Node IDs

display("--------MINTS--------")
addpath("../../functions/");

% Loading Mints Data 
rawMatsFolder            = "/media/teamlary/Team_Lary_2/air930/mintsData/rawMats/";

mergedMatsFolder         = "/media/teamlary/Team_Lary_2/air930/mintsData/mergedMats/";

trainingMatsFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData/trainingMats";

modelsMatsFolder         = "/media/teamlary/Team_Lary_2/air930/mintsData/modelsMats";

gaussianRegression = true ;


nodeIDs   = {...
                '001e06305a12',...
                '001e06323a12',...
                '001e06318cd1',...
                '001e06305a61',...
                '001e06323a05',...
                '001e06305a57',...
                '001e063059c2',...
                '001e06318c28',...
                '001e06305a6b',...
                '001e063239e3',...
                '001e06305a6c'...
                };
            
mintsTargets =   {...
            'pm1_PALAS'                   ,...
            'pm2_5_palas'                 ,...
            'pm4_palas'                   ,...
            'pm10_palas'                  ,...
            'pmTotal_palas'               ,...
            'dCn_palas'                    };

versionStr = ['modelVersionGR_' datestr(today,'yyyy_mm_dd')];
disp(versionStr)
        
for nodeIndex = 1:length(nodeIDs)
    nodeID = nodeIDs{nodeIndex};
    
    for targetIndex = 1: length(mintsTargets)              
    
        target = mintsTargets{targetIndex};

        loadName = getMintsFileNameTraining(trainingMatsFolder,nodeIDs,nodeIndex,...
                                                                        target,"trainingMintsAir");
        display("Loading " + loadName);

        load(loadName);

       

        if(target == "dCn_palas" )
            trainingT(trainingT.dCn_palas == Inf,:) = [];
            In_Train(trainingT.dCn_palas == Inf,:) = [];
            Out_Train(trainingT.dCn_palas == Inf,:) = [];
            In_Validation(validatingT.dCn_palas == Inf,:) = [];
            Out_Validation(validatingT.dCn_palas == Inf,:) = [];
            trainingTT(trainingT.dCn_palas == Inf,:) = [];
            validatingTT(validatingT.dCn_palas == Inf,:) = [];
            trainingT(trainingT.dCn_palas == Inf,:) = [];
            validatingT(validatingT.dCn_palas == Inf,:) = [];
            
        end

        display("Running Regression")
        tic
        if(gaussianRegression)
           
            Mdl = fitrgp(trainingT,target,...
                'KernelFunction','squaredexponential',...
                'OptimizeHyperparameters','auto','HyperparameterOptimizationOptions',...
                struct('AcquisitionFunctionName','expected-improvement-plus',...
                 'UseParallel',true ...
                 ));


        else
            Mdl = fitrensemble(trainingT,target,...
                               'OptimizeHyperparameters','all',...
                               'HyperparameterOptimizationOptions',...
                                struct(...
                                'AcquisitionFunctionName','expected-improvement-plus',...
                                'UseParallel',true ...
                                )...
                            );
        end
        
        display("Training Time: " + toc  + " Sec")
        
        saveName = getMintsFileNameGeneral(modelsMatsFolder,nodeIDs,nodeIndex,...
                                                    target,versionStr)
                                                
        save(saveName,...
             'Mdl',...
             'In_Train',...
             'Out_Train',...
             'In_Validation',...
             'Out_Validation',...
             'trainingTT',...
             'validatingTT',...
             'trainingT',...
             'validatingT',...
             'mintsInputs',...
             'mintsInputLabels',...
             'target',...
             'targetLabel',...
             'nodeID',...
             'mintsInputs',...
             'mintsInputLabels',...
             'binsPerColumn',...
             'numberPerBin',...
             'pValid' ...
         )
       
        clearvars -except...
               versionStr ...
               rawMatsFolder mergedMatsFolder ...
               trainingMatsFolder modelsMatsFolder...
               nodeIDs nodeIndex nodeID ...
               mintsInputs mintsInputLabels ...
               mintsTargets mintsTargetLabels targetIndex ...
               binsPerColumn numberPerBin pValid 
    
    end %Targets 
    
    clear nodeID
    
end % Nodes 
