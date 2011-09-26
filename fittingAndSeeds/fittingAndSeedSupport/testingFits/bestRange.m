function grandOutput = bestRange(sExperiment, paramVec)

stimPresentationOrder = presentedStims(sExperiment);     
missedCounter = 0;
learnPercIn = 9;
learnPerc = num2str(ones(1,learnPercIn));

RLattNinStruct.actionMax = 7;
RLattNinStruct.stateMax = 27;
RLattNinStruct.featureMax = 3;
RLattNinStruct.categoryMax = 4;

grandOutput = [];

    for numSubs = 1:length(stimPresentationOrder)

        learnerCounter = 0;
        RLattNinStruct.stimuli = stimPresentationOrder{numSubs,2}(:,1:3);
        %'response' here is actually the objective 'correct response'
        RLattNinStruct.response = stimPresentationOrder{numSubs,2}(:,5);
        
        while learnerCounter < 10

            newoutput = RLattN(RLattNinStruct, paramVec); 
            
            
            %% This stuff needn't be here if all want is fit values.
            
            
            processedOutput = errorMeasuring(newoutput);             
            for insubIter = 1:length(newoutput{1})
                    actionVec = cell2mat(newoutput{1}(insubIter,1));   
                    actionStorage{insubIter,1} = actionVec;
            end            
            
            
            
            
            %%                                

            if strfind(num2str(cell2mat(newoutput{1}(:,3)')),learnPerc) > 0
                display('learner')
                learnerCounter = learnerCounter + 1
                paramVec
                grandOutput = [grandOutput;{processedOutput} {paramVec},{preproc_fitdata({processedOutput})}, missedCounter, newoutput{1,2}];
            else
                missedCounter = missedCounter + 1
            end
            if missedCounter > 1000
                missedCounter = inf;
                paramVec
                return
            end 
               
        %%%    
        end


    end
end