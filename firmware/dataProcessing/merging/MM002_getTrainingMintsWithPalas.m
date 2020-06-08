


clc
clear all
close all 

%  Data Pre Processing for Pre Car Calibration 
% Defining Node IDS 
display("--------MINTS--------")
addpath("../../functions/")

% loading Palas Data 
load("/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/palas/palasSet1RetimedModified002.mat")

% Loading Mints Data 
rawMatsFolder = "/media/teamlary/Team_Lary_2/air930/mintsData/rawMats/"
% Constructing the input and output data for ML 
mergedMatsFolder = "/media/teamlary/Team_Lary_2/air930/mintsData/mergedMats"

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

% inputs             
            
            
            
for nodeIndex = 1:length(nodeIDs)
    
    loadString = strcat(mergedMats,"/",nodeIDs{nodeIndex},"/","mintsWithPalas_",nodeIDs{nodeIndex},"_2019_07_22_to_2019_11_26.mat");
    display("Loading: "+ loadString)
    load(loadString)
     
end % Nodes 
