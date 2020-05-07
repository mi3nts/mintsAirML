

%% Saving raw Mints Data as Daily Tables 
clc
clear all
close all 
% 
% addpath("../functions")

% Defining Node IDS 
display("--------MINTS--------")

nodeIDs   = {'001e0610c0e4',...
                 };
 
startDate  = datetime(2019,01,01) ;
endDate    = datetime(2020,05,01) ;
period     = startDate:endDate;

dataFolder       = "/media/teamlary/Team_Lary_2/air930/mintsData";
referenceDotMatsFolder = dataFolder + "/referenceMats";
timeStep  = seconds(30);
stringIn = "mintsDailyRetimed" +  string(timeStep);

fileNameIndex = 1;

for nodeIndex = 1: 1 %length(nodeIDs)

    mintsDailyCell   = cell(1,length(period));
    mintsDailyWidths = zeros(1,length(period));
     
    % Going through Each Date ;
    % Have An If to See 
    tic
    for dateIndex = 1:length(period)
        fileName  = getMintsFileNamesStr(period,dateIndex,referenceDotMatsFolder,...
                                                nodeIDs,nodeIndex,stringIn)
         display("Reading:"+fileName )
        if (isfile(fileName))
            mintsDailyRetimed            = load(fileName).mintsDailyRetimed;
            S{dateIndex}                 = mintsDailyRetimed;
            mintsDailyWidths(dateIndex)  = width(mintsDailyRetimed); 

        end % File Name Available
    end % Dates    
%     
    % Getting Eval String 
    evalString = " mintsDataAll = ["  
    for dateIndex = 1:length(period)
        if (max(mintsDailyWidths)==mintsDailyWidths(dateIndex))
            evalString = strcat(evalString,"S{",string(dateIndex),"};");
        end
    end % Dates   
%     
% 
    evalString = strcat(evalString,"];");
    display(evalString);
    eval(evalString);
    fileNameForAll = getMintsRangeNameStr(...
                        dateshift(mintsDataAll.dateTime(1), 'start', 'day'),...
                            dateshift(mintsDataAll.dateTime(end), 'start', 'day'),...
                                referenceDotMatsFolder,...
                                    nodeIDs,nodeIndex,...
                                        "deliverables/mintsDataAllRetimed_"+string(timeStep));


    save(fileNameForAll,'mintsDataAll');
%     
end % Node ID



