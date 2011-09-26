%formatOutput
%Overview - This file takes output from RashnlModel and converts into into
%a data structure that is consistent with the other data analysis and data
%visualization files. 
function formattedoutput = formatOutput(output,experStruct)
    formattedoutput = [];%returns empty if the output contained NaNs
    outSize = size(experStruct.response,1);
    if ~isempty(output)
        %%%%reorganizing the model data.%%%%
        %finds the index for the correct category in each trial. stored in
        %a
        
        %Not sure sure about this - JB 2011
        a = experStruct.response;
        i = cell2mat(output{1}(:,2));

        %gets rid of the 4 columns associated with the teacher values and
        %replaces this with a category number. easier for reading.
        
        %Seems old, from Rashnl
        %output{1} = [output{1}(:,1:5), a, output{1}(:,6+outSize:end)];

        %this tells us the column finds out which output probability was
        %highest. it will be used to compare with the teacher value to see
        %if the model got it right.


        %{
   
        %This loop is going to overwrite the i column.

        i = [];
        weightedChoice = rand;

        if outSize == 4

            for n = 1:length(output{1})
                if weightedChoice <= output{1}(n,7)
                    i = [i; 1];
                elseif (weightedChoice > output{1}(n,7)) & (weightedChoice <= (output{1}(n,8) + output{1}(n,7)))
                    i = [i; 2];
                elseif (weightedChoice > (output{1}(n,8) + output{1}(n,7))) & (weightedChoice <= (output{1}(n,8) + output{1}(n,7) + output{1}(n,9)))
                    i = [i; 3];
                else
                    i = [i; 4];
                end
            end

        elseif outSize == 2

            for n = 1:length(output{1})
                if weightedChoice <= output{1}(n,7)
                    i = [i; 1];
                else
                    i = [i; 2];
                end
            end                

        end

        %}    


        %output{1}(:,end + 1) = a == i;
        
        output{1} = [output{1} output{2}{1}];        
        
                
        output{1}(:,end + 1) = i;
        
        %formatting output for the category that the subject chose. putting
        %that in the output matrix. 
        [a,b] = find(experStruct.response == 1);
        
        output{1}(:,end + 1) = a;

        newoutput = output{1};

        formattedoutput = newoutput;
        %%%
    end
    
end