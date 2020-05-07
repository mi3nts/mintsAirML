function mintsData= getAirMarGPGGA(fileName)
  
    %% Arranging dateTime
        mintsData          = readtable(fileName);
        mintsData(isnan(mintsData.gpsQuality),:) = [];
        mintsData(mintsData.gpsQuality==0,:)     = [];
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.longitude =  getLongitude(mintsData.longitude,mintsData.lonDirection);
        mintsData.latitude  =  getLatitude(mintsData.latitude,mintsData.latDirection);
        mintsData.latDirection=[];
        mintsData.lonDirection=[];
        mintsData.AUnits=[];
        mintsData.GSUnits=[];
        mintsData.ageOfDifferential=[];
        mintsData.stationID=[];
        mintsData.checkSum=[];
  
end