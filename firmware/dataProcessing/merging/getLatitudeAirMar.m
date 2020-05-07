function latitude = getLatitudeAirMar(input,directionIn)

   latitude = floor(input/100)+ rem(input,100)/60 ;

   if cell2mat(directionIn) == 'S'| cell2mat(directionIn) == 'S'
        latitude = latitude *-1; 
   end
   
end
    
   