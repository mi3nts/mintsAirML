function mints = getCDTDailyDataForFW(givenDate,nodeID,mintsDotMats,dt)  
% GETDAILYDATAFORFW Summary of this function goes here
% Detailed explanation goes here

    startDate = givenDate ;
    endDate   = givenDate +days(1);
    
    GPSGPRMCPreTT = concatDotMatsMints(mintsDotMats,nodeID,"GPSGPRMC",startDate,endDate);
    GPSGPGGAPreTT = concatDotMatsMints(mintsDotMats,nodeID,"GPSGPGGA",startDate,endDate);
    OPCN3PreTT    = concatDotMatsMints(mintsDotMats,nodeID,"OPCN3",startDate,endDate);
    BME280PreTT   = concatDotMatsMints(mintsDotMats,nodeID,"BME280",startDate,endDate);
    LIBRADPreTT   = concatDotMatsMints(mintsDotMats,nodeID,"LIBRAD",startDate,endDate);
    MGS001PreTT   = concatDotMatsMints(mintsDotMats,nodeID,"MGS001",startDate,endDate);
    SCD30PreTT    = concatDotMatsMints(mintsDotMats,nodeID,"SCD30",startDate,endDate);
    TSL2591PreTT  = concatDotMatsMints(mintsDotMats,nodeID,"TSL2591",startDate,endDate);
    VEML6070PreTT = concatDotMatsMints(mintsDotMats,nodeID,"VEML6070",startDate,endDate);
    
    if(or(or(or(or(or(or(or(or(or(...
                                              isempty(GPSGPRMCPreTT),isempty(GPSGPGGAPreTT)...
                                          ),isempty(OPCN3PreTT)...
                                      ),isempty(BME280PreTT)...
                                  ),isempty(LIBRADPreTT)...
                              ),isempty(MGS001PreTT)...
                          ),isempty(MGS001PreTT)...         
                      ),isempty(SCD30PreTT)...
                 ),isempty(TSL2591PreTT)...  
             ),isempty(VEML6070PreTT)...
          )...
       )
   
   
       
    mints = []
    else

        GPSGPRMCTT = getCentralTime(table2timetable(GPSGPRMCPreTT),givenDate);
        GPSGPGGATT = getCentralTime(table2timetable(GPSGPGGAPreTT),givenDate);
        OPCN3TT    = getCentralTime(table2timetable(OPCN3PreTT),givenDate);
        BME280TT   = getCentralTime(table2timetable(BME280PreTT),givenDate);
        LIBRADTT   = getCentralTime(table2timetable(LIBRADPreTT),givenDate);
        MGS001TT   = getCentralTime(table2timetable(MGS001PreTT),givenDate);
        SCD30TT    = getCentralTime(table2timetable(SCD30PreTT),givenDate);
        TSL2591TT  = getCentralTime(table2timetable(TSL2591PreTT),givenDate);
        VEML6070TT = getCentralTime(table2timetable(VEML6070PreTT),givenDate);

        
    if(or(or(or(or(or(or(or(or(or(...
                                              isempty(GPSGPRMCTT),isempty(GPSGPGGATT)...
                                          ),isempty(OPCN3TT)...
                                      ),isempty(BME280TT)...
                                  ),isempty(LIBRADTT)...
                              ),isempty(MGS001TT)...
                          ),isempty(MGS001TT)...         
                      ),isempty(SCD30TT)...
                 ),isempty(TSL2591TT)...  
             ),isempty(VEML6070TT)...
          )...
       )
   
        mints = [];
    else
        
       %% Time Averaging Data
        GPSGPRMCRetime  =  retime(rmmissing(GPSGPRMCTT),'regular',@nanmean,'TimeStep',dt);
        GPSGPGGARetime  =  retime(rmmissing(GPSGPGGATT),'regular',@nanmean,'TimeStep',dt);
        OPCN3Retime     =  retime(rmmissing(OPCN3TT)   ,'regular',@nanmean,'TimeStep',dt);
        BME280Retime    =  retime(rmmissing(BME280TT)  ,'regular',@nanmean,'TimeStep',dt);
        LIBRADRetime    =  retime(rmmissing(LIBRADTT)  ,'regular',@nanmean,'TimeStep',dt);
        MGS001Retime    =  retime(rmmissing(MGS001TT)  ,'regular',@nanmean,'TimeStep',dt);
        SCD30Retime     =  retime(rmmissing(SCD30TT)   ,'regular',@nanmean,'TimeStep',dt);
        TSL2591Retime   =  retime(rmmissing(TSL2591TT) ,'regular',@nanmean,'TimeStep',dt);
        VEML6070Retime  =  retime(rmmissing(VEML6070TT),'regular',@nanmean,'TimeStep',dt);

        %% Synchrozing Data 
        mints =  rmmissing(synchronize(GPSGPRMCRetime,GPSGPGGARetime,'intersection'));
        mints =  rmmissing(synchronize(mints,OPCN3Retime,'intersection'));
        mints =  rmmissing(synchronize(mints,BME280Retime,'intersection'));
        mints =  rmmissing(synchronize(mints,LIBRADRetime,'intersection'));
        mints =  rmmissing(synchronize(mints,MGS001Retime,'intersection'));
        mints =  rmmissing(synchronize(mints,SCD30Retime,'intersection'));
        mints =  rmmissing(synchronize(mints,TSL2591Retime,'intersection'));
        mints =  rmmissing(synchronize(mints,VEML6070Retime,'intersection'));
        
        
    end
    end
    
end

