function [] = saveAllPalas(dotMatsFolder,palasFolder)
%SAVEALLGRIM Summary of this function goes here
%   Detailed explanation goes here
palasDataAll    = dir(palasFolder)

palasDataTable  = struct2table(palasDataAll);
palasDataWanted = palasDataTable(endsWith(palasDataTable.name,'-.txt'),:);

palasDataFiles    = string(cell2mat(palasDataWanted.folder)) +"/"+ string(cell2mat(palasDataWanted.name));

saveNamesAirPre          = string(cell2mat(palasDataWanted.folder)) +"/"+ strrep(string(cell2mat(palasDataWanted.name)),".txt","Air.mat")
saveNamesWeatherPre      = string(cell2mat(palasDataWanted.folder)) +"/"+ strrep(string(cell2mat(palasDataWanted.name)),".txt","Weather.mat")

saveNamesAirDotMat       = strrep(saveNamesAirPre, palasFolder,dotMatsFolder);
saveNamesWeatherDotMat   = strrep(saveNamesWeatherPre, palasFolder,dotMatsFolder);

%% Create Dot Mat Files  
    for n =1 :length(palasDataFiles)
        palasAir,palasWeather = saveGrimmDaily(palasDataFiles(n))
        mkdir(fileparts(saveNamesAirDotMat(n)));
        save(char(saveNamesAirDotMat(n)),'palasAir');
        save(char(saveNamesWeatherDotMat(n)),'palasWeather');
        clear palasData
    end
    
end

