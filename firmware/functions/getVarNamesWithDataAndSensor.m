function [dS,sensor] = getVarNamesWithDataAndSensor(dS)
preNames    = dS.mintsData.VariableNames;
file        = strsplit(dS(1).mintsData.Files{1},'_');
sensor      = string(file(end-3));
names       = preNames +"_" + sensor;
names(1)    = "dateTime";
dS.mintsData.VariableNames = names;
end

