function [] = savePalasStreamFile(fileName,fileNameMat,timeStep)
%SAVEPALASSTREAMFILE Summary of this function goes here
%   Detailed explanation goes here
%% if no file exists 
   
    ttCheck = true;
    
    if isfile(fileNameMat)
        display(strcat("'",fileNameMat,"' already Exists")) % File exists.
    else
       display("Reading "+ fileName)
%        tableIn = getPalasStreamFile(fileName);
       palasStream = table2timetable(getPalasStreamFile(fileName));
       ttCheck = false; 
       folderCheck(fileNameMat); 
       
       save(fileNameMat,'palasStream')       
    end
    
    if(timeStep>seconds(0))
        fileNameRetimed = strrep(fileNameMat,".mat",...
                strcat("_",strrep(strcat(string(timeStep),".mat")," ","_"))) ;
        if isfile(fileNameRetimed)
            display(strcat("'",fileNameRetimed,"' already Exists")) % File exists.
        else
            if(ttCheck)
               palasStream = table2timetable(getPalasStreamFile(fileName));
            end
            
            display(strcat("Saving Retimed File as'",fileNameRetimed,"'")) 
            if (height(palasStream)>0)
                palasStreamRetimed = ...
                retime(palasStream,'regular',@mean,'TimeStep',seconds(30));
                save(fileNameRetimed,'palasStreamRetimed') 
            else
                display(strcat("No Data For: '",fileName,"'"))
            end
            
            
        end    
        
    end

end

