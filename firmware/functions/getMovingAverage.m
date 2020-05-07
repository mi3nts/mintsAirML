
function [movingAvg,lk] = getMovingAverage(inputTable,movingAverageTimeStep,timeStep)
%GETMINTSSENSORFILES Summary of this function goes here
    movingAvg = [];
    names =inputTable.Properties.VariableNames ;
    minimumSliceSize = floor(movingAverageTimeStep/timeStep);
    lk = [];
    slice=[];
 parfor n= 1:height(inputTable)

        currentTable = inputTable(n:end,:)    ;
        slice = currentTable(currentTable.dateTime<=currentTable.dateTime(1)+movingAverageTimeStep,:);
%            lk(n,1)= height(slice)
%            minimumSliceSize
        if(height(slice)>=minimumSliceSize)
     
            currentRow= varfun(@mean, slice);
            currentRow.dateTime =  (slice.dateTime(end)-slice.dateTime(1))/2 + slice.dateTime(1);
            movingAvg = [movingAvg; currentRow]; 
            
        end
    end   
    
    movingAvg.Properties.VariableNames = names;
        
end

