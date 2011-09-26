% This function will collect the stimuli presented to human participants
% in an experiment. Developed for use in RLAttN.

% Caitlyn McColeman
% February 23 2011

% NOT reviewed
% NOT verified

function stimPresentationOrder = presentedStims(sExperiment)

status = MaybeOpenMySQL;

% Takes the experiment name as INPUT
% OUTPUTs a cell array called stimPresentationOrder
% The first column of cells is subject number, the second column of cells is feature order, and the third is response info.


% Because our experiments are set up a little differently in the PMA
% tables, we can work through cases.

sExperiment = lower(sExperiment); %Ensures input is case-matched to possible saved .mat files.
alreadyDone = exist([sExperiment 'PresentedStims.mat']); % Check if we've already saved the stimPresenation output in the path.

if alreadyDone ~= 0 % Take the output from the last time we ran this experiment
    display(['presentedStims already run for ' sExperiment '. Loading .mat file'])
    stimPresentationOrder = load([sExperiment 'PresentedStims.mat']);
    
    %As awkward as this looks, it goes into the saved data .mat file and
    %pulls the variable data that would be output if we ran through this whole
    %script.
    stimPresentationOrder = stimPresentationOrder.stimPresentationOrder;
    
    
else % Select the stimulus presentation order from the PMA
    
    % Initialize the output.
    %stimPresentationOrder = {};
    
    switch sExperiment % Go through possible experiments; make lower case for better matching
        
        
        case {'sshrc_if', 'clif'} % NOT seperated into feedback conditions as of now. Set to 100% condition for testing.
            numSubs = mysqlcheck(['SELECT Subject FROM ' sExperiment 'ExpLvl WHERE SubjectCondition = 1 AND CP>0']);
            maxTrial = mysqlcheck(['SELECT max(TrialID) FROM ' sExperiment 'TrialLvl WHERE Subject = ' num2str(numSubs(1))]); %use the first subject to check the number of trials in an exp.
            
            for i=1:length(numSubs) % Loop through subjects
                stimPresentationOrder{i,1}=numSubs(i);
                
                for j=1:maxTrial % Loop through trials
                    
                    % Feature values
                    [f1 f2 f3] = mysqlcheck(['SELECT Feature1Value, Feature2Value, Feature3Value FROM ' sExperiment 'TrialLvl WHERE TrialID = ' num2str(j) ' AND Subject = ' num2str(numSubs(i))]);
                    
                    % Add feature values to output array
                    stimPresentationOrder{i,2}(j,1:3)=[f1+1 f2+1 f3+1]; %Features in table as binary values. Recode to 1 and 2 from 0 and 1 to work with the full factorial state definition in RLAttN.
                    
                    % Collect the response information (actual response, correct answer)
                    [resp corrResp acc] = mysqlcheck(['SELECT Response, CorrectResponse, TrialAccuracy FROM ' sExperiment 'TrialLvl WHERE TrialID = ' num2str(j) ' AND Subject = ' num2str(numSubs(i))]);
                    
                    % Add response information to the output array
                    stimPresentationOrder{i,3}(j,1)=resp;
                    stimPresentationOrder{i,3}(j,2)=corrResp;
                end
                
                respConv=responseConversion(stimPresentationOrder{i,3}(:,1));
                respConv1=responseConversion(stimPresentationOrder{i,3}(:,2));
                
                stimPresentationOrder{i,2}(:,4)=respConv;
                stimPresentationOrder{i,2}(:,5)=respConv1;
                stimPresentationOrder{i,2}(:,6)=acc;
                
                display(['Collected stimulus presentation order for subject # ' num2str(numSubs(i))])
                
            end
            
        case {'eyetrack3', 'asset'}
            % Subject list will exclude crashers.
            
            if strcmp(sExperiment, 'eyetrack3')
                numSubs = mysqlcheck(['SELECT Subject FROM Eyetrack3ExpLvl WHERE Subject <> 1001 AND Subject <> 1004 AND Subject <> 1018 AND Subject <> 1019 AND Subject <> 1025 AND Subject <> 1027 AND Subject <> 1040 AND Subject <> 1047 AND CP>0']);
            else
                [numSubs criterionPoint] = mysqlcheck('SELECT Subject, CP FROM ASSETExpLvl');
            end
            
            for i=1:length(numSubs) % Loop through subjects
                stimPresentationOrder{i,1}=numSubs(i);
                maxTrial = mysqlcheck(['SELECT max(TrialID) FROM ' sExperiment 'TrialLvl WHERE Subject = ' num2str(numSubs(i))]); %variable number of trials; get maxID from all subjects.
                
                [f1 f2 f3] = mysqlcheck(['SELECT Feature1Value, Feature2Value, Feature3Value FROM ' sExperiment 'TrialLvl WHERE Subject = ' num2str(numSubs(i))]);
                % Collect the response information (actual response, % correct answer)
                
                [resp corrResp acc] = mysqlcheck(['SELECT Response, CorrectResponse, TrialAccuracy FROM ' sExperiment 'TrialLvl WHERE Subject = ' num2str(numSubs(i))]);
                
                
                
                for j=1:maxTrial % Loop through trials
                    
                    
                    % Add feature values to output array
                    stimPresentationOrder{i,2}(j,1:3)=[f1(j)+1 f2(j)+1 f3(j)+1]; %Features in table as binary values. Recode to 1 and 2 from 0 and 1 to work with the full factorial state definition in RLAttN.
                    
                end
                
                % Add response information to the output array
                
                stimPresentationOrder{i,3}(:,1)=resp;
                stimPresentationOrder{i,3}(:,2)=corrResp;
                
                respConv=responseConversion(stimPresentationOrder{i,3}(:,1));
                respConv1=responseConversion(stimPresentationOrder{i,3}(:,2));
                
                stimPresentationOrder{i,2}(:,4)=respConv;
                stimPresentationOrder{i,2}(:,5)=respConv1;
                stimPresentationOrder{i,2}(:,6)=acc;
                
                display(['Collected stimulus presentation order for subject # ' num2str(numSubs(i))])
                
                stimPresentationOrder{i,4}=criterionPoint(i);
                
            end
            
        case {'5to1'}
            % This will take only those assigned to the 1:1 condition
            numSubs = mysqlcheck('SELECT Subject FROM 5to1ExpLvl WHERE Proportions = ''5:1''');
            
            for i=1:length(numSubs)
                stimPresentationOrder{i,1}=numSubs(i);
                maxTrial = mysqlcheck(['SELECT max(TrialID) FROM 5to1TrialLvl WHERE Subject = ' num2str(numSubs(i)) ]);
                
                %for j=1:maxTrial % Loop through trials
                    
                    % Feature values
                    [f1 f2 f3] = mysqlcheck(['SELECT Feature1Value, Feature2Value, Feature3Value FROM ' sExperiment 'TrialLvl WHERE Subject = ' num2str(numSubs(i))]);
                    
                    % Add feature values to output array
                    stimPresentationOrder{i,2}(:,1:3)=[f1+1 f2+1 f3+1]; %Features in table as binary values. Recode to 1 and 2 from 0 and 1 to work with the full factorial state definition in RLAttN.
                    
                    % Collect the response information (actual response, correct answer)
                    [resp corrResp acc] = mysqlcheck(['SELECT Response, CorrectResponse, TrialAccuracy FROM ' sExperiment 'TrialLvl WHERE Subject = ' num2str(numSubs(i))]);
                    
                    % Add response information to the output array
                    stimPresentationOrder{i,3}(:,1)=resp;
                    stimPresentationOrder{i,3}(:,2)=corrResp;
            %    end
                
                respConv=responseConversion(stimPresentationOrder{i,3}(:,1));
                respConv1=responseConversion(stimPresentationOrder{i,3}(:,2));
                
                stimPresentationOrder{i,2}(:,4)=respConv;
                stimPresentationOrder{i,2}(:,5)=respConv1;
                stimPresentationOrder{i,2}(:,6)=acc;
                %woot = gnarly call
                %woot1 = the first one
                %stimPresentationOrder{i,2}(:,7)=gnarly
                
                display(['Collected stimulus presentation order for subject # ' num2str(numSubs(i))])
            end
            
        otherwise
            
            display('The experiment is not defined in presentedStims.m. ') % Have to populate this so it can take more experiments.
            
    end
    
    save (['~/Desktop/' sExperiment 'PresentedStims.mat']); % Saves to the desktop
    
    
end

MaybeCloseMySQL(status);