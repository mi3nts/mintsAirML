 function mintsData= getAirMarWIMDA(fileName)
  
    %% Arranging dateTime
        mintsData          = readtable(fileName);
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.BPMUnits=[];
        mintsData.BPBUnits=[];
        mintsData.ATUnits=[];
        mintsData.waterTemperature=[];
        mintsData.WTUnits=[];
        mintsData.absoluteHumidity=[];
        mintsData.DPUnits=[];
        mintsData.WDMUnits=[];
        mintsData.windSpeedKnots=[];
        mintsData.windDirectionTrue=[];
        mintsData.windDirectionMagnetic=[];
        mintsData.WDTUnits=[];
        mintsData.WSKUnits=[];
        mintsData.windSpeedMetersPerSecond=[];
        mintsData.WSMPSUnits=[]; 
        mintsData.checkSum=[];


end
        