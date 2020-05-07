function mintsData= getMintsGPSGPRMC(filename)

opts = delimitedTextImportOptions("NumVariables", 12);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["dateTime", "timestamp", "status", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "speedOverGround", "trueCourse", "dateStamp", "magVariation", "magVariationDirection"];
opts.VariableTypes = ["string", "datetime", "categorical", "double", "categorical", "double", "categorical", "double", "double", "datetime", "string", "string"];
opts = setvaropts(opts, 2, "InputFormat", "HH:mm:ss");
opts = setvaropts(opts, 10, "InputFormat", "yyyy-MM-dd");
opts = setvaropts(opts, [1, 11, 12], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 3, 5, 7, 11, 12], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
mintsData = readtable(filename, opts);


%% Clear temporary variables
clear opts

mintsData.dateTime =   datetime(mintsData.dateTime, 'InputFormat','yyyy-MM-dd HH:mm:ss.SSSSSS' );
mintsData.dateTime.TimeZone = "utc";
mintsData.latitude  =    getLatitudeUSBGPS(mintsData.latitude,mintsData.latitudeDirection);
mintsData.longitude    = getLongitudeUSBGPS(mintsData.longitude,mintsData.longitudeDirection);

mintsData(:,'latitudeDirection') = [];
mintsData(:,'longitudeDirection') = [];
mintsData(:,'status') = [];
mintsData(:,'trueCourse') = [];
mintsData(:,'dateStamp') = [];
mintsData(:,'timestamp') = [];
mintsData(:,'magVariation') = [];
mintsData(:,'magVariationDirection') = [];

