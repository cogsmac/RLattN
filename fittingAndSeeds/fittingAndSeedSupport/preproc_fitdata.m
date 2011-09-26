function cell_out = preproc_fitdata(cell_in)
    %
    % output cell columns (1 row):
    % 1. subject number
    % 2. diff on error trials
    % 3. diff on correct trials
    % 4. total number of errors
    % 5. i put all the original outputs in for now just to test how long/how
    %    much memory it'll take (2 columns)
    % Bill Chen. 
    
    subject = cell_in{1}(1,1);

    trial = cell_in{1}(:,2);
    acc = cell_in{1}(:,11);

    fdiff = diff(cell_in{1}(:,12:14)); %pulling in the attention. indexing the begining of the dimension attention

    totaldiff = sum(abs(fdiff), 2);

    % attach trial number for later identification
    totaldiff = [trial(1:end-1) totaldiff];

    % changes on error trials
    errdiff = totaldiff(acc(1:end-1)==0,:);

    % changes on correct trials
    corrdiff = totaldiff(acc(1:end-1)==1,:);

    % number of errors
    numerr = sum(~acc);
    
    a = {subject errdiff corrdiff numerr};

    cell_out = [{subject errdiff corrdiff numerr}];
    
end
