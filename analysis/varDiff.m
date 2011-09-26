%{

"Author" (this is in scare quotes for a reason): Jordan. April 2011.

This file is simply a scratchpad for some error bias testing I was doing
on RLattN, at different levels of error. It will not be documented so have
fun with :)





e = [];
for i = 1:6700
e = [e;randOutput{i,3}{4}];
end

lowError = randOutput(find(e<46),:);
[f g] = analyzeAttention(lowError);
hist(f,100)
title('Less than 46 errors')
figure
highError = randOutput(find(e>=46),:);
[h i] = analyzeAttention(highError);
hist(h,100)
title('More than 46 errors')

mean(cell2mat(lowError(:,2)))
mean(cell2mat(highError(:,2)))

lowNew = [f cell2mat(lowError(:,2))]
first = lowNew(find(lowNew(:,1)<0.78),:)
second = lowNew(find(lowNew(:,1)>=0.78),:)

mean(first)
mean(second)


highNew = [h cell2mat(highError(:,2))]
highfirst = highNew(find(highNew(:,1)<0.78),:)
highsecond = highNew(find(highNew(:,1)>=0.78),:)

mean(highfirst)
mean(highsecond)

ebxtrialNum = []
for i = 1:length(highError)
    ebxtrialNum = [ebxtrialNum; highError{i,3}{2}];
end
[x y] = consolidator(ebxtrialNum(:,1),ebxtrialNum(:,2),'mean')
[x z] = consolidator(ebxtrialNum(:,1),ebxtrialNum(:,2),'count')
ebytrialNum = [x y z];
sorted = sortrows(ebytrialNum);
scatter3(sorted(:,1),sorted(:,2), sorted(:,3))
%}


errNums = []
for i = 1:length(randOutput)
    errNums = [errNums; randOutput{i,3}{4}];
end

fullMat = []

uniqueErrs = unique(errNums)
for i = 1:length(uniqueErrs)
    randMode = randOutput(errNums==uniqueErrs(i),:)

    ebxtrialNumMode = []
    for j = 1:size(randMode)
        ebxtrialNumMode = [ebxtrialNumMode; randMode{j,3}{2}];
    end
    [x y] = consolidator(ebxtrialNumMode(:,1),ebxtrialNumMode(:,2),'mean')
    fullMat = [fullMat; x y uniqueErrs(i)*ones(1,length(x))'];
    
end

scatter3(fullMat(:,1),fullMat(:,2),fullMat(:,3))

%{

    [x y] = consolidator(ebxtrialNumMode(:,1),ebxtrialNumMode(:,2),'mean')
    ebytrialNum = [x y];
sorted = sortrows(ebytrialNum);
scatter(sorted(:,1),sorted(:,2))
%}
