%RashnlFit
%Overview - Controls the data fitting process. This file accesses
%RashnlModel for the parameter settings passed into it by fminsearch. 
function [ fitval ] = RashnlFit(paramVector, experStruct)
    
    fitval = 0.0;
    
    output = RLattN(experStruct, paramVector); %gets the experimental results for a particular set of parameters supplied by fminsearch

    
    if ~isempty(output)
        fitval = getFitVal(experStruct,output);    %we need to calculate the distance of the teacher values from the outprobs. 
       
        
    end
end