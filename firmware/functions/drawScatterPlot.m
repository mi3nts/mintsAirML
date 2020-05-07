function [] = drawScatterPlot(dataX,dataY,limit,nodeID,estimator, summary)
%GETMINTSDATAFILES Summary of this function goes here
%   Detailed explanation goes here
% As Is Graphs 

    % Initially draw y=t plot

    
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','Regression',...
        'Visible','off'...
    );


    plot1=plot([1: limit],[1: limit])
    set(plot1,'DisplayName','Y = T','LineStyle',':','Color',[0 0 0]);

    hold on 

    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly1' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];

    

     
    [fitresult, gof] = fit(...
       dataX,...
       dataY,...
       ft);
   
    rmse     = rms(dataX-dataY);
    rSquared = gof.rsquare;

    % %The_Fit_Equation_Training(runs,ts)=fitresult
    % p1_Training_and_Validation_f=fitresult.p1;
    % p2_Training_and_Validation_f=fitresult.p2;

    plot2 = plot(fitresult)
    set(plot2,'DisplayName','Fit','LineWidth',2,'Color',[0 0 1]);

    
    
    
    % Create plot
    plot3 = plot(...
         dataX,...
         dataY)
    set(plot3,'DisplayName','Data','Marker','o',...
        'LineStyle','none','Color',[0 0 0]);
    
    
    
    
    yl=strcat('Mints Node ~=',string(fitresult.p1),'*Grimm Spectrometor','+',string(fitresult.p2)," (\mug/m^{3})")
    ylabel(yl,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel('Grimm Spectrometor (\mug/m^{3})','FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title= strcat("R^2 = ", string(rSquared),...
                        ", RMSE = ",string(rmse));

    title({Top_Title;Middle_Title;Bottom_Title},'FontWeight','bold');

    % Uncomment the following line to preserve the X-limits of the axes
    xlim([0  limit]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim([0  limit]);
    box('on');
    axis('square');
    % Create legend
    legend1 = legend('show');
    set(legend1,'Location','northwest');


    
    Fig_name = strrep(strcat(strrep(estimator,".","_"),"_Node_",string(nodeID),...
          "_",summary,'.png')," ","_")
    saveas(figure_1,char(Fig_name));
   
    Fig_name = strrep(strcat(strrep(estimator,".","_"),"_Node_",string(nodeID),...
          "_",summary,'.fig')," ","_")
    saveas(figure_1,char(Fig_name));



end
