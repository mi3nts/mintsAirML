function [In_Train,Out_Train,In_Validation,Out_Validation]=representativeSampleSimple(In,Out,pvalid)


[trainInd,valInd,testInd] =  dividerand(length(Out),1-pvalid,0,pvalid);


In_Train   = In(trainInd,:);
In_Validation = In(testInd,:);

Out_Train      = Out(trainInd);
Out_Validation = Out(testInd);
