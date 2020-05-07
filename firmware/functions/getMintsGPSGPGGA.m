function mintsData= getMintsGPSGPGGA(filename)

%% Setup the Import Options
opts = delimitedTextImportOptions("NumVariables", 15);
% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
% Specify column names and types
opts.VariableNames = ["dateTime", "timestamp", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "gpsQuality", "numberOfSatellites", "HorizontalDilution", "altitude", "altitudeUnits", "undulation", "undulationUnits", "age", "stationID"];
opts.VariableTypes = ["string", "datetime", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "categorical", "double", "categorical", "string", "double"];
opts = setvaropts(opts, 2, "InputFormat", "HH:mm:ss");
opts = setvaropts(opts, [1, 14], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 4, 6, 11, 13, 14], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
mintsData= readtable(filename,opts);
clear opts;
mintsData.dateTime =   datetime(mintsData.dateTime, 'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS' );
mintsData.dateTime.TimeZone = "utc";

mintsData.latitude  =    getLatitudeUSBGPS(mintsData.latitude,mintsData.latitudeDirection)
mintsData.longitude    = getLongitudeUSBGPS(mintsData.longitude,mintsData.longitudeDirection)

mintsData(:,'latitudeDirection') = [];
mintsData(:,'longitudeDirection') = [];
mintsData(:,'altitudeUnits') = [];
mintsData(:,'undulationUnits') = [];
mintsData(:,'age') = [];
mintsData(:,'timestamp') = [];

end
