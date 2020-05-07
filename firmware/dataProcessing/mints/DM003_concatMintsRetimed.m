

%% Saving raw Mints Data as Daily Tables 
clc
clear all
close all 
% 
% addpath("../functions")

% Defining Node IDS 
display("--------MINTS--------")

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
 

 
startDate  = datetime(2019,01,01);
endDate    = datetime(2020,04,25) ;

period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
rawFolder        = dataFolder + "/raw";
rawDotMatsFolder = dataFolder + "/rawMats";

stringIn = "mintsDailyRetimed";
fileNameIndex = 1;

for nodeIndex = 1: length(nodeIDs)
   mintsDailyCell   = cell(1,length(period));
   mintsDailyWidths = zeros(1,length(period));
     
    % Going through Each Date ;
    fileNameForAll = getMintsRangeNameStr(startDate,endDate,rawDotMatsFolder,...
                        nodeIDs,nodeIndex,"deliverables/mintsDataAllRetimed");
    % Have An If to See 
    tic
    parfor dateIndex = 1:length(period)
        fileName  = getMintsFileNamesStr(period,dateIndex,rawDotMatsFolder,...
                                                nodeIDs,nodeIndex,stringIn);
        display("Reading:"+fileName )
        if (isfile(fileName))
            mintsDailyRetimed            = load(fileName).mintsDailyRetimed;
            S{dateIndex}                 = mintsDailyRetimed;
            mintsDailyWidths(dateIndex)  = width(mintsDailyRetimed);        
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



