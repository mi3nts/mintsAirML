function [palasAir,palasWeather] = savePalasFile(filename)
display(filename)
fid=fopen(filename);
palas     = table();

%  The number of lines 
lines = 0 ;

tline = fgetl(fid);
while ischar(tline)
   lines =  lines +1 ;
   C = strsplit(tline,"	");
%    length(C)
   if(lines>19)  && (length(C)==13)         
   palas = [palas;cell2table(C)];
   end 
   tline = fgetl(fid);
end

fclose(fid);
palasAir     = palas(:,1:9);
palasWeather = palas(:,10:end);

palasAir.C1 = datetime(palasAir.C1, 'InputFormat','MM/dd/yyyy - hh:mm:ss a');
palasWeather.C10 = datetime(palasWeather.C10, 'InputFormat','MM/dd/yyyy - hh:mm:ss a','TimeZone','UTC' );

palasAir.C2 = str2double(palasAir.C2);
palasAir.C3 = str2double(palasAir.C3);
palasAir.C4 = str2double(palasAir.C4);
palasAir.C5 = str2double(palasAir.C5);
palasAir.C6 = str2double(palasAir.C6);
palasAir.C7 = str2double(palasAir.C7);
palasAir.C8 = str2double(palasAir.C8);
palasAir.C9 = str2double(palasAir.C9);

palasWeather.C11 = str2double(palasWeather.C11);
palasWeather.C12 = str2double(palasWeather.C12);
palasWeather.C13= str2double(palasWeather.C13);

palasAir.Properties.VariableNames     = [{'dateTime'} {'pm1_PALAS'} {'pm2_5_PALAS'} {'pm4_PALAS'} {'pm10_PALAS'} {'pmTotal_PALAS'} {'dCn_PALAS'} {'latitude'} {'longitude'}];
palasWeather.Properties.VariableNames = [{'dateTime'} {'temperature_PALAS'} {'humidity_PALAS'} {'pressure_PALAS'}];
display("File Done")
end

