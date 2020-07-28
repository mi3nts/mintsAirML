
close all 
clearvars -except nodeIDMints dataFolderPre dataFolder nodeIDGrimm dataFolderGrimm mintsDotMats nodeID deliverablesFolder dtSteps dt dmSteps startDate endDate grimmDotMats mintsDotMats

%% Main2 - Save Mints Data 
% mints_DCCD_node_2_1_data_from_30-Apr-2019_to_30-Aug-2019_as_is_data_Node_001e06305a12
    eval(strcat("load('",deliverablesFolder,"/mints_DCCD_node_2_1_data_from_",string(startDate),"_to_",string(endDate),...
       "_as_is_data_Node_",nodeIDMints,"')"));

%% Time Averaging Data
   
    
    GPSGPRMCRetime  =  retime(rmmissing(GPSGPRMCTT0),'regular',@nanmean,'TimeStep',dt);
    GPSGPGGARetime  =  retime(rmmissing(GPSGPGGATT0),'regular',@nanmean,'TimeStep',dt);
    OPCN2Retime     =  retime(rmmissing(OPCN2TT)   ,'regular',@nanmean,'TimeStep',dt);
    BME280Retime    =  retime(rmmissing(BME280TT)  ,'regular',@nanmean,'TimeStep',dt);
    MGS001Retime    =  retime(rmmissing(MGS001TT)  ,'regular',@nanmean,'TimeStep',dt);



    %% Synchrozing Data 
    mints =  rmmissing(synchronize(GPSGPRMCRetime,GPSGPGGARetime,'intersection'));
    mints =  rmmissing(synchronize(mints,OPCN2Retime,'intersection'));
    mints =  rmmissing(synchronize(mints,BME280Retime,'intersection'));
    mints =  rmmissing(synchronize(mints,MGS001Retime,'intersection'));

eval(strcat("save('",deliverablesFolder,"/mints_node_2_2_for_AirMar_data_from_",string(startDate),"_to_",string(endDate),"_in_",...
       strrep(string(dt)," ","_"),"_averaged_slices_for_Node_",nodeID,"',",...
       "'mints','dt','startDate','endDate','nodeID')"))


   
   
   
