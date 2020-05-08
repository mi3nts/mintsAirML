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

modelsMatsFolder     = "/media/teamlary/Team_Lary_2/air930/mintsData/modelsMats";

plotsFolder          = "/media/teamlary/Team_Lary_2/air930/mintsData/visualAnalysis";

nodeIDs   = {...
%                 '001e06305a12',...
                '001e06323a12',...
                '001e06318cd1',...
                '001e06305a61',...
                '001e06323a05',...
                '001e06305a57',...
                '001e063059c2',...
                '001e06318c28',...
                '001e06305a6b',...
                '001e063239e3',...
                '001e06305a6c'...
                };
            
mintsTargets =   {...
            'pm1_PALAS'                   ,...
            'pm2_5_palas'                 ,...
            'pm4_palas'                   ,...
            'pm10_palas'                  ,...
            'pmTotal_palas'               ,...
            'dCn_palas'                    };
        
plotLimits = {30,50,60,100,180,1750}
        
versionStr = ['modelVersion_' datestr(today,'yyyy_mm_dd')];
disp(versionStr)
        
for nodeIndex = 1:length(nodeIDs)
    nodeID = nodeIDs{nodeIndex};
    
    for targetIndex = 1: length(mintsTargets)              
    
        target = mintsTargets{targetIndex};
        plotLimit = plotLimits{targetIndex};
        loadName = getMintsFileNameGeneral(modelsMatsFolder,nodeIDs,nodeIndex,...
                                                    target,versionStr)
        display("Loading " + loadName);

        load(loadName)
        
        display(newline);
        trainFig    = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr + "trainPlot")
        validFig    = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"validPlot")
        combinedFig = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"combinedPlot")
        allInOneFig = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"allInOnePlot")
        predictFig = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"predictorPlot")
        QQFig = getMintsFileNameFigPre(plotsFolder,nodeIDs,nodeIndex,target,versionStr +"QQPlot")
        %% Estimating Statistics 
        outTrainEstimate=predict(Mdl,trainingT);
        outValidEstimate=predict(Mdl,validatingT);

        %--------------------------------------------------------------------------
        % calculate the mean square error (MSE) of the test and training points
        mseTrain=sum((outTrainEstimate-Out_Train).^2)/length(Out_Train)
        mseValid=sum((outValidEstimate-Out_Validation).^2)/length(Out_Validation)

        %--------------------------------------------------------------------------
        % calculate the correlation coefficients for the training and test data 
        % sets with the associated linear fits hint: check out the function corrcoef
        R_Train = corrcoef(outTrainEstimate,Out_Train);
        rTrain=R_Train(1,2)
        R_Validation = corrcoef(outValidEstimate,Out_Validation);
        rValid=R_Validation(1,2)  
        display(newline);
        
        %% Scatter Plots 
%         drawScatterPlotMints(Out_Train,...
%                                     outTrainEstimate,...
%                                     plotLimit,...
%                                     nodeID,...
%                                     targetLabel,...
%                                     "Training",...
%                                     "Palas Spectrometor",...
%                                     "Mints Node",...
%                                     "\mug/m^{3}",...
%                                     trainFig);
%         
%          drawScatterPlotMints(Out_Validation,...
%                                     outValidEstimate,...
%                                     plotLimit,...
%                                     nodeID,...
%                                     targetLabel,...
%                                     "Testing",...
%                                     "Palas Spectrometor",...
%                                     "Mints Node",...
%                                     "\mug/m^{3}",...
%                                     validFig);
%                                 
%          drawScatterPlotMints([Out_Train;Out_Validation],...
%                                     [outTrainEstimate;outValidEstimate],...
%                                     plotLimit,...
%                                     nodeID,...
%                                     targetLabel,...
%                                     "Combined",...
%                                     "Palas Spectrometor",...
%                                     "Mints Node",...
%                                     "\mug/m^{3}",...
%                                     combinedFig); 
%         
%          drawScatterPlotMintsCombined(Out_Train,...
%                                          outTrainEstimate,...
%                                          Out_Validation,...
%                                          outValidEstimate,...
%                                          plotLimit,...
%                                          nodeID,...
%                                          targetLabel,...
%                                          "Traning Vs Testing",...
%                                          "Palas Spectrometor",...
%                                          "Mints Node",...
%                                          "\mug/m^{3}",...
%                                          allInOneFig); 
% 
% 
%           drawPredictorImportaince(Mdl,20,...
%                                     targetLabel,mintsInputLabels,...
%                                             nodeID,predictFig)                                
%                                  
        %% Create a quantile quantile plot diagram
        
      drawQQPlotMints(Out_Train,...
                                    outTrainEstimate,...
                                    plotLimit,...
                                    nodeID,...
                                    targetLabel,...
                                    "QQ Plot",...
                                    "Palas Spectrometor",...
                                    "Mints Node",...
                                    "\mug/m^{3}",...
                                     QQFig)
                                     
        
%                               dataX,...
%                               dataY,...
%                               limit,...
%                               nodeID,...
%                               estimator,...
%                               summary,...
%                               xInstrument,...
%                               yInstrument,...
%                               units,...
%                               saveNameFig
%         
%         figure_1= figure('Tag','SCATTER_PLOT',...
%             'NumberTitle','off',...
%             'units','pixels','OuterPosition',[0 0 900 675],...
%             'Name','Regression',...
%             'Visible','on'...
%         );
%         qqplot(Out_Validation,outValidEstimate)
%         hold on
%         xl=xlim;
% %         ylim(xl);
% 
%         % find the 0, 25, 50, 75, 100 percentiles
%         cp=[0 25 50 75 100];
%         p_Valid=prctile(Out_Validation,cp);
%         p_Estimate=prctile(outValidEstimate,cp);
% 
%         hold on
%         scatter(p_Valid,p_Estimate,'dr','filled')
%         gapsX= [.1 -.6 -.8 -1.3 -5.5]
%         gapsY= [.2 .6 .8 1.3 0]
%         for i=1:length(p_Valid)
%            text(...
%                p_Valid(i)+gapsX(i),...
%                p_Estimate(i)+gapsY(i),...
%                num2str(cp(i)),...
%                'Color','red',...
%                'FontSize',20,...
%                'HorizontalAlignment','center'...
%                )
%         end
%         hold off
%         % Uncomment the following line to preserve the X-limits of the axes
%         xlim([0  plotLimit]);
%         % Uncomment the following line to preserve the Y-limits of the axes
%         ylim([0  plotLimit]);
%         box('on');
%         axis('square');
%         % add graph paper
%         grid on

% %         % set other options
%          set(gca,'LineWidth',2);set(gca,'TickDir','out');set(gca,'FontSize',20)     
% %         xlabel(['True ' WantedVariablesNames{ivar}],'FontSize',25);ylabel(['Estimated ' WantedVariablesNames{ivar}],'FontSize',25);title(['Quantile-Quantile ' WantedVariablesNames{ivar}],'FontSize',25)
% %         drawnow
% % 
% %         [fnpng,fneps]=wrplotepspng(fn_qq);% save to an eps & png file
% % 
%           set(gca,'XScale','log');set(gca,'YScale','log');
%         drawnow
% 
%         [fnpng,fneps]=wrplotepspng(fn_qq_log);% save to an eps & png file  



%%







          display(newline);
          close all
        
        
        
        
        
        
        
        
%         saveName = getMintsFileNameGeneral(modelsMatsFolder,nodeIDs,nodeIndex,...
%                                                     target,versionStr)
%                                                 
%         save(saveName,...
%              'Mdl',...
%              'In_Train',...
%              'Out_Train',...
%              'In_Validation',...
%              'Out_Validation',...
%              'trainingTT',...
%              'validatingTT',...
%              'trainingT',...
%              'validatingT',...
%              'mintsInputs',...
%              'mintsInputLabels',...
%              'target',...
%              'targetLabel',...
%              'nodeID',...
%              'mintsInputs',...
%              'mintsInputLabels',...
%              'binsPerColumn',...
%              'numberPerBin',...
%              'pValid' ...
%          )
%        
        clearvars -except...
               versionStr ...
               rawMatsFolder mergedMatsFolder ...
               trainingMatsFolder modelsMatsFolder...
               nodeIDs nodeIndex nodeID ...
               mintsInputs mintsInputLabels ...
               mintsTargets mintsTargetLabels targetIndex ...
               binsPerColumn numberPerBin pValid ...
               plotLimits plotsFolder 
    
    end %Targets 
    
    clear nodeID
    
end % Nodes 


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
            'Visible','on'...
        );
        qqplot(dataX,dataY)
        hold on
        xl=xlim;
%         ylim(xl);

        % find the 0, 25, 50, 75, 100 percentiles
        cp=[0 25 50 75 100];
        p_Valid=prctile(dataX,cp);
        p_Estimate=prctile(dataY,cp);

        hold on
        scatter(p_Valid,p_Estimate,'dr','filled')
        gapsX= [.1 -.6 -.8 -1.3 -5.5]
        gapsY= [.2 .6 .8 1.3 0]
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
    legend1 = legend('show');
    set(legend1,'Location','northwest');
    set(gca,'XScale','log');set(gca,'YScale','log');

%     
    Fig_name = strcat(figNamePre,'.png');
    saveas(figure_1,char(Fig_name));
    Fig_name = strcat(figNamePre,'.fig');
    saveas(figure_1,char(Fig_name));
%    



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
        'Visible','on'...
    );

    %% Plot 1 : 1:1
    plot1=plot([1: limit],[1: limit])
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

    plot2 = plot(fitresult)
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
         dataYValid)
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
    
%     %% Plot 7 Validating Data 
%     % Create plot
%     plot7 = plot(...
%          dataXAll,...
%          dataYAll)
%     set(plot7,'DisplayName','Validating Data','Marker','o',...
%         'LineStyle','none','Color',[.5 .5 .5]);
    
    
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
        'Visible','on'...
    )



barh(imp(isortedImp));hold on ; grid on ;
set(gca,'ydir','reverse');
xlabel('Scaled Importance(%)','FontSize',20);
ylabel('Predictor Rank','FontSize',20);
   % Create title
    Top_Title=strcat(estimator," - Predictor Importance Estimates")
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
%    
%         Fig_name = strrep(strcat(strrep(estimator,".","_"),"_Node_",string(nodeID),...
%           "_PredictorImportance",'.fig')," ","_")
%     saveas(figure_1,char(Fig_name));
%     
%     print('ScreenSizeFigure','-dpng','-r100')
    
end



