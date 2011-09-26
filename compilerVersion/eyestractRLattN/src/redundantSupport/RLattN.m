%This script does the reinforcement learning of a category structure that
%is presented inside of experimentStruc. It simulutes the structure using
%parameters identified in the params variable.
%Precondition: experimentStruc has been passed in to the function and is
%structured as outlined in the file Experiment Structure Details.txt
%params is fully specified
%Postcondition: cell array results is returned. this cell array contains
%all relevant experiment presentations and results.
%Authors: Jordan Barnes, Mark Blair, Caitlyn McColeman, R. Calen Walshe

function actionsMade = RLattN(experimentStruc, params)


%WHICH EXPERIMENT?
%experimentName = experimentStruc.expName;


%MODEL PARAMETERS
alp = params(1);
% temp = params(2);
temp = 0.5 ; % Set constant to look at other parameters. Temp may have to be held constant. CM
accessCost = params(2);
novelInformationBonus = params(3);
correctDecisionReward = params(4);
incorrectDecisionReward = params(5);
block = 1;


%MODEL SETTINGS
actionMax = experimentStruc.actionMax;
stateMax = experimentStruc.stateMax;
featureMax = experimentStruc.featureMax; %needed to determine when a feature fixation has been made, and when a categorization has been made.
categoryMax = experimentStruc.categoryMax;
dataDisplayOn = 0; %toggles the GUI for visualizing the processing
expAcc = []; %this logs accuracy on each trial.


stimuli = experimentStruc.stimuli; %preset inside category structure
response = experimentStruc.response;
states = fullfact(repmat(3,1,featureMax));


Q = zeros(stateMax, actionMax);
V = zeros(stateMax + categoryMax, 1);





%1.Part of the fixation sequence reinforcement module Jordan is testing.
%       Fixation sequence code is marked by ***** at the start and end of the
%       "chunk"

% *****
fixRL = 1;
fixQ = {};
fixV = [];
% *****


%actProbStores = {}

for blockTrial = 1:length(stimuli)
    currentStimulus = stimuli(blockTrial,1:featureMax);
    previousState = stateMax;
    currentState = stateMax; %this is the state in which all features are unknown.
    action = 0;
    fixationOrder = [];
    
    knownStimulusValues = states(previousState, :);
    
    if dataDisplayOn == 1
        DataDisplay(knownStimulusValues, Q, V, currentState, block, blockTrial);
    end
    firstAction = 0;
    while action <= featureMax
        % ACTION SELECTION
        %Pick the action that will be selected from the current states
        
        
        %*NOTE* We need to implement some kind of inhibition for fixating
        %the same feature as was just fixated. Eventually, this will
        %naturally propagate through the system, but it is realistic and
        %helpful to the network to do othis.
        
        
        actionProbs = softermax(Q(currentState,:)', temp);
        %action = find(rand<cumsum(actionProbs),1);
        
        if sum(actionProbs(1:end) <0) == 1
            while sum(actionProbs(1:end) < 0) ==1
                actionProbs(1:end) = actionProbs(1:end) + 1;
            end
        end
        
        actionProbs(isnan(actionProbs)) = 0;
        
        if sum(actionProbs(1:end)) == 0
            actionProbs(1:end) = rand * ones(1,length(actionProbs))
        end
        %random weighted selection of the action probability
        action = randsample(featureMax + categoryMax, 1, 'true', actionProbs);
        
        %                 if firstAction == 0
        %                     actionProbStores{blockTrial,1} = actionProbs;
        %                 end
        %                 firstAction = 1;
        
        % REINFORCEMENT and STATE CHANGE
        
        %Assign reward for movement. If action is <=3 assign reward x and
        %if action is >3 assign reward y.
        
        %Modify Q and V depending on the value received from reinforcement.
        
        if action <= featureMax % fixations are 1-3
            
            %This prevents endless fixation flips
            firstAction = firstAction + 1;
            if firstAction == 20
                firstAction
                for breakIter = 1:length(stimuli)
                    actionsMade{1,1}{breakIter,1} = [];
                    actionsMade{1,1}{breakIter,2} = 4;
                    actionsMade{1,1}{breakIter,3} = 0;
                    actionsMade{1,1}{breakIter,4} = [];
                    actionsMade{1,2} = [];
                end
                return
            end
            
            
            
            previousState = currentState;
            
            %Right here is where we update the value of being in
            %particular state.
            
            reinforcement = accessCost;
            
            % Assign novel information bonus
            if states(currentState,action) == 3
                
                knownStimulusValues = states(previousState,:);
                knownStimulusValues(action) = currentStimulus(action);
                
                
                currentState = find(sum((states==repmat(knownStimulusValues,stateMax,1)),2)==featureMax);
                
                if dataDisplayOn == 1
                    DataDisplay(knownStimulusValues,Q,V,currentState,block,blockTrial);
                end
                novelInformationAccessed = 1;
                %   a = input('Awaiting your command to continue...')
            end
            fixationOrder = [action fixationOrder]; % temporary log of action
            
            % NOTE: because you already have the feature information if
            % states(currentState,Action) < 3 currentState should
            % not change
            % so there is no 'else' for those values
            
            %APPLY REINFORCEMENT
            if novelInformationAccessed ==1
                reinforcement = accessCost + novelInformationBonus;
            end
            
            
            % *****
            if fixRL==1
                if isempty(fixQ) % If there are no values for fixQ, it's the first trial with fixation
                    fixcurrentState = 1;
                    fixpreviousState = 1;
                    fixQ{1,1} = fixationOrder; % Set the first state to the action log from the first trial with fixation
                    for actionIter = 2:actionMax+1 % Loop through the columns that we're willing to write to (2:end).
                        fixQ{fixcurrentState,actionIter} = 0; % Set new columns to zero
                    end
                    fixV(fixcurrentState) = 0; % Set entry in V-matrix to zero
                end
                
                fixpreviousState = fixcurrentState % WHERE SHOULD THIS GO??
                
                for fixIter = 1:size(fixQ,1)
                    init = 0;
                    if isequal(fixationOrder, fixQ{fixIter,1}) % If the state already exists..
                        fixcurrentState = fixIter  % ..set the state index as the current state.
                        init = 1;
                    end
                end
                if init ==0; % If the state does not exist
                    fixcurrentState = size(fixQ,1)+1; % make a new state
                    fixQ{fixcurrentState,1} = fixationOrder; % and assign it the action log
                    for actionIter = 2:actionMax+1
                        fixQ{fixcurrentState,actionIter} = 0; %default (until reward)
                    end
                    fixV(fixcurrentState) = 0;%default (until reward)
                end
                
                % Reward calculation for fixation module
                fixreinforcement = accessCost;
                fixTDError = fixV(fixcurrentState) + fixreinforcement - fixV(fixpreviousState)       ;
                fixV(fixpreviousState) = fixV(fixpreviousState) + alp*(fixTDError)                   ;
                fixQ{fixpreviousState,action+1} = fixQ{fixpreviousState,action+1} + alp*(fixTDError) ;
                
            end
            % *****
            
            % RLAttN core reward calculation.
            novelInformationAccessed = 0;
            tdError = V(currentState) + reinforcement - V(previousState) ;
            V(previousState) = V(previousState) + alp*(tdError)         ;
            
            
            % *****
            if fixRL == 1 % Include the fixQ-matrix values with the model Q-matrix.
                Q(previousState,action) = Q(previousState,action) + alp*(tdError) + fixQ{fixpreviousState,action+1};
            else
                Q(previousState,action) = Q(previousState,action) + alp*(tdError);
            end
            % *****
            
            % RLAttN core history collection.
            if dataDisplayOn == 1
                DataDisplay(knownStimulusValues,Q,V,currentState,block,blockTrial);
            end
            % Set the actions made as the fixation order for the trial
            actionsMade{1,1}{blockTrial,1} = fixationOrder;
            history.(['trial' num2str(blockTrial)]).Q = Q;
            history.(['trial' num2str(blockTrial)]).V = V;
            history.(['trial' num2str(blockTrial)]).known = knownStimulusValues;
            
        else  %  a decision is made
            
            % RLAttN core state updates.
            previousState = currentState;
            currentState = stateMax + action - featureMax; %The adding and subtracting make 28-31 be the category decision states
            
            %Compare model's response to the objective correct response.
            %get this information from the correct, incorrect portion of experimentStruct.
            trialAccuracy = isequal(action-featureMax,response(blockTrial));
            
            
            % *****
            if fixRL==1
                
                % fixQ is a history of fixations (values are 1, 2 or 3).
                if isempty(fixQ)
                    fixcurrentState = 1;
                    fixpreviousState = 1;
                    fixQ{1,1} = fixationOrder;% This will record EACH fixation (even if the feature is already known)
                    for actionIter = 2:actionMax+1 % columns 2:8 are the probability of selecting an action given state in column 1.
                        fixQ{fixcurrentState,actionIter} = 0;
                    end
                    fixV(fixcurrentState) = 0; % Value matrix stores zero if Q matrix is empty.
                    
                end
                
                fixprobVec = [];
                fixprobVec(1:7) = fixQ{fixcurrentState,featureMax+1:actionMax+1}  ; %? "Dummy" fixation-based decision
                fixactionProbs = softermax(fixprobVec, temp);
                if sum(fixactionProbs(featureMax+1:end) <0) == 1 % Condition to control for errors. Shouldn't be used (??)
                    while sum(fixactionProbs(featureMax+1:end) < 0) ==1
                        fixactionProbs(featureMax+1:end) = fixactionProbs(featureMax+1:end) + 1
                    end
                end
                
                fixactionProbs(isnan(fixactionProbs)) = 0; % Deals with NaNs from softmax output
                
                fixaction = randsample(categoryMax, 1, 'true', fixactionProbs(featureMax+1:end));
                fixAccuracy = isequal(fixaction-featureMax,response(blockTrial));
                fixfixationOrder = [fixationOrder(1:end-1) fixaction]; %
                
                fixpreviousState = fixcurrentState; % Set up to move on to new state
                
                for fixIter = 1:size(fixQ,1)
                    init = 0;
                    if isequal(fixationOrder, fixQ{fixIter,1}) % Does state already exist?
                        fixcurrentState = fixIter ;
                        init = 1;
                    end
                end
                if init ==0; % If state does not alraedy exist..
                    fixcurrentState = size(fixQ,1)+1; % ..make new state
                    fixQ{fixcurrentState,1} = fixfixationOrder; % ..and assign action log.
                    for actionIter = 2:actionMax+1
                        fixQ{fixcurrentState,actionIter} = 0;
                    end
                    fixV(fixcurrentState) = 0;
                end
                
                % Consider actual model accuracy
                if trialAccuracy == 1
                    fixreinforcement = correctDecisionReward;
                else
                    fixreinforcement = incorrectDecisionReward;
                end
                % Apply reward via TD error; update Q and V matrices
                fixTDError = fixV(fixcurrentState) + fixreinforcement - fixV(fixpreviousState) ;
                fixV(fixpreviousState) = fixV(fixpreviousState) + alp*(fixTDError)         ;
                fixQ{fixpreviousState,action+1} = fixQ{fixpreviousState,action+1} + alp*(fixTDError);
                
            end
            % *****
            
            % Core RLAttN reward calculations
            expAcc = [expAcc, trialAccuracy];
            
            if trialAccuracy == 1
                reinforcement = correctDecisionReward;
            else
                reinforcement = incorrectDecisionReward;
            end
            
            %Calculate TD error and apply it to Q and V matrices
            tdError = V(currentState) + reinforcement - V(previousState)    ;
            V(previousState) = V(previousState) + alp*(tdError)              ;
            Q(previousState,action) = Q(previousState,action) + alp*(tdError) ;
            history.(['trial' num2str(blockTrial)]).Q = Q;
            history.(['trial' num2str(blockTrial)]).V = V;
            history.(['trial' num2str(blockTrial)]).known = knownStimulusValues;
            if dataDisplayOn == 1
                DataDisplay(knownStimulusValues,Q,V,currentState,block,blockTrial);
            end
            actionsMade{1,1}{blockTrial,2} = action-featureMax;
            actionsMade{1,1}{blockTrial,3} = trialAccuracy;
            actionsMade{1,1}{blockTrial,4} = actionProbs;
            %actionsMade{1,1}{blockTrial,5} = actionProbStores;
            
        end
        
    end
    
    
end
actionsMade{1,2} = history;
clear history
end