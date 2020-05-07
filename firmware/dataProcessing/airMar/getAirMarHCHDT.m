function mintsData= getAirMarHCHDT(fileName)
  
    %% Arranging dateTime
        mintsData          = readtable(fileName);
%         mintsData          = readtable('MINTS_001e0610c0e4_HCHDT_2019_02_12.csv');
        mintsData(isnan(mintsData.heading),:) = [];
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.HID=[];
        mintsData.checkSum=[];
  
end
        