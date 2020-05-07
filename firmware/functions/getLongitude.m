function longitude= getLongitude(dataIn,directionIn)
  
    longitude = double((vpa(dataIn) - round(vpa(dataIn)/100)*100)/60+round(dataIn/100));

   if cell2mat(directionIn) == 'W'
        longitude = longitude *-1; 
   end
   
    
end