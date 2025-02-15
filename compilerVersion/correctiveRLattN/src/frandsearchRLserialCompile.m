%{

Author: Jordan. June, 2011.
This file is a modification of the main frandsearchRL.m file to be able to
handle serial job compilations for processing on WestGrid. Try to keep this
file as close as possible to the original file. It is not good to have two
copies like this but it is necessary in this case. This file will only do
fitting.



%}


%The first change is to allow a fit number as input

function grandOutput = frandsearchRLserialCompile(fitNum)

    grandOutput = [];
    sExperiment = 'sshrc_if';
    fitNum
    fitNum = str2num(fitNum);
    %---------------------------------------------------------------------------------------------

    lowerBound = [.01 -2 0 0 -30 0];
    upperBound = [.2 0 2 30 0 6];
    searchOptions = optimset('Display','off','MaxFunEvals',6000,'MaxIter',5000,'FunValCheck','on');

    load('sshrc_ifPresentedStims.mat')
    addpath(genpath('./'))
    alp = rand/10;
    accessCost = ceil(-(6)*rand);
    novelInformationBonus = floor((6)*rand);
    corrDecisionIn = floor((21)*rand);
    incorrDecisionIn = ceil(-(11)*rand);  
    suppProp = floor((6)*rand);
    paramVec = [alp accessCost novelInformationBonus corrDecisionIn incorrDecisionIn suppProp]   


    RLattNinStruct.actionMax = 7;
    RLattNinStruct.stateMax = 27;
    RLattNinStruct.featureMax = 3;
    RLattNinStruct.categoryMax = 4;
    RLattNinStruct.stimuli = stimPresentationOrder{fitNum,2}(:,1:3);
    RLattNinStruct.response = stimPresentationOrder{fitNum,2}(:,5);  % Grab the human responses.   
    RLattNinStruct.acc = stimPresentationOrder{fitNum,2}(:,6); % Grabs the accuracy - JB April 29, 2011

    i = 0;
    while i == 0

        if ~isempty(RLattN(RLattNinStruct, paramVec)) %trys to avoid putting seeds that lead to model crash.
            [paramBest,fitVal,searchConverged,searchHistory] = ...
                fminsearchbnd(@RLattNFit,paramVec,lowerBound, upperBound, searchOptions,RLattNinStruct)


            %takes the parameter settings returned from the fminsearch and uses
            %these`
            %to produce some subject data.
            bestfitresults = RLattN(RLattNinStruct, paramBest);

            g = []

            if isempty(bestfitresults) 
                return; %return because the data contained NaNs
            end


            if sum(cell2mat(bestfitresults{1,1}(:,3)))>0


                %in order to have the results of this process be compatible with the rest
                %of the visualization scripts we need to keep the data structure
                %consistent.
                %formattedFit = formatOutput(bestfitresults,RLattNinStruct);

                formattedFit = errormeasuring(bestfitresults);

                %the variable output can be passed into various analysis and visualization
                %scripts.
                if exist(['grandOutput.mat'])
                    load('grandOutput.mat')
                    grandOutput = [grandOutput;{formattedFit} {paramBest} {preproc_fitdata({formattedFit})} {fitVal} {searchConverged} {searchHistory}];
                    save './grandOutput.mat' grandOutput
                else
                    grandOutput = [grandOutput;{formattedFit} {paramBest} {preproc_fitdata({formattedFit})} {fitVal} {searchConverged} {searchHistory}];
                    save './grandOutput.mat' grandOutput
                end
                i = 1;
            end
        end
    end
                  

end
