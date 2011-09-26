%This function calculates error bias by looking at q matrix differences
%between trials.
%Author: Jordan Barnes, Sep 20, 2011.

function ebs = qmatEBs(output)
    ebs = []
    for i = 1:length(output)
        err = output{i,8}{4}{1};
        corr = output{i,8}{4}{2};
        ebs = [ebs;sum(mean(abs(err)))/(sum(mean(abs(corr)))+sum(mean(abs(err))))];
    end

end