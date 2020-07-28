
  for dateIndex = 1:length(period)
        if (max(mintsDailyWidths)==mintsDailyWidths(dateIndex))
            period(dateIndex)
            dateIndex
            string((S{1,121}.Properties.VariableNames))== string((S{1,dateIndex}.Properties.VariableNames))
        end
    end % Dates   
    

% string((S{1,1}.Properties.VariableNames))== string((S{1,225}.Properties.VariableNames))