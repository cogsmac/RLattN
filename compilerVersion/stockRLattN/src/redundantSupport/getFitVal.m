%Precondition - experStruct has been initialized.
%output has been initialized by a model run with a set of parameters. 
%Postcondition - fitval has been set by taking the outprob from the model
%run and the actual human subjects response for each trial. The mean square
%error is taken on the difference between these two values.
function [ fitval ] = getFitVal(experStruct, output)

    %subject = experStruct.response; %retrives subject data
    subject = experStruct.acc; %retrives subject accuracy
    correSize = size(output{1},2);
    
    outSize = size(experStruct.response,1);
    
    if ~isempty(output)
        %This was the syntax for Rashnl.
        %model = output{1,1}(:,correSize - outSize + 1:correSize)';
        
        %model = cell2mat(output{1}(:,2)); %Again. if we wanted the
        %response pattern, not the accuracy.
        model = cell2mat(output{1}(:,3)); %Grabs the accuracy.
        

        fitval = sum((subject~=model)/length(model)); %count of mismatches

        % between subject and model; standardized as proportion by dividing 
        % by the number of trials.
        
        %%% ALTERNATIVE FIT: Mean square error
        %fitval = (subject-model).^2/length(model)
        
    else
        fitval = Inf;
    end

end