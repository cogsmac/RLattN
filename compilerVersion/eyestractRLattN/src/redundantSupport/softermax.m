% Softer max is an implementation of the softmax decision rule that employs
% a temperature parameter for use in reinforcement learning.

% Takes temperature, possibleActionVect as input; outputs the probability
% of selecting an action.

%Author: Caitlyn McColeman
%Date: February 21 2011

%NOT reviewed
%NOT verified
function P = softerMax(possibleActionVect, temp)

for action=1:length(possibleActionVect)
    P(action) = (exp(possibleActionVect(action)/temp))./sum(exp(possibleActionVect)/temp);
end