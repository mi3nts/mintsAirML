clc
close all
clear all 

% Data Pre Processing for Pre Car Calibration 
% Defining Node IDs

display("--------MINTS--------")
addpath("../../functions/")

% Loading Mints Data 
rawMatsFolder = "/media/teamlary/Team_Lary_2/air930/mintsData/rawMats/"

% Constructing the input and output data for ML 
mergedMatsFolder = "/media/teamlary/Team_Lary_2/air930/mintsData/mergedMats/"

trainingMatsFolder   = "/media/teamlary/Team_Lary_2/air930/mintsData/trainingMats"

nodeIDs   = {...
                 '001e06305a12',...
%                 '001e06323a12',...
%                 '001e06318cd1',...
%                 '001e06305a61',...
%                 '001e06323a05',...
%                 '001e06305a57',...
%                 '001e063059c2',...
%                 '001e06318c28',...
%                 '001e06305a6b',...
%                 '001e063239e3',...
%                 '001e06305a6c'...
                };

            
            
mintsInputs = {...
    'temperature_BME280'           ,...
    'pressure_BME280'              ,...
    'humidity_BME280'              ,...
%     'temperature_SCD30'            ,...
%     'humidity_SCD30'       ...
    };


mintsInputLabels = {...
    'Temperature BME280'               ,...
    'Pressure BME280'                  ,...
    'Humidity BME280'                  ,...
%     'Temperature SCD30'                ,...
%     'Humidity SCD30'                  ...
     };

mintsTargets =   {...
                  'barrometricPressureBars_YXXDR'   ,...
                  'airTemperature_WIMDA'            ,...
                  'relativeHumidity_WIMDA'          ,...
                  'dewPoint_WIMDA'                 ...
                   }

        
mintsTargetLabels =   {...
                  'Pressure'   ,...
                  'Temperature'            ,...
                  'Humidity'          ,...
                  'Dew Point'                 ...
                   }

binsPerColumn   = 400;
numberPerBin    = 300 ;
pValid          = 0.25;
            
for nodeIndex = 1:length(nodeIDs)
    nodeID = nodeIDs{nodeIndex}
    
    load(strcat(mergedMatsFolder,...
                    nodeIDs{nodeIndex},...
                    "/mintsWithAirMarWSTC_",...
                    nodeIDs{nodeIndex},...
                    "_2019_04_30_to_2020_04_24"));
    
    for targetIndex = 1: length(mintsTargets)    
        target = mintsTargets{targetIndex};
        targetLabel = mintsTargetLabels{targetIndex};
  
        display(newline)
        display("Gainin Data set for Node "+ nodeID + " with target output " + target)
        
        [In_Train,Out_Train,...
            In_Validation,Out_Validation,...
                trainingTT, validatingTT,...
                    trainingT, validatingT ] ...
                                    = representativeSampleTT(mintsWithAirMarWSTC,mintsInputs,target,pValid,binsPerColumn,numberPerBin);

    %% Save Representative Samples                         
    height(trainingTT)+height(validatingTT)
    % Getting the Save Name 
    saveName = getMintsFileNameTraining(trainingMatsFolder,nodeIDs,nodeIndex,...
                                                            target,"trainingMintsWeather");
    
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
             'binsPerColumn',...
             'numberPerBin',...
             'pValid' ...
         )
 
    % Clear everything  except for 
    clearvars -except...
               rawMatsFolder mergedMatsFolder trainingMatsFolder...
               nodeIDs nodeIndex nodeID ...
               mintsWithAirMarWSTC ...
               mintsInputs mintsInputLabels ...
               mintsTargets mintsTargetLabels targetIndex ...
               binsPerColumn numberPerBin pValid 
   
    end % targets                    
    
    clear mintsWithAirMarWSTC nodeID
    
end % nodes   



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



function [In_Train,Out_Train,...
            In_Validation,Out_Validation,...
               trainingTT, validatingTT,...
                trainingT, validatingT ] ...
                            = representativeSampleTT(timeTableIn,inputVariables,target,pvalid,nbins_per_column,n_per_bin)
 
    tableIn  =  timetable2table(timeTableIn);            
    In       =  table2array(tableIn(:,inputVariables));
    Out      =  table2array(tableIn(:,target));

    D=[In Out];

    % Find size of D
    n=size(D);
    nrows=n(1);
    ncols=n(2);

    %--------------------------------------------------------------------------
    % Go through each column and choose a representative sample.
    ikeep_train = [];
    ikeep_valid = [];
    ikeepAll    = [];
    
    for icol=1:ncols

        %--------------------------------------------------------------------------
        % Take a copy of this coulumn
        this_col=D(:,icol);

        nunique_this_col=length(unique(this_col));

        % Number of bins per column (variable)
        nbins_this_column=min([nbins_per_column nunique_this_col]);
        n_per_thisbin=n_per_bin;

        % For the output variable have more bins.
        if icol==ncols
            nbins_this_column=min([nbins_this_column*2 nunique_this_col]);
            n_per_thisbin=n_per_bin*2;
        end

        disp([...
            'Going through column ' num2str(icol) ...
            ' and choosing a representative sample. Choosing ' ...
            num2str(nbins_this_column) ' bins for this column. With ' ...
            num2str(n_per_thisbin) ' members per bin.' ...
            ]);


        %--------------------------------------------------------------------------
        % For this column split into nbins_per_column
        % returns an index array, bin, using any of the previous syntaxes. 
        % bin is an array of the same size as X whose elements are the bin 
        % indices for the corresponding elements in X. 
        % The number of elements in the kth bin is nnz(bin==k), 
        % which is the same as N(k).
        [N,edges,bin] = histcounts(this_col,nbins_this_column);

        % loop over the bins
        for ibin=1:nbins_this_column

            clear ikeep_this_bin nkeep_this_bin iwant_ibin nwant_ibin ...
                nchoose_this_bin ipoint_this_bin

            % find which indices are in this bin
            iwant_ibin=find(bin==ibin);

            % find the number of points in this bin
            nwant_ibin=length(iwant_ibin);

            % take a random sample of n_per_bin from each bin
            nchoose_this_bin=min([n_per_thisbin nwant_ibin]);

            % Find the indices of the actual data records
            ipoint_this_bin=randperm(nwant_ibin,nchoose_this_bin);

            % Add these to the list of records we will be keeping
            ikeep_this_bin=iwant_ibin(ipoint_this_bin);

            ikeepAll = cat(1,ikeepAll,ikeep_this_bin);

        end
        % loop over the bins
        %--------------------------------------------------------------------------
        %length(ikeep)

    end

    % Go through each column and choose a representative sample.
    %--------------------------------------------------------------------------

    ikeepAll                     = unique(ikeepAll);
    [trainInd,valInd,testInd]    = dividerand(length(ikeepAll),1-pvalid,0,pvalid);
    ikeepAllTraining             = ikeepAll(trainInd) ;
    ikeepAllValidating           = ikeepAll(testInd)  ;

    In_Train       = In(ikeepAllTraining,:);
    In_Validation  = In(ikeepAllValidating,:);

    Out_Train      = Out(ikeepAllTraining);
    Out_Validation = Out(ikeepAllValidating);           

    trainingTT     = timeTableIn(ikeepAllTraining ,{inputVariables{:},target});
    validatingTT   = timeTableIn(ikeepAllValidating,{inputVariables{:},target});

    trainingT          = timetable2table(trainingTT);
    validatingT        = timetable2table(validatingTT);
    
    trainingT.dateTime   = [];
    validatingT.dateTime = [];   
    
end

