function [palasAir,palasWeather] = importPalasData(filename)

% If dataLines is not specified, define defaults
% If dataLines is not specified, define defaults
dataLines = [20, Inf];


%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 23);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ["\t", " ", " - ", ",", ";"];

% Specify column names and types
opts.VariableNames = ["Title", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23"];
opts.SelectedVariableNames = ["Title", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17"];
opts.VariableTypes = ["datetime", "datetime", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "datetime", "datetime", "categorical", "double", "double", "double", "string", "string", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";

% Specify variable properties
opts = setvaropts(opts, ["Var18", "Var19", "Var20", "Var21", "Var22", "Var23"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["VarName3", "VarName14", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Title", "InputFormat", "MM/dd/yyyy");
opts = setvaropts(opts, "VarName2", "InputFormat", "HH:mm:ss");
opts = setvaropts(opts, "VarName12", "InputFormat", "MM/dd/yyyy");
opts = setvaropts(opts, "VarName13", "InputFormat", "HH:mm:ss");

% Import the data
preTable  = readtable(filename, opts);

dateTimePMPre = strcat(string(preTable.Title),"~",string(preTable.VarName2),"!", string(preTable.VarName3));
dateTimeWeatherPre = strcat(string(preTable.VarName12),"~",string(preTable.VarName13),"!", string(preTable.VarName14));

dateTimePM = datetime(dateTimePMPre,'InputFormat','MM/dd/yyyy~h:mm:ss!a','TimeZone','UTC');
dateTimeWeather = datetime(dateTimeWeatherPre,'InputFormat','MM/dd/yyyy~h:mm:ss!a','TimeZone','UTC');


palasAir     = [table(dateTimePM),preTable(:,4:11)];
palasWeather = [table(dateTimeWeather),preTable(:,15:end)] ;

palasAir.Properties.VariableNames     = [{'dateTime'} {'pm1_PALAS'} {'pm2_5_palas'} {'pm4_palas'} {'pm10_palas'} {'pmTotal_palas'} {'dCn_palas'} {'latitude_palas'} {'longitude_palas'}];
palasWeather.Properties.VariableNames = [{'dateTime'} {'temperature_palas'} {'humidity_palas'} {'pressure_palas'}];


end