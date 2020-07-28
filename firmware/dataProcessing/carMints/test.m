% 
% 
% 
% 
% %% Saving raw Mints Data as Daily Tables 
% 
% % Defining Node IDS 
% % Defining Node IDS 
% display("--------MINTS--------")
% addpath("../../functions/")
% 
% nodeIDs   = {...
%                 '001e0610c2e7',...
%                     };
%  
% startDate  = datetime(2018,04,01) ;
% endDate    = datetime(2020,08,01) ;
% 
% period     = startDate:endDate;
% 
% dataFolder             = "/media/teamlary/Team_Lary_2/carMints";
% rawFolder              = dataFolder + "/raw";
% rawDotMatsFolder       = rawFolder + "/rawDotMats";
% referenceFolder        = dataFolder + "/reference";
% referenceDotMatsFolder = rawFolder + "/referenceDotMats";

% clear;clc;close all

sensor_id='001e0610c2e7';
base_dir='/media/teamlary/Team_Lary_2/carMints/reference/';
end_string='.csv';

% sensor_id_airmar='001e0610c2e9';
% base_dir_airmar='/Volumes/MINTSNASCAR/reference/';

iprint=1;
imovingaverage=0;

current_dir=[base_dir sensor_id '/*/*/*/'];
disp(current_dir)
end_string=['.csv'];

% set up a mask that defines the files we want to read in
fn_mask_gps=[current_dir 'MINTS_' sensor_id '_GPSGPGGA*' end_string];
disp(fn_mask_gps)
gps=table2timetable(sortrows(unique(gather(tall(datastore(fn_mask_gps))))));    

% 
% current_dir=[base_dir sensor_id '/*/*/*/'];
% disp(current_dir)
% end_string=['.csv'];
% 
% % set up a mask that defines the files we want to read in
% fn_mask_gps=[current_dir 'MINTS_' sensor_id '_GPSGPGGA*' end_string];
% disp(fn_mask_gps)
% gps=table2timetable(sortrows(unique(gather(tall(datastore(fn_mask_gps))))));    



