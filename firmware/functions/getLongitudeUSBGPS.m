function longitude= getLongitudeUSBGPS(dataIn,directionIn)
tic
    longitude = double((vpa(dataIn) - round(vpa(dataIn)/100)*100)/60+round(dataIn/100));

       if directionIn == 'W'
            longitude = longitude *-1; 
       end
toc
    
end

