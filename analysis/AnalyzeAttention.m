function [errorAttentionTotal, correctAttentionTotal] = AnalyzeAttention(attentionResults)
%Produces means for change on error trials and change on correct trials. 
%Precondition. attentionResults is initialized and has the structure
%indicated in the documentation ModelOutputDocs
%Postcondition. we are outputting means for change in attention on error
%trials vs correct trials. CalenW2010


%a nice way to quickly visualize this stuff. a is the output vector you
%want to histogramify figure;hist(a,20);xlim([0,1]);ylim([0,50]);title('error ET3');xlabel('percentage diff');ylabel('number of subjects');

    %Overall Change data
    subjectMeanErrorTotal = [];
    subjectMeanCorrectTotal = [];
    
    analysisCount = length(attentionResults(:,1)); %number of iterations we need to do is dependent on how many model parameters we are analyzing
    
    for i = 1:analysisCount
       w = [];
        subjectData = attentionResults{i,3}; %gives a cell array containing model data
        w = [];
        %total data
        subjectMeanErrorTotal = [subjectMeanErrorTotal;nanmean(subjectData{2}(:,2))/(nanmean(subjectData{2}(:,2))+nanmean(subjectData{3}(:,2)))];
        subjectMeanCorrectTotal = [subjectMeanCorrectTotal;nanmean(subjectData{3}(:,2))/(nanmean(subjectData{2}(:,2))+nanmean(subjectData{3}(:,2)))];
        

        
    end


    errorAttentionTotal = subjectMeanErrorTotal;
    correctAttentionTotal = subjectMeanCorrectTotal;
end