close all 
clearvars -except dataFolderPre dataFolder nodeIDGrimm dataFolderGrimm mintsDotMats nodeID deliverablesFolder dtSteps ...
    dt dmSteps startDate endDate grimmDotMats mintsDotMats nodeIDAirMar nodeIDMints

%% Syncing GRIMM Data With Mints Data

dt = seconds(10)
%% Loading AirMar Data 
% mints_AirMar_1_2_data_from_30-Apr-2019_to_30-Aug-2019_in_10_sec_averaged_slices_for_Node_001e0610c0e4
eval(strcat("load('",deliverablesFolder,"/mints_AirMar_1_2_data_from_",string(startDate),"_to_",string(endDate),"_in_",...
        strrep(string(dt)," ","_"),"_averaged_slices_for_Node_",nodeIDAirMar,"')"))

  mintsAirMar = mints;
%% Loading Node Data 
% mints_MINTS_node_2_2_1_data_from_30-Apr-2019_to_30-Aug-2019_in_10_sec_averaged_slices_for_Node_001e06305a12.mat
eval(strcat("load('",deliverablesFolder,"/mints_node_2_2_for_AirMar_data_from_",string(startDate),"_to_",string(endDate),"_in_",...
        strrep(string(dt)," ","_"),"_averaged_slices_for_Node_",nodeIDMints,"')"))
    
%% Syncronizing Data  
 
mintsAll =  rmmissing(synchronize(mints,mintsAirMar,'intersection'));
 
fileNameIn  = strcat("mints_DCCD_3_1_from_",string(startDate),"_to_",string(endDate),"_in_",strrep(string(dt)," ","_"),"_Slices_Node_",nodeID)
saveAllData(deliverablesFolder,fileNameIn)

dt = seconds(30);

mintsRetimed = retime(rmmissing(mintsAll)  ,'regular',@nanmean,'TimeStep',dt);

eval(strcat("save('",deliverablesFolder,"/mints_node_3_2_Air_Mar_data_from_",string(startDate),"_to_",string(endDate),"_in_",...
       strrep(string(dt)," ","_"),"_averaged_slices_for_Node_",nodeID,"',",...
       "'mintsRetimed','dt','startDate','endDate','nodeID')"));
%    
% 
% 
% 
% for n=2:length(dtSteps)
%     tic
%         dt = dtSteps(n)
% 
%         %% Time Averaging Data
%         mints     =  retime(rmmissing(mintsAll)   ,'regular',@nanmean,'TimeStep',dt);
%         eval(strcat("save('",deliverablesFolder,"/mints_node_3_2_data_from_",string(startDate),"_to_",string(endDate),"_in_",...
%         strrep(string(dt)," ","_"),"_averaged_slices_for_Node_",nodeID,"',",...
%         "'mints','dt','startDate','endDate','nodeID')"))
% 
%         clear mints
%     toc
%     
% end
