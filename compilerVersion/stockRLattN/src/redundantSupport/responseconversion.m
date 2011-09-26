% This function will collect change the variable letter responses (e.g.
% 'Q', 'S', 'A1') to numerical responses 1-4 in all experiments with four
% categories. For use in RLAttN.

% Caitlyn McColeman
% February 23 2011

% NOT reviewed
% NOT verified

function numericalResponses = responseconversion(tableValues)

% Takes the unconverted responses from the PMA tables (vector) as INPUT
% OUTPUTs a vector of numerical responses.

% What are the possible category responses?
possibleCats = unique(tableValues);

%Sort the values so that the conversion is consistent for every use in an
%experiment
sort(possibleCats);

% Initalize the output vector
numericalResponses = nan(length(tableValues),1);

index1=zeros(length(tableValues),1) ;
% Loop through... Although there should be strcmpi logical alternative.
for i = 1:length(possibleCats) % Through possible categories
    % Reset logic and indexes
    index1 = [];
    makeLogical = [];
    
    if numel(possibleCats{i})>1 % For categories named something like A1 vs A2
        for j = 1:length(tableValues) % For each trial
            trueOrFalse=possibleCats{i}==tableValues{j}; % Logical check
            if sum(trueOrFalse)==numel(possibleCats{1});   % All elements match
                index1(j)=1; %Set index value to one.
                makeLogical=index1==1; % Turn the vector from double to logical values.
            end
        end
    else
        for j = 1:length(tableValues)
            trueOrFalse=possibleCats{i}==tableValues{j};
            index1(j)=trueOrFalse(1,1);
            makeLogical=index1==1; % Turn the vector from double to logical values.
        end
    end
    numericalResponses(makeLogical)=i;
end