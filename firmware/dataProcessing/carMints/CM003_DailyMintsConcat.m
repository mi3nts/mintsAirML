

%% Saving raw Mints Data as Daily Tables 
clc
clear all
close all 
% 
% addpath("../functions")

% Defining Node IDS 
display("--------MINTS--------")

nodeIDs   = {...
 '001e0610c2e7',...
    };
 

 
startDate  = datetime(2020,07,01);
endDate    = datetime(2020,08,01) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/carMints";
rawFolder        = dataFolder + "/reference";
rawDotMatsFolder = dataFolder + "/referenceMats";

stringIn = "gpsMintsRetimed";
fileNameIndex = 1;

for nodeIndex = 1: length(nodeIDs)
   mintsDailyCell   = cell(1,length(period));
   mintsDailyWidths = zeros(1,length(period));
     
    % Going through Each Date ;
    fileNameForAll = getMintsRangeNameStr(startDate,endDate,rawDotMatsFolder,...
                        nodeIDs,nodeIndex,"deliverables/gpsMintsRetimed")
    % Have An If to See 
    tic
    for dateIndex = 1:length(period)
        fileName  = getMintsFileNamesStr(period,dateIndex,rawDotMatsFolder,...
                                                nodeIDs,nodeIndex,stringIn);
        display("Reading:"+fileName )
        if (isfile(fileName))
            gpsMintsRetimed            = load(fileName).mintsDailyRetimed;
            S{dateIndex}                 = gpsMintsRetimed;
            mintsDailyWidths(dateIndex)  = width(gpsMintsRetimed);        
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
    save(fileNameForAll,'mintsDataAll');
    
end % Node ID

