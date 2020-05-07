function [regressionTree,imp] = trainBaggedTree(timeTableIn,target)
% TRAINBAGGEDTREE Summary of this function goes here
%   Detailed explanation goes here


tableIn          = timetable2table(timeTableIn);
tableIn.dateTime = [];
regressionTree= fitrtree(tableIn,target,...
'OptimizeHyperparameters','auto',...
'PredictorSelection','curvature',...
                        'Surrogate','on');
                             
 imp = predictorImportance(regressionTree) ;

end

