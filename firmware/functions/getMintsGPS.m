clc
clear all 
close all
%% Initialize variables.
filename = '/media/teamlary/Team_Lary_1/gitGubRepos/Lakitha/mintsDataAnalysis/centralNode/MINTS_001e06323a06_GPSGPGGA_2019_02_10.csv';
delimiter = ',';
startRow = 2;

formatSpec = '%s%{HH:mm:ss}D%f%C%f%C%f%f%f%f%C%f%C%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);
mintsData= table(dataArray{1:end-1}, 'VariableNames', {'dateTime','timestamp','latitude','latitudeDirection','longitude','longitudeDirection','gpsQuality','numberOfSatellites','HorizontalDilution','altitude','altitudeUnits','undulation','undulationUnits','age','stationID'});

% 
% mintsData.Properties.VariableNames = strrep(headers," ","");

mintsData.dateTime = datetime(mintsData.dateTime) ;
mintsData.dateTime.TimeZone = "utc";
digits = 5 
% mintsData.longitude(mintsData.longitudeDirection=="W") = -1*vpa(mintsData.longitude(mintsData.longitudeDirection=="W")); 
% mintsData.latitude(mintsData.latitudeDirection=="S") = -1*vpa(mintsData.latitude(mintsData.latitudeDirection=="S")); 
% digits = 7 


for n  =1:100
mintsDataPre= strsplit(string(vpa(mintsData.longitude(n))),".");
mintsDataPreHC = char(mintsDataPre(1));
mintsDataPreSC = char(mintsDataPre(2));
% 
mintsDataLatHours(n,:) = str2num(string(mintsDataPreHC(1:end-2)));
mintsDataLatSecs(n,:) =string(str2num(string(strcat(mintsDataPreHC(end-1:end),mintsDataPreSC(1:5))))/60);

end


clearvars filename delimiter startRow formatSpec fileID dataArray ans;