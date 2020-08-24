clc
clear all 
close all 


load('/media/teamlary/Team_Lary_2/air930/mintsData/mergedMats/aeroqualWithPalas/aeroqualAllWithPalas.mat')


mintsInputs          =  {'PM10ppm' ,'PM25ppm'}
mintsInputLabels     =  {'PM_{10} ppm', 'PM_{2.5} ppm'}   

mintsTargets         =  {'pm1_PALAS','pm2_5_palas','pm4_palas','pm10_palas'}      
mintsTargetLabels    =  {...
                            'PM_{1}'                  ,...
                            'PM_{2.5}'                ,...
                            'PM_{4}'                  ,...
                            'PM_{10}'                 ,...
                        }        

nodeIDs   = {...
                  'aeroqual1',...
                  'aeroqual2',...
                  'aeroqual4'...
                };


pValid = .15;


trainingMatsFolder = "/media/teamlary/Team_Lary_2/air930/mintsData/trainingMats/aeroqual";

            
for nodeIndex = 1:length(nodeIDs)
    nodeID = nodeIDs{nodeIndex}
    
    eval(strcat("aeroqualWithPalas = ",nodeID,"WithPalas;"))
        
    for targetIndex = 1: length(mintsTargets)    
        target = mintsTargets{targetIndex};
        targetLabel = mintsTargetLabels{targetIndex};
  
        display(newline)
        display("Gainin Data set for Node "+ nodeID + " with target output " + target)
        
        [In_Train,Out_Train,...
            In_Validation,Out_Validation,...
                trainingTT, validatingTT,...
                    trainingT, validatingT ] ...
                                    = representativeSampleSimpleTT(aeroqualWithPalas,mintsInputs,target,pValid);

    %% Save Representative Samples                         
    
    % Getting the Save Name 
    saveName = getMintsFileNameTraining(trainingMatsFolder,nodeIDs,nodeIndex,...
                                                            target,"trainingMintsAir");
    
    display(saveName)                                                           
    % What to Save 
    save(saveName,...
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
             'pValid' ...
         )
 
    % Clear everything  except for 
    clearvars -except...
               rawMatsFolder mergedMatsFolder trainingMatsFolder...
               nodeIDs nodeIndex nodeID ...
               aeroqualWithPalas ...
               aeroqual1WithPalas ...
               aeroqual2WithPalas ...
               aeroqual4WithPalas ...
               mintsInputs mintsInputLabels ...
               mintsTargets mintsTargetLabels targetIndex ...
               binsPerColumn numberPerBin pValid 
   
    end % targets                    
    
    clear mintsWithPalas nodeID
    
end % nodes   













%% For Aeroqual 1 

function [In_Train,Out_Train,...
            In_Validation,Out_Validation,...
               trainingTT, validatingTT,...
                trainingT, validatingT ] ...
                            = representativeSampleSimpleTT(timeTableIn,inputVariables,target,pvalid)

    [trainInd,valInd,testInd] = dividerand(height(timeTableIn),1-pvalid,0,pvalid);

    tableIn  =  timetable2table(timeTableIn);            
    In       =  table2array(tableIn(:,inputVariables));
    Out      =  table2array(tableIn(:,target)); 

    In_Train       = In(trainInd,:);
    In_Validation  = In(testInd,:);

    Out_Train      = Out(trainInd);
    Out_Validation = Out(testInd);           

    trainingTT     = timeTableIn(trainInd ,[{inputVariables{:},target}]);
    validatingTT   = timeTableIn(testInd  ,[{inputVariables{:},target}]);

    trainingT          = timetable2table(trainingTT);
    validatingT        = timetable2table(validatingTT);

    trainingT.dateTime   = [];
    validatingT.dateTime = [];   
    
    
    

end





function currentFileName = getMintsFileNameTraining(folder,nodeIDs,nodeIndex,...
                                                            target,stringIn)
        nodeDataFolder      = folder+ "/"+nodeIDs(nodeIndex);
        currentFileName     = nodeDataFolder+"/"+stringIn + "_" +...
                                    nodeIDs(nodeIndex)+ "_" + ...
                                          target +"_"+...
                                              ".mat";
                                          
    if ~exist(fileparts(currentFileName), 'dir')
       mkdir(fileparts(currentFileName));
    end
end



