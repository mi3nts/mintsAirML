close all 
clearvars -except dataFolderPre dataFolder nodeIDGrimm dataFolderGrimm mintsDotMats nodeID deliverablesFolder dtSteps dt dmSteps startDate endDate grimmDotMats mintsDotMats

%% Main1 - Save GRIMM Data 

% Collecting and Saving GRIMM Time Tables 

saveGrimmDates(dataFolderGrimm,dataFolderPre,startDate,endDate);
saveGrimmCountsDates(dataFolderGrimm,dataFolderPre,startDate,endDate);

grimmTT          =  table2timetable(concatDotMatsGrimm(grimmDotMats,startDate,endDate));
grimmCountsTT    =  table2timetable(concatDotMatsGrimmCounts(grimmDotMats,startDate,endDate));

GRIMMRetime       =  retime(rmmissing(grimmTT) ,'regular',@nanmean,'TimeStep',dt);
GRIMMCountsRetime =  retime(rmmissing(grimmCountsTT),'regular',@nanmean,'TimeStep',dt);

mintsGrimm =  rmmissing(synchronize(GRIMMRetime,GRIMMCountsRetime,'intersection'));

fileNameIn  = strcat("mintsFW_1_1_from_",string(startDate),"_to_",string(endDate),"_in_",strrep(string(dt)," ","_"),"_Slices_Node_",nodeID)

saveAllData(deliverablesFolder,fileNameIn)

eval(strcat("save('",deliverablesFolder,"/mints_node_1_2_data_from_",string(startDate),"_to_",string(endDate),"_in_",...
       strrep(string(dt)," ","_"),"_averaged_slices_for_Node_",nodeIDGrimm,"',",...
       "'mintsGrimm','dt','startDate','endDate','nodeID')"))

