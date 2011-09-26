%RashnlFit
%Overview - Controls the data fitting process. This file accesses
%RashnlModel for the parameter settings passed into it by fminsearch. 
function [ fitval ] = bestRangeFitVal(paramVector,sExperiment)
    
	paramVector
    fitval = bestRange(sExperiment,paramVector); %gets the experimental results for a particular set of parameters supplied by fminsearch

end
