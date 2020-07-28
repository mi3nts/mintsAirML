
function [] = drawResiduesPlotCombinedMints(...
                                    dataXTrain,...
                                    dataYTrain,...
                                    dataXValid,...
                                    dataYValid,...
                                    nodeID,...
                                    estimator,...
                                    summary,...
                                    xInstrument,...
                                    yInstrument,...
                                    units,...
                                    saveNameFig)
%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
% As Is Graphs 
     figure_1= figure('Tag','SCATTER_PLOT',...
            'NumberTitle','off',...
            'units','pixels','OuterPosition',[0 0 900 675],...
            'Name','Regression',...
            'Visible','on'...
        );


    % Training plot
    plot3 = plot(...
         abs(dataXTrain- dataYTrain))
    set(plot3,'DisplayName','Training Residues','Marker','o',...
        'LineStyle','none','Color',[0 0 1]);
    hold on 
    % Testing Plot
    plot4 = plot(abs(dataXValid - dataYValid))
    set(plot4,'DisplayName','Testing Residues','Marker','o',...
        'LineStyle','none','Color',[1 0 0])
    
    
    yl=strcat('|',yInstrument,'-',xInstrument,'|'," (",units,")");
    ylabel(yl,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel('Data Points','FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title= strcat("N = ",string(length([dataXTrain;dataXValid])));

    title({Top_Title;Middle_Title;Bottom_Title},'FontWeight','bold');
% 
%     % Uncomment the following line to preserve the X-limits of the axes
%     xlim([limitLow, limitHigh]);
%     % Uncomment the following line to preserve the Y-limits of the axes
%     ylim([limitLow, limitHigh]);
%     box('on');
    axis('square');
    % Create legend
    legend1 = legend('show');
    set(legend1,'Location','northwest');
    
    Fig_name = strcat(saveNameFig,'.png');
    saveas(figure_1,char(Fig_name));
   
    Fig_name =strcat(saveNameFig,'.fig');
    saveas(figure_1,char(Fig_name));

end

