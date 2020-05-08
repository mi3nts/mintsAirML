function [] = printLatestJSON(latestData,nodeFolder)
%PRINTLATESTJSON Summary of this function goes here
%   Detailed explanation goes here
% tableIn = timetable2table(latestData);
% fid = fopen(nodeFolder+'/latestData.json','wt');
% lklk = struct("entries",latestData)
% fprintf(fid,struct("entries",erase(erase(jsonencode(struct("entries",table2struct(latestData))),"["),"]")));
% fclose(fid);
% lklklkl = struct("entries",table2struct(latestData))
fid = fopen(nodeFolder+'/latestData.json','wt');
fprintf(fid, jsonencode(struct("entries",table2struct(latestData))));

fclose(fid);
% saveJSONfile(struct("entries",table2struct(latestData)),nodeFolder+'/latestData.json')
end

