
function [] = saveAllGrimmCounts(dataFolder,parentFolder,startDate,endDate)
%SAVEALLGRIM Summary of this function goes here
%   Detailed explanation goes here


datesAll = startDate:days(1):endDate ;

    for n =1 : length(datesAll)
        currentDate =  datesAll(n);
        checkSet(n) = strcat(num2str(year(currentDate),'%02d'),"-",...
                         num2str(month(currentDate),'%02d'),"-",...
                         num2str(day(currentDate),'%02d')...
                         );

    end

dotMatFolder    = parentFolder + "/dotMats";
grimmDataFolder = dataFolder + "/GRIMM";
grimmDataAll    = dir(grimmDataFolder)

grimmDataTable  = struct2table(grimmDataAll)
grimmDataWanted = grimmDataTable(endsWith(grimmDataTable.name,'-C.dat'),:);

grimmDataFiles    = string(cell2mat(grimmDataWanted.folder)) +"/"+ string(cell2mat(grimmDataWanted.name));
saveNamesPre      = string(cell2mat(grimmDataWanted.folder)) +"/"+ strrep(string(cell2mat(grimmDataWanted.name)),"dat","mat");
saveNamesDotMat   = strrep(saveNamesPre ,parentFolder, dotMatFolder);
  

wantedI= contains(grimmDataFiles,checkSet);



%% Create Dot Mat Files  
    for n =1 :length(grimmDataFiles)
        if(wantedI(n))
                grimmCountsData = saveGrimmCountsDaily(grimmDataFiles(n));
                grimmCountsData.Properties.VariableNames = {'dateTime',...
                    'bd_0_25_um_grimm','bd_0_28_um_grimm','bd_0_30_um_grimm','bd_0_35_um_grimm','bd_0_40_um_grimm',...
                    'bd_0_45_um_grimm','bd_0_50_um_grimm','bd_0_58_um_grimm','bd_0_65_um_grimm','bd_0_70_um_grimm',...
                    'bd_0_80_um_grimm','bd_1_00_um_grimm','bd_1_30_um_grimm','bd_1_60_um_grimm','bd_2_00_um_grimm',...
                    'bd_2_50_um_grimm','bd_3_00_um_grimm','bd_3_50_um_grimm','bd_4_00_um_grimm','bd_5_00_um_grimm',...
                    'bd_6_50_um_grimm','bd_7_50_um_grimm','bd_8_50_um_grimm','bd_10_00_um_grimm','bd_12_50_um_grimm',...
                    'bd_15_00_um_grimm','bd_17_50_um_grimm','bd_20_00_um_grimm','bd_25_00_um_grimm','bd_30_00_um_grimm',...
                    'bd_32_00_um_grimm'...
                   }; 

                grimmCountsData.dateTime = datetime(grimmCountsData.dateTime, 'Format','MM/dd/yyyy hh:mm:ss Z','TimeZone','UTC');
                mkdir(fileparts(saveNamesDotMat(n)));
                save(char(saveNamesDotMat(n)),'grimmCountsData');
                clear  grimmCountsData
        end
    end
    
end
