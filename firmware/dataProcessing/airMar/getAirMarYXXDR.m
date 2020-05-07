function mintsData= getAirMarYXXDR(fileName)
  
    %% Arranging dateTime
%       mintsData          = readtable('MINTS_001e0610c0e4_YXXDR_2019_02_12.csv');
        mintsData          = readtable(fileName);
        mintsData.dateTime = datetime(mintsData.dateTime, 'Format','yyyy-MM-dd HH:mm:ss.SSSSSS','TimeZone','UTC');
        
        mintsData.TUnits=[];
        mintsData.RWCTID=[];
        mintsData.RWCTUnits=[];
        mintsData.theoreticalWindChillTemperature=[];
        mintsData.TUnits2=[];
        mintsData.TWCTUnits =[];
        mintsData.relativeWindChillTemperature=[];
        mintsData.TWCTID=[];
        mintsData.HIUnits =[];
        mintsData.temperature =[];     
        mintsData.heatIndex=[];
        mintsData.HIID=[];
        mintsData.pressureUnits=[];
        mintsData.BPBUnits=[];
        mintsData.BPBID =[];
        
        mintsData.checkSum=[];
  
end