clc
clear all
close all 

%% Saving raw Palas Data as Daily Tables 

% display("--------MINTS--------")
% 
% nodeIDs   = {'001e063059c2'};
%  
display("--------MINTS--------")

dataFolder          = "/media/teamlary/Team_Lary_2/air930/mintsData";
referenceFolder     = dataFolder + "/reference";
referenceMatsFolder = dataFolder + "/referenceMats";
palasFolder         = referenceFolder       + "/palasStream";
palasMatsFolder     = referenceMatsFolder   + "/palasStream";
palasStramAll       = [];
palasStreamHeights  = [];

palasFiles       = dir(palasMatsFolder+"/*Log.mat");

parfor fileIndex = 1: length(palasFiles)

    S{fileIndex}        = load(strcat(palasFiles(fileIndex).folder,"/",palasFiles(fileIndex).name)).palasStream;
    palasStreamHeights(fileIndex) = height(S{fileIndex});

end



evalString = " palasStreamAll = ["  
for fileIndex = 1:length(palasFiles)
    if(palasStreamHeights(fileIndex)>0)
        evalString = strcat(evalString,"S{",string(fileIndex),"};");
    end
end % Dates       
evalString = strcat(evalString,"];");
display(evalString);
eval(evalString);

palasStreamAllRetimed     = retime(palasStreamAll,'regular',@mean,'TimeStep',seconds(30));

save('palasStreamDataAll','palasStreamAll','palasStreamAllRetimed');