
function [] = saveGrimmDates(dataFolder,parentFolder,startDate,endDate)
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

dotMatFolder    = parentFolder + "/dotMats"
grimmDataFolder = dataFolder + "/GRIMM"
grimmDataAll    = dir(grimmDataFolder);

grimmDataTable  = struct2table(grimmDataAll);
grimmDataWanted = grimmDataTable(endsWith(grimmDataTable.name,'-M.dat'),:);

grimmDataFiles    = string(cell2mat(grimmDataWanted.folder)) +"/"+ string(cell2mat(grimmDataWanted.name));

wantedI= contains(grimmDataFiles,checkSet);

saveNamesPre      = string(cell2mat(grimmDataWanted.folder)) +"/"+ strrep(string(cell2mat(grimmDataWanted.name)),"dat","mat");
saveNamesDotMat   = strrep(saveNamesPre, parentFolder,dotMatFolder);



% Create Dot Mat Files  
    for n =1 :length(grimmDataFiles)
        if(wantedI(n))
            saveNamesDotMat(n);
            grimmData = saveGrimmDaily(grimmDataFiles(n));
            grimmData.Properties.VariableNames = {'dateTime','pm10_grimm','pm2_5_grimm','pm1_grimm','inhalable_grimm','thoracic_grimm','alveolic_grimm'}   ;
            grimmData.dateTime = datetime(grimmData.dateTime, 'Format','MM/dd/yyyy hh:mm:ss Z','TimeZone','UTC');
            mkdir(fileparts(saveNamesDotMat(n)));
            save(char(saveNamesDotMat(n)),'grimmData');
            clear grimmData
        end
    end
    
end

