

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
        '001e063239e6',...
        '001e06305a0a',...
        '001e06318cee',...
        '001e06318cf1',...
        '001e063059c1'...
    };
 

 
startDate  = datetime(2018,01,01);
endDate    = datetime(2020,07,20) ;

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
    for dateIndex = 1:length(period)
        fileName  = getMintsFileNamesStr(period,dateIndex,rawDotMatsFolder,...
                                                nodeIDs,nodeIndex,stringIn);
        display("Reading:"+fileName )
        if (isfile(fileName))
            mintsDailyRetimed            = load(fileName).mintsDailyRetimed;
%             Delete Variables Here 
%             Just for 5a12  
               if nodeIDs{nodeIndex} == '001e06305a12' 
                    if(width(mintsDailyRetimed) ==100)
                        mintsDailyRetimed  = ...
                                        removevars(mintsDailyRetimed ,...
                                            {'sampleTimeSeconds_PPD42NSDuo',...
                                            'LPOPmMid_PPD42NSDuo'          ,...
                                            'LPOPm10_PPD42NSDuo'           ,...
                                            'ratioPmMid_PPD42NSDuo'        ,...
                                            'ratioPm10_PPD42NSDuo'         ,...
                                            'concentrationPmMid_PPD42NSDuo',...
                                            'concentrationPm2_5_PPD42NSDuo',...
                                            'concentrationPm10_PPD42NSDuo' ...
                                            }...
                                        );
                    end
                    if(width(mintsDailyRetimed) ==99)
                        mintsDailyRetimed  = ...
                                        removevars(mintsDailyRetimed ,...
                                            {'LPOPmMid_PPD42NSDuo'         ,...	
                                            'LPOPm10_PPD42NSDuo'           ,...	
                                            'ratioPmMid_PPD42NSDuo'        ,...
                                            'ratioPm10_PPD42NSDuo'         ,...
                                            'concentrationPmMid_PPD42NSDuo',...
                                            'concentrationPm2_5_PPD42NSDuo',...
                                            'concentrationPm10_PPD42NSDuo' ,...
                                            }...
                                        );
                    end                                    
             end
            S{dateIndex}                 = mintsDailyRetimed;
            mintsDailyWidths(dateIndex)  = width(mintsDailyRetimed);        
        end % File Name Available
    end % Dates    
    
    % Getting Eval String 
    evalString = " mintsDataAll = ["  ;
    if nodeIDs{nodeIndex} == '001e06305a12' 
        for dateIndex = 1:length(period)
            if (max(mintsDailyWidths)==mintsDailyWidths(dateIndex))
                    S{1,dateIndex}.Properties.VariableNames = S{end}.Properties.VariableNames;
                    evalString = strcat(evalString,"S{",string(dateIndex),"};");
                
            end
        end % Dates  
    else
        for dateIndex = 1:length(period)
            if (max(mintsDailyWidths)==mintsDailyWidths(dateIndex))
                evalString = strcat(evalString,"S{",string(dateIndex),"};");
            end
        end % Dates   
    end
   
    evalString = strcat(evalString,"];");
    display(evalString);
    eval(evalString);
    save(fileNameForAll,'mintsDataAll');
    
end % Node ID



