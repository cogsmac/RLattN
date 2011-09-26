% Dichotomize based on the average number of fixation

function [cellOutput compare] = fixationCheck(frandsearchRLOutput)

[error correct] = analyzeattention(frandsearchRLOutput);

for j= 1:length(frandsearchRLOutput)
    for i = 1:360
        
        numberOfFix{i} = frandsearchRLOutput{j,7}{i,1};
        cellOutput{j,2}(i)=length(cell2mat(numberOfFix(i)));
        cellOutput{j,3}{i,1} = numberOfFix(i);
        
    end
    
    avgLength(:,j) = mean(cellOutput{j,2}(:));
    
end


compare = [error avgLength'];

% Scatter the compare matrix if wanted.
% scatter(compare(:,1),compare(:,2))
