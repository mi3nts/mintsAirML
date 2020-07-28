function sensor = getSensorName(fileNameRaw,fromEnd)
    
    splits = strsplit(fileNameRaw,'_');
    sensor = splits(end - fromEnd);
    ;
end

