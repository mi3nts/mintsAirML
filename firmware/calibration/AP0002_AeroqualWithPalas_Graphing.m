 clc
close all
clear all 

% Data Pre Processing for Pre Car Calibration 
% Defining Node IDs

display("--------MINTS--------")
addpath("../../functions/");

% Loading Mints Data 
rawMatsFolder = "/media/teamlary/Team_Lary_2/air930/mintsData/rawMats/";

mergedMatsFolder     = "/media/teamlary/Team_Lary_2/air930/mintsData/mergedMats/";

trainingMatsFolder   = "/media/teamlary/Team_Lary_2/air930/mintsData/trainingMats";

modelsMatsFolder     = "/media/teamlary/Team_Lary_2/air930/mintsData/modelsMats/aeroqual";

plotsFolder          = "/media/teamlary/Team_Lary_2/air930/mintsData/visualAnalysis/aeroqual";
          


targetUnits = {'\mug/m^{3}',...
               '\mug/m^{3}',...
               '\mug/m^{3}',...
               '\mug/m^{3}'...
               }
           
           
mintsInputs          =  {'PM10ppm' ,'PM25ppm'}
mintsInputLabels     =  {'PM_{10} ppm', 'PM_{2.5} ppm'}   

mintsTargets         =  {'pm1_PALAS','pm2_5_palas','pm4_palas','pm10_palas'}      
mintsTargetLabels    =  {...
                            'PM_{1}'                  ,...
                            'PM_{2.5}'                ,...
                            'PM_{4}'                  ,...
                            'PM_{10}'                 ,...
                        }        

nodeIDs   = {...
                  'aeroqual1',...
                  'aeroqual2',...
                  'aeroqual4'...
                };

           

plotLimitsL = {0,0,0,0}


gapsX= {[.1 -.5 -.5 -1 -5],...
        [.1 -.6 -.9 -1.8 -5],...
        [.15 -1.2 -2 -2.3 -10],...
        [.15 -1.5 -2.5 -2.8 -10],...
        [.15 -3.4 -5.5 -7.8 -10],...
        [2 -20.4 -32.5 -45.8 -20]...
       };
   
gapsY= {[.1 +1.5 +1.5 +2.5 +4],...
        [.2 +1.05 +1.3 +1.8 +4],...
        [.08 +1.5 +1.8 +2 +6],...
        [.08 +2.8 +3.3 +5 +7],...
        [.08 +4.2 +5.3 +7 +10],...
        [3 +20.2 +28.3 +47 +50]...
        };
        
versionStr = ['modelVersionNN_2020_08_23'];
disp(versionStr)
        
for nodeIndex = 1:length(nodeIDs)
    
    if nodeIndex == 1 
       plotLimitsH = {12,20,30,50} 
    else 
        plotLimitsH = {12,25,45,60}   
    end    
        
    nodeID = nodeIDs{nodeIndex};
    
    for targetIndex = 1: length(mintsTargets)              
    
       
        target = mintsTargets{targetIndex};
        unit   = targetUnits{targetIndex}
        plotLimitH = plotLimitsH{targetIndex};
        plotLimitL = plotLimitsL{targetIndex};
        gapX       = gapsX{targetIndex};
        gapY       = gapsY{targetIndex};
        
        loadName = getMintsFileNameGeneral(modelsMatsFolder,nodeIDs,nodeIndex,...
                                                    target,versionStr)
        display("Loading " + loadName);

        load(loadName)
        
        
        display(newline);
        trainFig      = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_trainPlot")
        validFig      = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_validPlot");
        combinedFig   = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_combinedPlot");
        allInOneFig   = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_allInOnePlot");
        predictFig    = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_predictorPlot");
        trainQQFig    = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_trainQQPlot");
        validQQFig    = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_validQQPlot");
        combinedQQFig = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_combinedQQPlot");
        allInOneQQFig = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_allInOneQQPlot");
        residuesFigTrain     = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_trainResidues");
        residuesFigTest      = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_testResidues") ;
        residuesHistFigTrain = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_trainHistResidues");
        residuesHistFigTest  = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"_testHistResidues") ;   
        
        %% Estimating Statistics 
        outTrainEstimate=predictrnn(Mdl,In_Train);
        outValidEstimate=predictrnn(Mdl,In_Validation);
       
        %% Scatter Plots 
        drawScatterPlotMintsLimits(Out_Train,...
                                    outTrainEstimate,...
                                    plotLimitL,...
                                    plotLimitH,...
                                    nodeID,...
                                    targetLabel,...
                                    "Training",...
                                    "Palas Spectrometor",...
                                    "Aeroqual",...
                                    unit,...
                                    trainFig);
        
        drawScatterPlotMintsLimits(Out_Validation,...
                                    outValidEstimate,...
                                    plotLimitL,...
                                    plotLimitH,...
                                    nodeID,...
                                    targetLabel,...
                                    "Testing",...
                                    "Palas Spectrometor",...
                                    "Aeroqual",...
                                    unit,...
                                    validFig);
%                                 
        drawScatterPlotMintsLimits([Out_Train;Out_Validation],...
                                    [outTrainEstimate;outValidEstimate],...
                                    plotLimitL,...
                                    plotLimitH,...
                                    nodeID,...
                                    targetLabel,...
                                    "Combined",...
                                    "Palas Spectrometor",...
                                    "Aeroqual",...
                                    unit,...
                                    combinedFig); 
        
         drawScatterPlotMintsCombinedLimits(Out_Train,...
                                         outTrainEstimate,...
                                         Out_Validation,...
                                         outValidEstimate,...
                                          plotLimitL,...
                                          plotLimitH,...
                                         nodeID,...
                                         targetLabel,...
                                         "Traning vs Testing",...
                                         "Palas Spectrometor",...
                                         "Aeroqual",...
                                         unit,...
                                         allInOneFig); 
       
%          drawPredictorImportaince(Mdl,15,...
%                                     targetLabel,mintsInputLabels,...
%                                             nodeID,predictFig) ;                               
                                 
%          drawQQPlotMintsLimits(Out_Train,...
%                                     outTrainEstimate,...
%                                     plotLimitL,...
%                                     plotLimitH,...
%                                     nodeID,...
%                                     targetLabel,...
%                                     "QQ Plot Training",...
%                                     "Palas Spectrometor",...
%                                     "Mints Node",...
%                                     gapX,...
%                                     gapY,...
%                                     unit,...
%                                     trainQQFig);
% 
% 
%           drawQQPlotMintsLimits(Out_Validation,...
%                                         outValidEstimate,...
%                                          plotLimitL,...
%                                          plotLimitH,...
%                                         nodeID,...
%                                         targetLabel,...
%                                         "QQ Plot Testing",...
%                                         "Palas Spectrometor",...
%                                         "Mints Node",...
%                                          gapX,...
%                                          gapY,...
%                                         unit,...
%                                          validQQFig)    ;                          
%  
% 
%           drawQQPlotMintsLimits([Out_Train;Out_Validation],...
%                           [outTrainEstimate; outValidEstimate],...
%                                         plotLimitL,...
%                                         plotLimitH,...
%                                         nodeID,...
%                                         targetLabel,...
%                                         "QQ Plot Combined",...
%                                         "Palas Spectrometor",...
%                                         "Mints Node",...
%                                            gapX,...
%                                          gapY,...
%                                         unit,...
%                                         combinedQQFig)  ; 
% 
%         drawQQPlotMintsCombinedLimits(...
%                                       Out_Train,...
%                                       outTrainEstimate,...
%                                       Out_Validation,...
%                                       outValidEstimate,...
%                                        plotLimitL,...
%                                         plotLimitH,...
%                                        nodeID,...
%                                       targetLabel,...
%                                       "QQ Plot Training vs Testing",...
%                                       "Palas Spectrometor",...
%                                       "Mints Node",...
%                                         gapX,...
%                                          gapY,...
%                                        unit,...
%                                        allInOneQQFig) ;
% 
%         drawResiduesPlotMints(Out_Train,...
%                                     outTrainEstimate,...
%                                     nodeID,...
%                                     targetLabel,...
%                                     "Residues Plot Training",...
%                                     "Palas Spectrometor",...
%                                     "Mints Node",...
%                                     unit,...
%                                     residuesFigTrain);        
% 
% 
%         drawResiduesPlotMints(Out_Validation,...
%                                     outValidEstimate,...
%                                     nodeID,...
%                                     targetLabel,...
%                                     "Residues Plot Testing",...
%                                     "Palas Spectrometor",...
%                                     "Mints Node",...
%                                     unit,...
%                                     residuesFigTest);
        
                                   
         drawResiduesHistogramPlotMints(Out_Validation,...
                                    outValidEstimate,...
                                    nodeID,...
                                    targetLabel,...
                                    "Residues Histogram Training",...
                                    "Palas Spectrometor",...
                                    "Aeroqual",...
                                    unit,...
                                    residuesHistFigTrain);        

                                
                             
        drawResiduesHistogramPlotMints(Out_Train,...
                                            outTrainEstimate,...
                                            nodeID,...
                                            targetLabel,...
                                            "Residues Histogram Testing",...
                                            "Palas Spectrometor",...
                                            "Aeroqual",...
                                            unit,...
                                            residuesHistFigTest); 

      display(newline);
      close all
      clearvars -except...
               versionStr ...
               rawMatsFolder mergedMatsFolder ...
               trainingMatsFolder modelsMatsFolder...
               nodeIDs nodeIndex nodeID ...
               mintsInputs mintsInputLabels ...
               mintsTargets mintsTargetLabels targetIndex ...
               binsPerColumn numberPerBin pValid ...
               plotLimitsH plotLimitsL plotsFolder ...
               targetUnits gapsX gapsY
    
    end %Targets 
    
    clear nodeID
    
end % Nodes 

function [] = drawQQPlotMintsCombinedLimits(...
                              dataXTrain,...
                              dataYTrain,...
                              dataXValid,...
                              dataYValid,...
                              limitL,...
                              limitH,...
                              nodeID,...
                              estimator,...
                              summary,...
                              xInstrument,...
                              yInstrument,...
                              gapsX,gapsY,...
                              units,...
                              saveNameFig)


  %% Create a quantile quantile plot diagram
        figure_1= figure('Tag','SCATTER_PLOT',...
            'NumberTitle','off',...
            'units','pixels','OuterPosition',[0 0 900 675],...
            'Name','Regression',...
            'Visible','off'...
        );
    
        combinedX = [dataXTrain;dataXValid];
        combinedY = [dataYTrain;dataYValid];
    
        %% Plot 0 qq Plot Train
        plot0 = qqplot(combinedX,combinedY);
        set(plot0(3),'Color','black');
        set(plot0(1) ,'MarkerEdgeColor','black');
        hold on      
     
        %% Plot 1 qq Plot Train
        plot1 = qqplot(dataXTrain,dataYTrain);
        set(plot1(3),'Color','blue');
        set(plot1(1) ,'MarkerEdgeColor','blue');

        %% Plot 2 qq Plot Test;
        plot2 = qqplot(dataXValid,dataYValid);
        set(plot2(3),'Color','red');
        set(plot2(1) ,'MarkerEdgeColor','red');
        
        
     %% Plot 3: Scatter Combined
        % find the 0, 25, 50, 75, 100 percentiles
        
        cp=[0 25 50 75 100];
        
        p_Combined=prctile(combinedX,cp);
        p_Estimate_Combined=prctile(combinedY,cp);
        plot3 = scatter(p_Combined,p_Estimate_Combined,'dc','filled');
       
        for i=1:length(p_Combined)
           text(...
               p_Combined(i)+gapsX(i),...
               p_Estimate_Combined(i)+gapsY(i),...
               num2str(cp(i)),...
               'Color','black',...
               'FontSize',20,...
               'HorizontalAlignment','center'...
               )
        end       

        p_Train=prctile(dataXTrain,cp);
        p_Estimate_Train=prctile(dataYTrain,cp);
        plot4 = scatter(p_Train,p_Estimate_Train,'sg','filled');
        
        p_Valid=prctile(dataXValid,cp);
        p_Estimate_Valid=prctile(dataYValid,cp);
        plot5 = scatter(p_Valid,p_Estimate_Valid,'oy','filled');
        
        


   
        hold off
        % Uncomment the following line to preserve the X-limits of the axes
        xlim([limitL  limitH]);
        % Uncomment the following line to preserve the Y-limits of the axes
        ylim([limitL  limitH]);
        box('on');
        axis('square');
        % add graph paper
        grid on
                     

    ylabel(strcat(yInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create xlabel
    xlabel(strcat(xInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title = strcat("N = ",string(length(combinedX)));

    title({Top_Title;Middle_Title;Bottom_Title},'FontWeight','bold');

    % Create legend
    legend1 = legend([...
                        plot0(3),plot1(3),plot2(3),...
                        plot0(1),plot1(1),plot2(1),...
                        plot4(1),plot5(1),plot3(1)],{...
                        'Combined Reference','Training Reference','Testing Reference',...
                        'Combined Data','Training Data','Testing Data',...
                        'Training Quantiles','Testing Quantiles','Combined Quantiles'})
% 
    set(legend1,'Location','northwest');
    
    set(gca,'XScale','log');set(gca,'YScale','log');

%     
    Fig_name = strcat(saveNameFig,'.png');
    saveas(figure_1,char(Fig_name));
    Fig_name = strcat(saveNameFig,'.fig');
    saveas(figure_1,char(Fig_name));

end
















function [] = drawQQPlotMintsLimits(dataX,...
                              dataY,...
                              limitL,...
                              limitH,...
                              nodeID,...
                              estimator,...
                              summary,...
                              xInstrument,...
                              yInstrument,...
                              gapsX,gapsY,...
                              units,...
                              saveNameFig)


  %% Create a quantile quantile plot diagram
        figure_1= figure('Tag','SCATTER_PLOT',...
            'NumberTitle','off',...
            'units','pixels','OuterPosition',[0 0 900 675],...
            'Name','Regression',...
            'Visible','on'...
        );
        %% Plot 1 qq Plot 
        plot1 = qqplot(dataX,dataY);
        set(plot1,'DisplayName','QQ Data');
        hold on;
%         xl=xlim;
% %         ylim(xl);
        
        % find the 0, 25, 50, 75, 100 percentiles
        cp=[0 25 50 75 100];
        p_Valid=prctile(dataX,cp);
        p_Estimate=prctile(dataY,cp);

        hold on
        %% Plot 2: Scatter 
        plot2 = scatter(p_Valid,p_Estimate,'dr','filled');
        for i=1:length(p_Valid)
           text(...
               p_Valid(i)+gapsX(i),...
               p_Estimate(i)+gapsY(i),...
               num2str(cp(i)),...
               'Color','red',...
               'FontSize',20,...
               'HorizontalAlignment','center'...
               )
        end
        hold off
        % Uncomment the following line to preserve the X-limits of the axes
        xlim([limitL limitH]);
        % Uncomment the following line to preserve the Y-limits of the axes
        ylim([limitL limitH]);
        box('on');
        axis('square');
        % add graph paper
        grid on
                     

    ylabel(strcat(yInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create xlabel
    xlabel(strcat(xInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title = strcat("N = ",string(length(dataX)));

    title({Top_Title;Middle_Title;Bottom_Title},'FontWeight','bold');

    % Create legend
    legend1 = legend([plot1(1),plot1(3),plot2(1)],{'Data','Reference Line','Quantiles'});
% 
    set(legend1,'Location','northwest');
    
    set(gca,'XScale','log');set(gca,'YScale','log');

%     
    Fig_name = strcat(saveNameFig,'.png');
    saveas(figure_1,char(Fig_name));
    Fig_name = strcat(saveNameFig,'.fig');
    saveas(figure_1,char(Fig_name));


end






function [] = drawScatterPlotMintsCombinedLimits(...
                                    dataXTrain,...
                                    dataYTrain,...
                                    dataXValid,...
                                    dataYValid,...
                                    limitLow,...
                                    limitHigh,...
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

    % Initially draw y=t plot

    
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','Regression',...
        'Visible','off'...
    );

    %% Plot 1 : 1:1
    plot1=plot([limitLow: limitHigh],[limitLow: limitHigh]);
    set(plot1,'DisplayName','Y = T','LineStyle',':','Color',[0 0 0]);
    hold on 

    %% Plot 2 : Training Fit 
    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly1' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];
   
    [fitresult, gof] = fit(...
       dataXTrain,...
       dataYTrain,...
       ft);
   
    rmseTrain     = rms(dataXTrain-dataYTrain);
    r = corrcoef(dataXTrain,dataYTrain);
    rSquaredTrain=r(1,2)^2;
%     rSquared = gof.rsquare;

    % %The_Fit_Equation_Training(runs,ts)=fitresult
    % p1_Training_and_Validation_f=fitresult.p1;
    % p2_Training_and_Validation_f=fitresult.p2;

    plot2 = plot(fitresult);
    set(plot2,'DisplayName','Training Fit','LineWidth',2,'Color',[0 0 .7]);  
    
    %% Plot 3 Traning Data 
    % Create plot
    plot3 = plot(...
         dataXTrain,...
         dataYTrain)
    set(plot3,'DisplayName','Data','Marker','o',...
        'LineStyle','none','Color',[0 0 1]);
    
    %% Plot 4 : Testing Fit 
    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly1' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];
   
    [fitresult, gof] = fit(...
       dataXValid,...
       dataYValid,...
       ft);
   
    rmseValid     = rms(dataXValid-dataYValid);
    r = corrcoef(dataXValid,dataYValid);
    rSquaredValid=r(1,2)^2;
%     rSquared = gof.rsquare;

    % %The_Fit_Equation_Training(runs,ts)=fitresult
    % p1_Training_and_Validation_f=fitresult.p1;
    % p2_Training_and_Validation_f=fitresult.p2;

    plot4 = plot(fitresult)
    set(plot4,'DisplayName','Testing Fit','LineWidth',2,'Color',[1 0 0]);  
    
    %% Plot 5 Validating Data 
    % Create plot
    plot5 = plot(...
         dataXValid,...
         dataYValid);
    set(plot5,'DisplayName','Testing Data','Marker','o',...
        'LineStyle','none','Color',[1 0 0]);
    
     %% Plot 6 : Combined Fit 
    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly1' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];
    dataXAll = [dataXTrain;dataXValid];
    dataYAll = [dataYTrain;dataYValid];
    
    [fitresult, gof] = fit(...
       dataXAll,...
       dataYAll,...
       ft);
   
    rmse     = rms(dataXAll-dataYAll);
    r = corrcoef(dataXAll,dataYAll);
    rSquared=r(1,2)^2;

    plot6 = plot(fitresult)
    set(plot6,'DisplayName','Combined Fit','LineWidth',2,'Color',[0 0 0]);  
    
   
    %% Labels 
   
    yl=strcat(yInstrument,'~=',string(fitresult.p1),'*',xInstrument,'+',string(fitresult.p2)," (",units,")");
    ylabel(yl,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(strcat(xInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title= strcat("R^2 = ", string(rSquared),...
                        ", RMSE = ",string(rmse),...
                         ", N = ",string(length(dataXAll)));

    title({Top_Title;Middle_Title;Bottom_Title},'FontWeight','bold');

    % Uncomment the following line to preserve the X-limits of the axes
    xlim([limitLow, limitHigh]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim([limitLow, limitHigh]);
    box('on');
    axis('square');

    % Create legend
    legend1 = legend('show');
    set(legend1,'Location','northwest');
   
    Fig_name = strcat(saveNameFig,'.png');
    saveas(figure_1,char(Fig_name));
   
    Fig_name =strcat(saveNameFig,'.fig');
    saveas(figure_1,char(Fig_name));

end


function [] = drawScatterPlotMintsLimits(dataX,...
                                    dataY,...
                                    limitLow,...
                                    limitHigh,...
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

    % Initially draw y=t plot

    
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','Regression',...
        'Visible','off'...
    );


    plot1=plot([limitLow: limitHigh],[limitLow: limitHigh])
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
    r = corrcoef(dataX,dataY);
    rSquared=r(1,2)^2;
%     rSquared = gof.rsquare;

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
    
    
    
    
    yl=strcat(yInstrument,'~=',string(fitresult.p1),'*',xInstrument,'+',string(fitresult.p2)," (",units,")");
    ylabel(yl,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(strcat(xInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title= strcat("R^2 = ", string(rSquared),...
                        ", RMSE = ",string(rmse),...
                         ", N = ",string(length(dataX)));

    title({Top_Title;Middle_Title;Bottom_Title},'FontWeight','bold');

    % Uncomment the following line to preserve the X-limits of the axes
    xlim([limitLow, limitHigh]);
    % Uncomment the following line to preserve the Y-limits of the axes
    ylim([limitLow, limitHigh]);
    box('on');
    axis('square');
    % Create legend
    legend1 = legend('show');
    set(legend1,'Location','northwest');


    
    Fig_name = strcat(saveNameFig,'.png');
    saveas(figure_1,char(Fig_name));
   
    Fig_name =strcat(saveNameFig,'.fig');
    saveas(figure_1,char(Fig_name));

end

function [] = drawPredictorImportaince(regressionTree,yLimit,...
                                        estimator,variableNames,nodeID,...
                                         figNamePre)
%GETPREDICTORIMPORTAINCE Summary of this function goes here
%   Detailed explanation goes here

imp = 100*(regressionTree.predictorImportance/sum(regressionTree.predictorImportance));

xLimit = max(imp)+5;

[sortedImp,isortedImp] = sort(imp,'descend');

   figure_1= figure('Tag','PREDICTOR_IMPORTAINCE_PLOT',...
        'NumberTitle','off',...
        'units','pixels',...   
        'OuterPosition',[0 0 2000 1300],...
        'Name','predictorImportance',...
        'Visible','off'...
    )



barh(imp(isortedImp));hold on ; grid on ;
set(gca,'ydir','reverse');
xlabel('Scaled Importance(%)','FontSize',20);
ylabel('Predictor Rank','FontSize',20);
   % Create title
    Top_Title=strcat(estimator," - Predictor Importaince Estimates")
    Middle_Title = strcat("Node " +string(nodeID))
    title({Top_Title;Middle_Title},'FontSize',21);

% title('Predictor Importaince Estimates')
ylim([.5 (yLimit+.5)]);
yticks([1:1:yLimit])
xlim([0 (xLimit)]);
xticks([0:1:xLimit])

% sortedPredictorLabels= regressionTree.PredictorNames(isortedImp);

sortedPredictorLabels= variableNames(isortedImp);

    for n = 1:yLimit
        text(...
            imp(isortedImp(n))+ 0.05,n,...
            sortedPredictorLabels(n),...
            'FontSize',15 , 'Interpreter', 'tex'...
            )
    end
%     
    Fig_name = strcat(figNamePre,'.png');
    saveas(figure_1,char(Fig_name));
    Fig_name = strcat(figNamePre,'.fig');
    saveas(figure_1,char(Fig_name));

    
end




function [] = drawQQPlotMintsCombined(...
                              dataXTrain,...
                              dataYTrain,...
                              dataXValid,...
                              dataYValid,...
                              limit,...
                              nodeID,...
                              estimator,...
                              summary,...
                              xInstrument,...
                              yInstrument,...
                              units,...
                              saveNameFig)


  %% Create a quantile quantile plot diagram
        figure_1= figure('Tag','SCATTER_PLOT',...
            'NumberTitle','off',...
            'units','pixels','OuterPosition',[0 0 900 675],...
            'Name','Regression',...
            'Visible','off'...
        );
    
        combinedX = [dataXTrain;dataXValid];
        combinedY = [dataYTrain;dataYValid];
    
        %% Plot 0 qq Plot Train
        plot0 = qqplot(combinedX,combinedY);
        set(plot0(3),'Color','black');
        set(plot0(1) ,'MarkerEdgeColor','black');
        hold on      
     
        %% Plot 1 qq Plot Train
        plot1 = qqplot(dataXTrain,dataYTrain);
        set(plot1(3),'Color','blue');
        set(plot1(1) ,'MarkerEdgeColor','blue');

        %% Plot 2 qq Plot Test;
        plot2 = qqplot(dataXValid,dataYValid);
        set(plot2(3),'Color','red');
        set(plot2(1) ,'MarkerEdgeColor','red');
        
        
     %% Plot 3: Scatter Combined
        % find the 0, 25, 50, 75, 100 percentiles
        
        cp=[0 25 50 75 100];
        
        p_Combined=prctile(combinedX,cp);
        p_Estimate_Combined=prctile(combinedY,cp);
        plot3 = scatter(p_Combined,p_Estimate_Combined,'dc','filled');

        gapsX= [.1 -.6 -.8 -1.3 -5.5];
        gapsY= [.2 .6 .8 1.3 0];
        
        for i=1:length(p_Combined)
           text(...
               p_Combined(i)+gapsX(i),...
               p_Estimate_Combined(i)+gapsY(i),...
               num2str(cp(i)),...
               'Color','black',...
               'FontSize',20,...
               'HorizontalAlignment','center'...
               )
        end       

        p_Train=prctile(dataXTrain,cp);
        p_Estimate_Train=prctile(dataYTrain,cp);
        plot4 = scatter(p_Train,p_Estimate_Train,'sg','filled');
        
        p_Valid=prctile(dataXValid,cp);
        p_Estimate_Valid=prctile(dataYValid,cp);
        plot5 = scatter(p_Valid,p_Estimate_Valid,'oy','filled');
        
        


   
        hold off
        % Uncomment the following line to preserve the X-limits of the axes
        xlim([0  limit]);
        % Uncomment the following line to preserve the Y-limits of the axes
        ylim([0  limit]);
        box('on');
        axis('square');
        % add graph paper
        grid on
                     

    ylabel(strcat(yInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create xlabel
    xlabel(strcat(xInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title = strcat("N = ",string(length(combinedX)));

    title({Top_Title;Middle_Title;Bottom_Title},'FontWeight','bold');

    % Create legend
    legend1 = legend([...
                        plot0(3),plot1(3),plot2(3),...
                        plot0(1),plot1(1),plot2(1),...
                        plot4(1),plot5(1),plot3(1)],{...
                        'Combined Reference','Training Reference','Testing Reference',...
                        'Combined Data','Training Data','Testing Data',...
                        'Training Quantiles','Testing Quantiles','Combined Quantiles'})
% 
    set(legend1,'Location','northwest');
    
    set(gca,'XScale','log');set(gca,'YScale','log');

%     
    Fig_name = strcat(saveNameFig,'.png');
    saveas(figure_1,char(Fig_name));
    Fig_name = strcat(saveNameFig,'.fig');
    saveas(figure_1,char(Fig_name));

end
















function [] = drawQQPlotMints(dataX,...
                              dataY,...
                              limit,...
                              nodeID,...
                              estimator,...
                              summary,...
                              xInstrument,...
                              yInstrument,...
                              units,...
                              saveNameFig)


  %% Create a quantile quantile plot diagram
        figure_1= figure('Tag','SCATTER_PLOT',...
            'NumberTitle','off',...
            'units','pixels','OuterPosition',[0 0 900 675],...
            'Name','Regression',...
            'Visible','off'...
        );
        %% Plot 1 qq Plot 
        plot1 = qqplot(dataX,dataY);
        set(plot1,'DisplayName','QQ Data');
        hold on;
%         xl=xlim;
% %         ylim(xl);
        
        % find the 0, 25, 50, 75, 100 percentiles
        cp=[0 25 50 75 100];
        p_Valid=prctile(dataX,cp);
        p_Estimate=prctile(dataY,cp);

        hold on
        %% Plot 2: Scatter 
        plot2 = scatter(p_Valid,p_Estimate,'dr','filled');
        gapsX= [.1 -.6 -.8 -1.3 -5.5];
        gapsY= [.2 .6 .8 1.3 0];
        for i=1:length(p_Valid)
           text(...
               p_Valid(i)+gapsX(i),...
               p_Estimate(i)+gapsY(i),...
               num2str(cp(i)),...
               'Color','red',...
               'FontSize',20,...
               'HorizontalAlignment','center'...
               )
        end
        hold off
        % Uncomment the following line to preserve the X-limits of the axes
        xlim([0  limit]);
        % Uncomment the following line to preserve the Y-limits of the axes
        ylim([0  limit]);
        box('on');
        axis('square');
        % add graph paper
        grid on
                     

    ylabel(strcat(yInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create xlabel
    xlabel(strcat(xInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title = strcat("N = ",string(length(dataX)));

    title({Top_Title;Middle_Title;Bottom_Title},'FontWeight','bold');

    % Create legend
    legend1 = legend([plot1(1),plot1(3),plot2(1)],{'Data','Reference Line','Quantiles'});
% 
    set(legend1,'Location','northwest');
    
    set(gca,'XScale','log');set(gca,'YScale','log');

%     
    Fig_name = strcat(saveNameFig,'.png');
    saveas(figure_1,char(Fig_name));
    Fig_name = strcat(saveNameFig,'.fig');
    saveas(figure_1,char(Fig_name));


end






function [] = drawScatterPlotMintsCombined(...
                                    dataXTrain,...
                                    dataYTrain,...
                                    dataXValid,...
                                    dataYValid,...
                                    limit,...
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

    % Initially draw y=t plot

    
    figure_1= figure('Tag','SCATTER_PLOT',...
        'NumberTitle','off',...
        'units','pixels','OuterPosition',[0 0 900 675],...
        'Name','Regression',...
        'Visible','off'...
    );

    %% Plot 1 : 1:1
    plot1=plot([1: limit],[1: limit]);
    set(plot1,'DisplayName','Y = T','LineStyle',':','Color',[0 0 0]);
    hold on 

    %% Plot 2 : Training Fit 
    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly1' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];
   
    [fitresult, gof] = fit(...
       dataXTrain,...
       dataYTrain,...
       ft);
   
    rmseTrain     = rms(dataXTrain-dataYTrain);
    r = corrcoef(dataXTrain,dataYTrain);
    rSquaredTrain=r(1,2)^2;
%     rSquared = gof.rsquare;

    % %The_Fit_Equation_Training(runs,ts)=fitresult
    % p1_Training_and_Validation_f=fitresult.p1;
    % p2_Training_and_Validation_f=fitresult.p2;

    plot2 = plot(fitresult);
    set(plot2,'DisplayName','Training Fit','LineWidth',2,'Color',[0 0 .7]);  
    
    %% Plot 3 Traning Data 
    % Create plot
    plot3 = plot(...
         dataXTrain,...
         dataYTrain)
    set(plot3,'DisplayName','Data','Marker','o',...
        'LineStyle','none','Color',[0 0 1]);
    
    %% Plot 4 : Testing Fit 
    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly1' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];
   
    [fitresult, gof] = fit(...
       dataXValid,...
       dataYValid,...
       ft);
   
    rmseValid     = rms(dataXValid-dataYValid);
    r = corrcoef(dataXValid,dataYValid);
    rSquaredValid=r(1,2)^2;
%     rSquared = gof.rsquare;

    % %The_Fit_Equation_Training(runs,ts)=fitresult
    % p1_Training_and_Validation_f=fitresult.p1;
    % p2_Training_and_Validation_f=fitresult.p2;

    plot4 = plot(fitresult)
    set(plot4,'DisplayName','Testing Fit','LineWidth',2,'Color',[1 0 0]);  
    
    %% Plot 5 Validating Data 
    % Create plot
    plot5 = plot(...
         dataXValid,...
         dataYValid);
    set(plot5,'DisplayName','Testing Data','Marker','o',...
        'LineStyle','none','Color',[1 0 0]);
    
     %% Plot 6 : Combined Fit 
    % Fit model to data.
    % Set up fittype and options. 
    ft = fittype( 'poly1' ); 
    opts = fitoptions( 'Method', 'LinearLeastSquares' ); 
    opts.Lower = [0.6 -Inf];
    opts.Upper = [1.4 Inf];
    dataXAll = [dataXTrain;dataXValid];
    dataYAll = [dataYTrain;dataYValid];
    
    [fitresult, gof] = fit(...
       dataXAll,...
       dataYAll,...
       ft);
   
    rmse     = rms(dataXAll-dataYAll);
    r = corrcoef(dataXAll,dataYAll);
    rSquared=r(1,2)^2;

    plot6 = plot(fitresult)
    set(plot6,'DisplayName','Combined Fit','LineWidth',2,'Color',[0 0 0]);  
    
   
    %% Labels 
   
    yl=strcat(yInstrument,'~=',string(fitresult.p1),'*',xInstrument,'+',string(fitresult.p2)," (",units,")");
    ylabel(yl,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(strcat(xInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title= strcat("R^2 = ", string(rSquared),...
                        ", RMSE = ",string(rmse),...
                         ", N = ",string(length(dataXAll)));

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
   
    Fig_name = strcat(saveNameFig,'.png');
    saveas(figure_1,char(Fig_name));
   
    Fig_name =strcat(saveNameFig,'.fig');
    saveas(figure_1,char(Fig_name));

end


function [] = drawScatterPlotMints(dataX,...
                                    dataY,...
                                    limit,...
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
    r = corrcoef(dataX,dataY);
    rSquared=r(1,2)^2;
%     rSquared = gof.rsquare;

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
    
    
    
    
    yl=strcat(yInstrument,'~=',string(fitresult.p1),'*',xInstrument,'+',string(fitresult.p2)," (",units,")");
    ylabel(yl,'FontWeight','bold','FontSize',10);

    % Create xlabel
    xlabel(strcat(xInstrument,' (',units,')'),'FontWeight','bold','FontSize',12);

    % Create title
    Top_Title=strcat(estimator," - " +summary);

    Middle_Title = strcat("Node " +string(nodeID));

    Bottom_Title= strcat("R^2 = ", string(rSquared),...
                        ", RMSE = ",string(rmse),...
                         ", N = ",string(length(dataX)));

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


    
    Fig_name = strcat(saveNameFig,'.png');
    saveas(figure_1,char(Fig_name));
   
    Fig_name =strcat(saveNameFig,'.fig');
    saveas(figure_1,char(Fig_name));

end




