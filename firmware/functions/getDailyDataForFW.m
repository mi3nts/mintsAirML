function mints = getDailyDataForFW(givenDate,nodeID,mintsDotMats,dt)  
% GETDAILYDATAFORFW Summary of this function goes here
% Detailed explanation goes here

    startDate = givenDate;
    endDate   = givenDate;
    
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
   isempty(OPCN3PreTT)
    else

        GPSGPRMCTT = table2timetable(GPSGPRMCPreTT);
        GPSGPGGATT = table2timetable(GPSGPGGAPreTT);
        OPCN3TT    = table2timetable(OPCN3PreTT);
        BME280TT   = table2timetable(BME280PreTT);
        LIBRADTT   = table2timetable(LIBRADPreTT);
        MGS001TT   = table2timetable(MGS001PreTT);
        SCD30TT    = table2timetable(SCD30PreTT);
        TSL2591TT  = table2timetable(TSL2591PreTT);
        VEML6070TT = table2timetable(VEML6070PreTT);


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

