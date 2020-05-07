function mintsData= getAirMarGPVTG(fileName)
  
%     %% Arranging dateTime
        mintsData          = readtable(fileName);
        mintsData(isnan(mintsData.courseOGTrue),:) = [];
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        mintsData.relativeToTN=[];
        mintsData.relativeToMN=[];
        mintsData.SOGKUnits=[];
        mintsData.SOGKMPHUnits=[];
        mintsData.mode=[];
        mintsData.checkSum=[];
  
end
        