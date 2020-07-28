% This Branch comes from Car Mints Data

%% From Xu4 Car - Air Mar Data 
% From this we need to have a comprehensive GPS Database of just Latitude
% and Logitude 
% Delete Data from June 29th 
% Till January 2020 - The car wasnt  moving 

clc
clear all
close all

load('/media/teamlary/Team_Lary_2/carMints/referenceMats/001e0610c2e9/deliverables/mintsDataAllRetimed_30 sec_001e0610c2e9_2020_01_07_to_2020_06_27.mat')
airMarData = mintsDataAll;

load('/media/teamlary/Team_Lary_2/carMints/referenceMats/001e0610c2e7/deliverables/gpsMintsRetimed_001e0610c2e7_2019_01_01_to_2020_08_01.mat')
carGPSData = mintsDataAll(~isnan(mintsDataAll.latitude_currentDataRetimed),:);

clear mintsDataAll

load('/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/concat/palasFinalJuly2020.mat')

palasData = palasDataNow;
clear palasDataNow;



%% Pre Car GPS  
dateTime = datetime(2019,04,1,'timezone','utc'):seconds(30):datetime(2019,11,25,'timezone','utc');
preCarLatitude    = ones([length(dateTime),1])*32.992179;
preCarLongitude   = ones([length(dateTime),1])*-96.757777;
preCarGPS = timetable(dateTime',preCarLatitude,preCarLongitude);
preCarGPS.Properties.VariableNames = {'latitude','longitude'};

preCarPalasWithGPS =  rmmissing(synchronize(palasData,preCarGPS,'intersection'));

%% With Car GPS 
airMarGPS  = timetable(airMarData.dateTime,...
                         airMarData.latitude_GPGGA,...
                           airMarData.longitude_GPGGA);

airMarGPS.Properties.DimensionNames{1} = 'dateTime'; 
airMarGPS.Properties.VariableNames = {'latitude','longitude'};
airMarGPS.dateTime.TimeZone="utc"  ; 
 
odroidGPS  = timetable(carGPSData.dateTime,...
                         (carGPSData.latitudeCoordinate_currentDataRetimed+ carGPSData.latitudeCoordinate_mintsDailyRetimed)/2,...
                           (carGPSData.longitudeCoordinate_currentDataRetimed+carGPSData.longitudeCoordinate_mintsDailyRetimed)/2);
 
 
odroidGPS.Properties.DimensionNames{1} = 'dateTime';
odroidGPS.Properties.VariableNames = {'latitude','longitude'};
odroidGPS.dateTime.TimeZone="utc"  ; 
withCarGPS = [odroidGPS;airMarGPS]; 

%% PostCarGPS1 
dateTime = datetime(2020,06,27,'timezone','utc'):seconds(30):datetime(2020,06,28,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS1 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS1.Properties.VariableNames = {'latitude','longitude'};


%% PostCarGPS2 - Skipping Server Transport 
dateTime = datetime(2020,06,30,'timezone','utc'):seconds(30):datetime(2020,08,01,'timezone','utc');
postCarLatitude    = ones([length(dateTime),1])*32.992179;
postCarLongitude   = ones([length(dateTime),1])*-96.757777;
postCarGPS2 = timetable(dateTime',postCarLatitude,postCarLongitude);
postCarGPS2.Properties.VariableNames = {'latitude','longitude'};

%% Merging With Palas Data 
preCarPalasWithGPS   = rmmissing(synchronize(palasData,preCarGPS,'intersection'));
withCarPalasWithGPS  = rmmissing(synchronize(palasData,withCarGPS,'intersection'));
postCarPalasWithGPS1 = rmmissing(synchronize(palasData,postCarGPS1,'intersection'));
postCarPalasWithGPS2 = rmmissing(synchronize(palasData,postCarGPS2,'intersection'));

%% palasWithGPSData 
palasCarGPS = [preCarPalasWithGPS;withCarPalasWithGPS;...
                                postCarPalasWithGPS1;postCarPalasWithGPS2];            
                            
palasWSTC   =  gpsCropLatLong(palasCarGPS,32.992179, -96.757777,0.0015,0.0015);                          

%% Saving Data 
save("/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/palas/palasWSTCOnlyJuly2020.mat",'palasWSTC');
save("/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/palas/palasAllGPSJuly2020.mat",'palasCarGPS');




