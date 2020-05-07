 function mintsData= getAirMarWIMWV(fileName)
  
    % Arranging dateTime
        mintsData          = readtable(fileName);
%         mintsData          = readtable('MINTS_001e0610c0e4_WIMWV_2019_02_12.csv');
        mintsData(isnan(mintsData.windAngle),:) = [];
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.WAReference=[];
        mintsData.WSUnits=[];
        mintsData.status=[];
        mintsData.checkSum=[];


end
        