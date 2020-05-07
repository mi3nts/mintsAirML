  
function latitude= getLatitude(dataIn,directionIn)
latitude = double((vpa(dataIn) - round(vpa(dataIn)/100)*100)/60+round(dataIn/100));

   if cell2mat(directionIn) == 'S'| cell2mat(directionIn) == 'S'
        latitude = latitude *-1; 
   end
   
end



