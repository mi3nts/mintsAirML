function longitude = getLongitudeAirMar(input,directionIn)

   longitude = floor(input/100)+ rem(input,100)/60 ;

    if cell2mat(directionIn) == 'W'
        longitude = longitude *-1; 
    end
   
end