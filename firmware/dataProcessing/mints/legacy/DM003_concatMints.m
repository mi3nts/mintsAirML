

%% Saving raw Mints Data as Daily Tables 
clc
clear all
close all 
% 
% addpath("../functions")

% Defining Node IDS 
display("--------MINTS--------")


nodeIDs   = {'001e063059c2'};

 
startDate  = datetime(2019,01,01);
endDate    = datetime(2020,01,01) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
rawFolder        = dataFolder + "/raw";
rawDotMatsFolder = dataFolder + "/rawMats";

stringIn = "mintsDaily";
fileNameIndex = 1;

mintsDailyCell   = cell(1,length(period));
mintsDailyWidths = zeros(1,length(period));

for nodeIndex = 1: length(nodeIDs)
    % Going through Each Date ;
    fileNameForAll = getMintsRangeNameStr(startDate,endDate,rawDotMatsFolder,nodeIDs,nodeIndex,"deliverables/mintsDataAll");
    % Have An If to See 
    tic
    parfor dateIndex = 1:length(period)
        fileName  = getMintsFileNamesStr(period,dateIndex,rawDotMatsFolder,nodeIDs,nodeIndex,stringIn);
        display("Reading: "+fileName )
        if (isfile(fileName))
            mintsDaily                   = load(fileName).mintsDaily;
            S{dateIndex}                 = mintsDaily;
            mintsDailyWidths(dateIndex)  = width(mintsDaily);        
        end % File Name Available
    end % Dates    
    
    % Getting Eval String 
    evalString = " mintsDataAll = ["  
    for dateIndex = 1:length(period)
        if (max(mintsDailyWidths)==mintsDailyWidths(dateIndex))
            evalString = strcat(evalString,"S{",string(dateIndex),"};");
        end
    end % Dates    
    evalString = strcat(evalString,"];");
    display(evalString);
    eval(evalString);
%     save(fileNameForAll,'mintsDataAll', '-v7.3');
    toc
    
end % Node ID



