
clc
clear all
close all

load('/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/concat/palasStreamDataAll_2020_08_22.mat')
palasStreamAllRetimed(isnan(palasStreamAllRetimed.pm2_5_palas),:) = [];

plot(palasStreamAllRetimed.dateTime,palasStreamAllRetimed.pm2_5_palas,'r.')
hold on 

%%
% Deleting Columns 
palasStreamAllRetimed(:,7:end)=[];

% Loading Frog File Data 
load('/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/concat/palasSetAug_22_2020_Retimed_Modified.mat');

% Combining Data 
plot(palasAirAllRetimed.dateTime,   palasAirAllRetimed.pm2_5_palas,'b.')


palasAirAllRetimed(:,7:end)=[];

% Retiming again for completion 
palasDataNow = retime(sortrows([palasAirAllRetimed; palasStreamAllRetimed]),'regular',@mean,'TimeStep',seconds(30));

save('/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/concat/palasFinal_08_22_2020.mat','palasDataNow')

plot(palasDataNow.dateTime,palasDataNow.pm2_5_palas,'b.');
hold on 
plot(palasDataNow.dateTime,palasDataNow.pm1_PALAS,'g.');
plot(palasDataNow.dateTime,palasDataNow.pm10_palas,'r.');


% plot(palasStreamAllRetimed.dateTime,palasStreamAllRetimed.pm2_5_palas,'bo');
% plot(palasStreamAllRetimed.dateTime,palasStreamAllRetimed.pm1_PALAS,'go');
% plot(palasStreamAllRetimed.dateTime,palasStreamAllRetimed.pm10_palas,'ro');

plot(palasAirAllRetimed.dateTime,palasAirAllRetimed.pm2_5_palas,'bo');
hold on 
plot(palasAirAllRetimed.dateTime,palasAirAllRetimed.pm1_PALAS,'go');
plot(palasAirAllRetimed.dateTime,palasAirAllRetimed.pm10_palas,'ro');
