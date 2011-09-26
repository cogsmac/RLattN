%{
getLearners.m returns a set of simulated subjects that only contains learners
JB: May 28, 2011
%}

all = mysqlcheck(['SELECT Subject FROM `SSHRC_IFExpLvl`'])
learners = mysqlcheck(['SELECT Subject FROM `SSHRC_IFExpLvl` WHERE cp > 0'])

[f locale] = ismember(learners,all)
randLearners = []
localeIter = 1

for i = 1:46
   for k = 1:100
       sub = ((locale(i)-1)*100)+k
       randLearners = [randLearners;randOutputStripped(sub,:)];
   end
end