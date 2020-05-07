
function [splitTables,dates,indexes] = splitToDates(inputTimeTable)
% SPLITTODATES Summary of this function goes here
% Detailed explanation goes here

  datesAll    = inputTimeTable.dateTime ;
  datesAll.Hour  = 0 ;
  datesAll.Minute= 0 ;
  datesAll.Second= 0 ;

  dates =  unique(datesAll);
  indexes = length(dates);
  
  for n=1:length(dates)
     splitTables{n} = inputTimeTable(datesAll==dates(n),:);
  end  


end

