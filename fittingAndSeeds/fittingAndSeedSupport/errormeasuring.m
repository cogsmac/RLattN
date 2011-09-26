%{
This file handles all the error-bias measure calculations
March 1, 2011
Jordan Barnes
%}


function actionSubs1 = errormeasuring(actionSubs)
    actionSubs1 = [];

    for insubIter = 1:length(actionSubs{1})
        actionVec = cell2mat(actionSubs{1}(insubIter,1));
        %Setting the feature attention weights to the same kind of
        %proportions we used before and storing them in the right
        %place.
        if isempty(actionVec)
            actionSubs1(insubIter,12) = 0;
            actionSubs1(insubIter,13) = 0;
            actionSubs1(insubIter,14) = 0;
        else
            actionSubs1(insubIter,12) = length(find(actionVec == 1))/length(actionVec);
            actionSubs1(insubIter,13) = length(find(actionVec == 2))/length(actionVec);
            actionSubs1(insubIter,14) = length(find(actionVec == 3))/length(actionVec);
        end 
        %Setting accuracy to the right place
        actionSubs1(insubIter,11) = actionSubs{1}{insubIter,3};     
        actionSubs1(insubIter,1) = 1;
        actionSubs1(insubIter,2) = insubIter;
    end

end