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
    temp = params(7) ; % Set constant to look at other parameters. Temp may have to be held constant. CM
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

                            %This way of finding the 
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

                        novelInformationAccessed = 0;
                        tdError = V(currentState) + reinforcement - V(previousState) ;
                        V(previousState) = V(previousState) + alp*(tdError)         ;
                        Q(previousState,action) = Q(previousState,action) + alp*(tdError);
                        if dataDisplayOn == 1
                            DataDisplay(knownStimulusValues,Q,V,currentState,block,blockTrial);
                        end     

                        actionsMade{1,1}{blockTrial,1} = fixationOrder; 
                        history.(['trial' num2str(blockTrial)]).Q = Q;
                        history.(['trial' num2str(blockTrial)]).V = V;
                        history.(['trial' num2str(blockTrial)]).known = knownStimulusValues;

                    else  %  a decision is made                           

                        previousState = currentState;
                        currentState = stateMax + action - featureMax; %The adding and subtracting make 28-31 be the category decision states

                        %Compare system response to correct response.
                        trialAccuracy = isequal(action-featureMax,response(blockTrial)); %get this information from the correct, incorrect portion of experimentStruct.

                        expAcc = [expAcc, trialAccuracy];

                        %not really sure why the old way of applying reinforcement
                        %is used... i must not have been a party to the decision...CW 
                        %We can go back that way if need be. 
                        if trialAccuracy == 1
                            %reinforcement = corrDecision{numSubs,1}(blockTrial);
                            reinforcement = correctDecisionReward;
                        else
                            reinforcement = incorrectDecisionReward;
                            %reinforcement = incorrDecision{numSubs,1}(blockTrial);
                        end

                        %Calculate TD error and apply it to Q and V matrices
                        tdError = V(currentState) + reinforcement - V(previousState);
                        
                        Q(previousState,action) = Q(previousState,action) + alp*(tdError) ;
                        
                        %% CorrectiveBlock - JB, Aug 18, 2011
                        actionVec = [featureMax+1:1:actionMax];
                        suppProp = params(6);
                        if trialAccuracy == 1
                            suppReward = incorrectDecisionReward/suppProp; 
                            supptdError = V(currentState) + suppReward - V(previousState);
                            
                            for corrIter = 1:categoryMax
                                if actionVec(corrIter) ~= action
                                    Q(previousState,actionVec(corrIter)) = Q(previousState,actionVec(corrIter)) + alp*(supptdError);
                                end
                            end
                            
                            
                        else
                            suppReward = correctDecisionReward/suppProp;
                            suppNegReward = incorrectDecisionReward/suppProp;
                            supptdError = V(currentState) + suppReward - V(previousState);
                            suppNegtdError = V(currentState) + suppNegReward - V(previousState);
                            feedbackAction = featureMax + response(blockTrial);
                            Q(previousState,feedbackAction) = Q(previousState,feedbackAction) + alp*(supptdError) ;    
                            for corrIter = 1:categoryMax
                                if (actionVec(corrIter) ~= action) && (actionVec(corrIter) ~= feedbackAction)
                                    Q(previousState,actionVec(corrIter)) = Q(previousState,actionVec(corrIter)) + alp*(suppNegtdError) ;
                                end
                            end                            
                        end
                        %%
                        
                        V(previousState) = V(previousState) + alp*(tdError);
                        
                        
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