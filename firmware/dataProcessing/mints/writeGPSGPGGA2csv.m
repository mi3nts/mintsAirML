function [] = writeGPSGPGGA2csv(fileName)
%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 15);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["dateTime", "timestamp", "latitude", "latitudeDirection", "longitude", "longitudeDirection", "gpsQuality", "numberOfSatellites", "HorizontalDilution", "altitude", "altitudeUnits", "undulation", "undulationUnits", "age", "stationID"];
opts.VariableTypes = ["datetime", "datetime", "double", "categorical", "double", "categorical", "double", "double", "double", "double", "categorical", "double", "categorical", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["age", "stationID"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["latitudeDirection", "longitudeDirection", "altitudeUnits", "undulationUnits", "age", "stationID"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "dateTime", "InputFormat", "yyyy-MM-dd HH:mm:ss.SSS");
opts = setvaropts(opts, "timestamp", "InputFormat", "HH:mm:ss");

% Import the data
lk2 = readtable(fileName, opts);

filenameNew = strrep(fileName,"_GPSGPGGA_","_GPSGPGGA2_")
latitudeCoordinate   =  getLatitudeAirMar(lk2.latitude,cellstr(lk2.latitudeDirection));
longitudeCoordinate  =  getLongitudeAirMar(lk2.longitude,cellstr(lk2.longitudeDirection));


lk2.latitudeCoordinate   = latitudeCoordinate;
lk2.longitudeCoordinate  = longitudeCoordinate;


labels ={...
            'dateTime'           ,
            'timestamp'          ,
            'latitudeCoordinate' ,
            'longitudeCoordinate',
            'latitude'           ,
            'latitudeDirection'  ,
            'longitude'          ,
            'longitudeDirection' ,
            'gpsQuality'         ,
            'numberOfSatellites' ,
            'HorizontalDilution' ,
            'altitude'           ,
            'altitudeUnits'      ,
            'undulation'         ,
            'undulationUnits'    ,
            'age'                ,
            'stationID'          };

        
writetable(lk2(:,labels),filenameNew)


end

