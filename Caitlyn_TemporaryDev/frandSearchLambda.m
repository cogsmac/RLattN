function grandOutput = frandsearchRL(sExperiment)


    randSeed = 0;
    fitting = 1;

    learnPercIn = 9;
    learnPerc = num2str(ones(1,learnPercIn));    
    
    %These are good parameters that are known to work
    %paramInit = [.75 -1 2 25 -10];
    
    paramInit = [.75 -1 2 25 -10];
    
    
    stimPresentationOrder = presentedStims(sExperiment); 
    
    RLattNinStruct.actionMax = 7;
    RLattNinStruct.stateMax = 27;
    RLattNinStruct.featureMax = 3;
    RLattNinStruct.categoryMax = 4;

                
    grandOutput = [];
    
    if randSeed == 1


       
        stimPresentationOrder = presentedStims(sExperiment);      


        for numSubs = 1:1%length(stimPresentationOrder)
        
            learnerCounter = 0   ;
            missedCounter = 0;
            RLattNinStruct.stimuli = stimPresentationOrder{numSubs,2}(:,1:3);
            %'response' here is actually the objective 'correct response'
            RLattNinStruct.response = stimPresentationOrder{numSubs,2}(:,5);  
            

            while learnerCounter < 100

              

                alp = rand;
                accessCost = ceil(-(6)*rand);
                novelInformationBonus = floor((6)*rand);
                corrDecisionIn = floor((21)*rand);
                incorrDecisionIn = ceil(-(11)*rand);                
                paramVec = [alp accessCost novelInformationBonus corrDecisionIn incorrDecisionIn]     
                

                
                newoutput = RLattNlambda(RLattNinStruct, paramVec);
                
                % Create a vector of first fixations.
                % This section is for our information access investigation.
                % Comment it out if you'd like.
                for fixForTrial=1:length(newoutput{1,1})
                   allFixes = newoutput{1,1}(fixForTrial,1);
                   if isempty(allFixes{1,1})
                   
                   else
                   firstFix(fixForTrial,1)=allFixes{1,1}(1,1);    
                   end
                end

                
                %This returns all of the attentional change information we
                %need in order to do further processing. 
                processedOutput = errorMeasuring(newoutput);   
                
                
                %actionStorage = {};
                %probStorage = {};
                for insubIter = 1:length(newoutput{1})
                        actionVec = cell2mat(newoutput{1}(insubIter,1));   
                        %initProbs = cell2mat(newoutput{1}(insubIter,5)); 
                        actionStorage{insubIter,1} = actionVec;
                        %probStorage{insubIter,1} = initProbs;
                end
                
                
                if strfind(num2str(cell2mat(newoutput{1}(:,3)')),learnPerc) > 0
                    display('learner')
                    missedCounter = missedCounter - 1;
                    learnerCounter = learnerCounter + 1
                    [numSubs learnerCounter missedCounter]
                    grandOutput = [grandOutput;{processedOutput} {paramVec},{preproc_fitdata({processedOutput})}, missedCounter, newoutput{1,2}, {firstFix}];  %  , newoutput{1,1}(:,2)        
                else
                    missedCounter = missedCounter + 1;
                end


            %%%    
            end


        end  
    %{    
    hist(grandOutput(:,1),100)
    xlim([0,1])
    title(['Reinforcement Learner on ' sExperiment])
    xlabel('Proportion of change after error')
    ylabel('Number of subjects')   
    %}
        
    end
    
 
    
    
    if fitting == 1
    
        %---------------------------------------------------------------------------------------------
        % Call fminsearch.

        %sets the upper and lower bounds for the parameter search to be used with
        %fminsearchbnd
        %[alp temp accessCost novelInformationBonus corrDecisionIn incorrDecisionIn];
        %           lowerBound = [.01 .5 -40 0 0 -40];
        %           upperBound = [.99 .99 0 40 40 0];
        lowerBound = [.01 -200 0 0 -200 0.01]; % Temperature is NOT included here; change made in 
                                        % RLAttN to reflect what is now
                                        % FIVE parameters
        upperBound = [.99 0 200 200 0 0.99];
        searchOptions = optimset('Display','off','FunValCheck','on')%, 'TolFun', 0.02);
        stimPresentationOrder = presentedStims(sExperiment);
        
        for numSubs = 1:1%length(stimPresentationOrder)
            i = 1;
            while i <= 1
                
                
                alp = rand;
                accessCost = ceil(-(201)*rand);
                novelInformationBonus = floor((201)*rand);
                corrDecisionIn = floor((201)*rand);
                incorrDecisionIn = ceil(-(201)*rand); 
                lambda=rand;
                
                paramVec = [alp accessCost novelInformationBonus corrDecisionIn incorrDecisionIn lambda];                
                
                
                display(['On subject #' num2str(numSubs) ' and fit #' num2str(i) ' The current input params are:'])
                paramVec
                
                RLattNinStruct.actionMax = 7;
                RLattNinStruct.stateMax = 27;
                RLattNinStruct.featureMax = 3;
                RLattNinStruct.categoryMax = 4;
                RLattNinStruct.stimuli = stimPresentationOrder{numSubs,2}(:,1:3);
                RLattNinStruct.response = stimPresentationOrder{numSubs,2}(:,4);  % Grab the human responses.   
                RLattNinStruct.acc = stimPresentationOrder{numSubs,2}(:,6); % Grabs the accuracy - JB April 29, 2011



                if ~isempty(RLattNLambda(RLattNinStruct, paramVec)) %trys to avoid putting seeds that lead to model crash.
                    [paramBest,fitVal,searchConverged,searchHistory] = ...
                        fminsearchbnd(@RLattNLambdaFit,paramVec,lowerBound, upperBound, searchOptions,RLattNinStruct)


                    %takes the parameter settings returned from the fminsearch and uses
                    %these`
                    %to produce some subject data.
                    bestfitresults = RLattNlambda(RLattNinStruct, paramBest);



                    if isempty(bestfitresults)
                        return; %return because the data contained NaNs
                    end
                    
                    if sum(cell2mat(bestfitresults{1,1}(:,3)))>0
                    
                        %in order to have the results of this process be compatible with the rest
                        %of the visualization scripts we need to keep the data structure
                        %consistent.
                        %formattedFit = formatOutput(bestfitresults,RLattNinStruct);

                        formattedFit = errorMeasuring(bestfitresults);

                        %the variable output can be passed into various analysis and visualization
                        %scripts.

                        grandOutput = [grandOutput;{formattedFit} {paramBest} {preproc_fitdata({formattedFit})} {fitVal} {searchConverged} {searchHistory} {bestfitresults{1,1}(:,1)}];

                        disp(paramBest);
                        save '~/Desktop/highFit.mat' grandOutput
                        i=i+1
                    end
                end
                
            end
        end
    end
    
    

end