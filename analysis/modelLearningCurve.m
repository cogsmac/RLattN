

function modelLearningCurve(experiment, graphBins, varargin)
% Data has to be formatted like RLAttN or RASHNL to work, as of now. Call
% the function like this:
% modelLearningCurve(15, RASHNLOutput, 'RASHNL', SSHRCOutput, 'SSHRC')
% This will give us RLattN model performance by plotting the learning
% curves.

% Caitlyn McColeman
% September 13 2011

% NOT reviewed
% NOT verified


%% Data Matrices
% It takes RASHNL, ALCOVE and RLattN *fits* as INPUT
% OUTPUTs the learning curves for any of the three models and for human data
labelCounter=1; dataCounter=[];
accuracyOutput = [];
proportionOfExp = 0;
for v = 1:length(varargin) % We'll need a curve for each of the model input
    % Identify the data from the labels
    if ~ischar(varargin{v})
        humanAccuracy = [];
        modelAccuracy = [];
        modelData = varargin{v}
        
        % The models' accuracy matrices
        % Create a length vector, to see if there the same number of trials
        for i=1:length(modelData(:,5))
            lengthVal(i,1)=length(modelData{i,1});
        end
        
        if length(unique(lengthVal))>1 % If there are different lengths, make a proportion plot.
            for i=1:length(modelData(:,5)) % Will need to store data seperately for each simulation
                numberTrials = length(modelData{i,1}(:,11));
                chunkSize = floor(numberTrials/graphBins);
                thisSimAcc = modelData{i,1}(:,11);
                accStorage = [];
                for j = 1:graphBins
                    chunkProportion = thisSimAcc(((j-1)*graphBins+1):(j*graphBins),1);
                    chunkProportion = sum(chunkProportion)/graphBins;
                    accStorage = [accStorage chunkProportion];
                end
                teamAccuracy(i,:)=accStorage;
            end
            modelAccuracy = teamAccuracy';
            overallModelAcc(v,:) = mean(modelAccuracy');
            overallModelStd(v,:) = sem(modelAccuracy');
        else
            
            for i=1:length(modelData)
                modelAccTemp(:,i) = modelData{i,1}(:,11);
            end
            
            %   modelAccuracy = cell2mat(hnAcc);
            modelMean = mean(modelAccTemp');
            overallModelStd(v,:) = sem(reshape(modelMean, [floor((length(modelMean))/graphBins), graphBins]));
            
            modelMean = mean(reshape(modelMean, [floor((length(modelMean))/graphBins), graphBins]));
            
            
            
            overallModelAcc(v,:) =(modelMean);
            
        end
        
        
        
        dataCounter(v)=1
        %meanToGraph(v,:)=overallModelAcc;
        %stdToGraph(v,:)=overallModelStd;
    else
        labelCell{labelCounter} = varargin{v};
        labelCounter=labelCounter+1;
    end
    
end



% Subject List
if strcmp('sshrc_if',experiment)
    humanSubs = mysqlcheck(['SELECT Subject FROM ' experiment 'ExpLvl WHERE SubjectCondition =1 AND GazeDropper=0 AND CP>0']);
else
    humanSubs = mysqlcheck(['SELECT Subject FROM ' experiment 'ExpLvl WHERE CP>0']);
    % Human accuracy matrix
end

accuracyOutput = [];
proportionOfExp = 0;

for i = 1:length(humanSubs)
    humanAcc{:,i} = mysqlcheck(['SELECT TrialAccuracy FROM ' experiment 'TrialLVL WHERE Subject = ' num2str(humanSubs(i)) ]);
end
%The humans' accuracy matrices
% Create a length vector, to see if there the same number of trials
for i=1:length(humanSubs)
    lengthValH(i,1)=length(humanAcc{1,i});
end

if length(unique(lengthVal))>1 % If there are different lengths, make a proportion plot.
    for i=1:length(humanSubs) % Will need to store data seperately for each simulation
        numberTrialsH = length(humanAcc{1,i});
        chunkSize = floor(numberTrialsH/graphBins);
        thisSimAcc = humanAcc{:,i};
        accStorage = []
        for j = 1:graphBins
            chunkProportion = thisSimAcc(((j-1)*graphBins+1):(j*graphBins),1);
            chunkProportion = sum(chunkProportion)/graphBins;
            accStorage = [accStorage chunkProportion]
        end
        teamAccuracyH(i,:)=accStorage;
    end
    humanAccuracy = teamAccuracyH;
    
    humanMean = mean(humanAccuracy);
    humanStd = sem(humanAccuracy);
    
else
    
    for k=1:length(humanSubs)
        
        accMatrix(:,k) = humanAcc{1,k};
        
        
        %modelMean = mean(reshape(modelMean, [graphBins, length(modelMean)/graphBins]));
        
        %humanMean = mean(humanAccuracy);
        % humanStd = sem(humanAccuracy);
    end
    humanMean = [];
    humanMean = mean(accMatrix');
    
    humanStd = sem(reshape(humanMean, [floor((length(humanMean))/graphBins), graphBins]));
    
    humanMean = mean(reshape(humanMean, [floor((length(humanMean))/graphBins), graphBins]));
    
end

columnCount = 1;
for i=1:length(varargin)-1
    
    if sum(overallModelAcc(i,:))>0
        modelOut(columnCount,:)=overallModelAcc(i,:);
        columnCount=columnCount+1;
    end
    
end
columnCount = 1;

for i=1:length(varargin)-1
    if sum(overallModelStd(i,:))>0
        modelOutStd(columnCount, :)=overallModelStd(i,:);
        columnCount=columnCount+1;
    end
    
end

%% Draw plot

means = ([modelOut; humanMean])';%; humanMean])';
sems = ([modelOutStd; humanStd])';%; humanStd])';

% Set colours
cmap = lines(length(varargin)+1);

% Set general figure properties, axes, axis limits
figure1 = figure;
axes1 = axes('Parent', figure1, 'FontSize', 17, 'XTick', 1:graphBins, 'YTick', 0:1);
ylabel('Accuracy');
xlabel(['Block (1 Block = 1/ ' graphBins ' of the Experiment']);
ylim([0 1.1]);
xlim([0 graphBins+ceil(0.1*graphBins)]);
hold all
errorbar1 = errorbar(means, sems,'MarkerSize', 2, 'Marker','o', 'LineWidth',2);
legend1 = legend(axes1,'show'); set(legend1,'Location','SouthEast');
for k = 1:length(labelCell)
    set(errorbar1(k), 'DisplayName',labelCell{k}, 'Color', cmap(k,:), 'MarkerFaceColor', 'k');
end
set(errorbar1(end), 'DisplayName', [experiment ': human accuracy'], 'Color', cmap(k+1,:), 'MarkerFaceColor', [0 .5 0], 'LineStyle', ':', 'LineWidth', 2);
legend1 = legend(axes1,'show'); set(legend1,'Location','SouthEast');


