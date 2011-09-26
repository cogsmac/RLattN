%{
This function gives a nice little replay to see what the heck happened 
during a RLattN run.

author: Jordan B. Spring 2011
%}


function replays(input,subjectNum)

    history = input{subjectNum,5}
    for trialNum = 1:360
        Q = history.(['trial' num2str(trialNum)]).Q
        V = history.(['trial' num2str(trialNum)]).V
        knownVals = history.(['trial' num2str(trialNum)]).known
        DataDisplay(knownVals,Q,V,1,1,trialNum)
        %keyboard;
    end
end