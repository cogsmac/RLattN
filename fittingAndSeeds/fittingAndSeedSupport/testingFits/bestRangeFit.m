%{

The best range files are for determining which parameters work best over the whole experiment and not just individuals. 

Author: Jordan, Aug 2011

%}


function [paramBest,fitVal,searchConverged,searchHistory] = bestRangeFit(sExperiment)

lowerBound = [.01 -10 0 0 -30 0.01];
upperBound = [.2 0 10 30 0 0.9999];

searchOptions = optimset('Display','off','MaxFunEvals',6000,'MaxIter',100,'FunValCheck','on');

alp = rand/10;
accessCost = ceil(-(6)*rand);
novelInformationBonus = floor((6)*rand);
corrDecisionIn = floor((21)*rand);
incorrDecisionIn = ceil(-(11)*rand);  
%suppProp = floor((6)*rand);
temp = rand;



paramVec = [alp accessCost novelInformationBonus corrDecisionIn incorrDecisionIn temp]   

paramVec = [0.0933 -1.9987 1.9994 12.5063 -12.2420 0.5]

[paramBest,fitVal,searchConverged,searchHistory] = fminsearchbnd(@bestRangeFitVal,paramVec,lowerBound, upperBound, searchOptions,sExperiment)
