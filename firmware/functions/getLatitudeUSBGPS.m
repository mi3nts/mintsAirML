  
function latitude= getLatitudeUSBGPS(dataIn,directionIn)

        latitude = double((vpa(dataIn) - round(vpa(dataIn)/100)*100)/60+round(dataIn/100));

	  	 if directionIn == 'S'
        		latitude = latitude*-1; 
         end

         
end



