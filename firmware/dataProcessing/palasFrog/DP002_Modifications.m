
clear all
close all

load('/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/concat/palasAirAllJuly2020.mat')
palasAirAllRetimed(isnan(palasAirAllRetimed.pm2_5_palas),:) = [];
plot(palasAirAllRetimed.dateTime,palasAirAllRetimed.pm2_5_palas,'b.')
hold on 
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2019,4,13,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2019,4,19,'TimeZone','utc') ,:) = [];
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2019,6,4,16,41,0,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2019,7,10,'TimeZone','utc') ,:) = [];
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2019,5,2,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2019,5,3,'TimeZone','utc') ,:) = [];
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2019,5,2,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2019,5,24,'TimeZone','utc') ,:) = [];
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2019,8,28,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2019,9,1,'TimeZone','utc') ,:) = [];
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2019,9,6,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2019,9,16,19,33,0,'TimeZone','utc') ,:) = [];
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2019,9,18,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2019,11,22,'TimeZone','utc') ,:) = [];
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2019,12,18,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2020,1,9,14,20,0,'TimeZone','utc') ,:) = [];
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2020,1,11,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2020,4,1,'TimeZone','utc') ,:) = [];
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2019,12,18,'TimeZone','utc') & palasAirAllRetimed.dateTime < datetime(2020,1,9,14,20,0,'TimeZone','utc') ,:) = [];

palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2020,05,06,'TimeZone','utc') &...
                    palasAirAllRetimed.dateTime < datetime(2020,05,27,'TimeZone','utc') ,:) = [];
                
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2020,06,02,'TimeZone','utc') &...
                    palasAirAllRetimed.dateTime < datetime(2020,06,08,'TimeZone','utc') ,:) = [];                

palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2020,06,18,'TimeZone','utc') &...
                    palasAirAllRetimed.dateTime < datetime(2020,06,24,'TimeZone','utc') ,:) = [];                 
                
palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2020,06,29,'TimeZone','utc') &...
                    palasAirAllRetimed.dateTime < datetime(2020,07,02,'TimeZone','utc') ,:) = [];  

palasAirAllRetimed(palasAirAllRetimed.dateTime > datetime(2020,07,4,'TimeZone','utc') &...
                    palasAirAllRetimed.dateTime < datetime(2020,07,9,'TimeZone','utc') ,:) = [];                  
                
plot(palasAirAllRetimed.dateTime,palasAirAllRetimed.pm2_5_palas,'r.')

save('/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/concat/palasAirAllModifiedJuly2020.mat','palasAirAllRetimed')