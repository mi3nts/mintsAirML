function mintsData= getMintsSensorDataUpdate_1(filename,sensor)
    
    delimiter     = ',';
    startRow      = 2;
    formatSpec    = '%s%[^\n\r]';
    fileID        = fopen(filename,'r');
    dataArray     = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    dateTime      = table(dataArray{1:end-1}, 'VariableNames', {'dateTime'});
    data          = dlmread(filename,',',1,1);
    fid           = fopen(filename, 'r');
    firstline     = string(fgetl(fid));
    fclose(fid);
    headers       = strsplit(firstline,',') +"_"+sensor;
    mintsData     =[array2table(datetime(dateTime.dateTime)),array2table(data)];

    mintsData.Properties.VariableNames = strrep(headers," ","");
    mintsData.Properties.VariableNames(1) = "dateTime";
    mintsData.dateTime.TimeZone = "utc";
    
end