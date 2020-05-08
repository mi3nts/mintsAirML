
function timeTableOut = getCentralTime(timeTableIn,givenDate)

    d = timeTableIn.dateTime;
    d.TimeZone = 'America/Chicago';
    timeTableIn.dateTime = d;
    
%     timeTableIn(1:5,:)
    givenDate.TimeZone ='America/Chicago';
    timeTableOut = timeTableIn((timeTableIn.dateTime>=givenDate)&(timeTableIn.dateTime<givenDate+(days)),:);
    % if(timeTableOut)
    
    if(height(timeTableOut)==0)
        timeTableOut=[]; 
    end    
end

