function ifeatures = feature_engineering(In,Out,InNames,OutName,nwanted_features,OutDescription)

% Find the current figure
feature_fig=gcf;

%--------------------------------------------------------------------------
napproaches=2;
disp([...
    'Finding best ' num2str(nwanted_features) ...
    ' features using ' num2str(napproaches) ' approaches.' ...
    ])

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Create an optimized ensemble model called Mdl using fitrensemble with 
% Bayesian Optimization executed in parallel to find the most important inputs.
disp('Use fitrensemble')
tic
n_selection_iterations=10;
disp('Create an optimized ensemble model called Mdl using BayesianOptimization in parallel.')
Mdl_ensemble = fitrensemble(In,Out,...
    'OptimizeHyperparameters','all',...
    'HyperparameterOptimizationOptions',...
        struct(...
        'AcquisitionFunctionName','expected-improvement-plus',...
        'MaxObjectiveEvaluations',n_selection_iterations,...
        'UseParallel',true ...
        )...
    );
toc

% close the optimization figures
% opt_fig=gcf;
% close(opt_fig.Number);

%--------------------------------------------------------------------------
% Estimate the predictor importance
imp_ensemble=predictorImportance(Mdl_ensemble);
[sorted_imp_ensemble,isorted_imp_ensemble] = sort(imp_ensemble,'descend');    
nuse_ensemble=min([nwanted_features length(imp_ensemble)]);
ifeatures_ensemble=isorted_imp_ensemble(1:nuse_ensemble);

%--------------------------------------------------------------------------
% Draw a horizontal bar chart showing the variables in descending order of
% importance. Variable names are held in InNames
% Make the top 5 bars yellow
% Make the top 3 bars red
% save this figure to both a png file and to a color eps file
figure(feature_fig.Number);
subplot(1,napproaches,1);

barh(imp_ensemble(isorted_imp_ensemble(1:nuse_ensemble)));hold on;grid on;
if length(sorted_imp_ensemble)>=5
    barh(imp_ensemble(isorted_imp_ensemble(1:5)),'y');
else
    barh(imp_ensemble(isorted_imp_ensemble(1:nuse_ensemble)),'y');
end
if length(isorted_imp_ensemble)>=3
    barh(imp_ensemble(isorted_imp_ensemble(1:3)),'r');
else
    barh(imp_ensemble(isorted_imp_ensemble(1:nuse_ensemble)),'r');
end

% set up axis properties, make the Y axis in descending order
ax=gca;

% Make x-axis log scaled
ax.XScale='log';

% Make the Y axis in descending order
ax.YDir='reverse';

% graph title and axis labels
xlabel('Estimated Importance');
ylabel('Predictors');

% Set default font sizes and other properties
set(gca,'FontSize',16); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
title({...
    ['Ensemble of Trees'],
    [OutDescription] ...
    },...
    'fontsize',15)

% Set y-axis limits
ylim([.25 nuse_ensemble+0.75])

% Find x axis limits
xl=xlim;
% set x-axis limits
xlim([xl(1) 5*xl(2)])

% label each horizontal bar with the appropriate variable name
for ii=1:nuse_ensemble
    text(...
        1.05*imp_ensemble(isorted_imp_ensemble(ii)),ii,...
        strrep(InNames{isorted_imp_ensemble(ii)},'_','.'),...
        'FontSize',12 ...
    );
end
hold off

drawnow

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Perform neighborhood component analysis (NCA) feature selection for 
% regression with the default λ (regularization parameter) value.
disp('Perform neighborhood component analysis (NCA)')
tic
%nca = fsrnca(In,Out,'FitMethod','exact','Solver','minibatch-lbfgs');
nca = fsrnca(In,Out);
toc

%--------------------------------------------------------------------------
% Estimate the predictor importance
imp_nca=nca.FeatureWeights;
[sorted_imp_nca,isorted_imp_nca] = sort(imp_nca,'descend');    
nuse_nca=min([nwanted_features length(imp_nca)]);
ifeatures_nca=isorted_imp_nca(1:nuse_nca);

%--------------------------------------------------------------------------
% Draw a horizontal bar chart showing the variables in descending order of
% importance. Variable names are held in InNames
% Make the top 5 bars yellow
% Make the top 3 bars red
% save this figure to both a png file and to a color eps file
figure(feature_fig.Number);
subplot(1,napproaches,2);

barh(imp_nca(isorted_imp_nca(1:nuse_nca)));hold on;grid on;
if length(sorted_imp_nca)>=5
    barh(imp_nca(isorted_imp_nca(1:5)),'y');
else
    barh(imp_nca(isorted_imp_nca(1:nuse_nca)),'y');
end
if length(isorted_imp_nca)>=3
    barh(imp_nca(isorted_imp_nca(1:3)),'r');
else
    barh(imp_nca(isorted_imp_nca(1:nuse_nca)),'r');
end

% set up axis properties, make the Y axis in descending order
ax=gca;

% Make x-axis log scaled
ax.XScale='log';

% Make the Y axis in descending order
ax.YDir='reverse';

% graph title and axis labels
xlabel('Estimated Importance');
ylabel('Predictors');

% Set default font sizes and other properties
set(gca,'FontSize',16); set(gca,'TickDir','out'); set(gca,'LineWidth',2);
title({...
    ['Neighborhood Component Analysis'],
    [OutDescription] ...
    },...
    'fontsize',15)
% Set y-axis limits
ylim([.25 nuse_nca+0.75])

% Find x axis limits
xl=xlim;
% set x-axis limits
xlim([xl(1) 5*xl(2)])

% label each horizontal bar with the appropriate variable name
for ii=1:nuse_nca
    text(...
        1.05*imp_nca(isorted_imp_nca(ii)),ii,...
        strrep(InNames{isorted_imp_nca(ii)},'_','.'),...
        'FontSize',12 ...
    );
end
drawnow

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Combine the features from all the approaches
whos ifeatures*
ifeatures_nca=ifeatures_nca';
whos ifeatures*
ifeatures=sort(unique([ifeatures_ensemble ifeatures_nca]));

%--------------------------------------------------------------------------
% Make sure we leave the function with the correct figure active
figure(feature_fig.Number);
