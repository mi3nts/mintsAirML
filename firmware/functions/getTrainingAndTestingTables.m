function [trainMints,testMints] = getTrainingAndTestingTables(mints,trainInd,testInd)
%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
% [trainInd,testInd] = divideblock(height(mints),training,1-training);


trainMints     = mints(trainInd,:);
testMints      = mints(testInd,:);
end
