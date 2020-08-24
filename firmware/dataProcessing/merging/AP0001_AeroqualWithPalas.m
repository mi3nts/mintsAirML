
clc
clear all
close all

load('/media/teamlary/Team_Lary_2/air930/mintsData/rawMats/aeroqual/auroqualAll.mat')


load('/media/teamlary/Team_Lary_2/air930/mintsData/referenceMats/concat/palasFinal_08_22_2020.mat')
palasData = retime(palasDataNow,'regular',@nanmean,'TimeStep',minutes(1));

aeroqual1WithPalas =  rmmissing(synchronize(palasData,auroqual1,'intersection'));
aeroqual2WithPalas =  rmmissing(synchronize(palasData,auroqual2,'intersection'));
aeroqual4WithPalas =  rmmissing(synchronize(palasData,auroqual4,'intersection'));


save('aeroqualAllWithPalas.mat','aeroqual1WithPalas','aeroqual2WithPalas',...
                            'aeroqual4WithPalas');

