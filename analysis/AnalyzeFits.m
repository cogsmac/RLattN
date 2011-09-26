%AnalyzeFits - The model output from fitting subjects will be formatted and
%analyzed.
%
%Precondition: modelOutput is a cell array that has been populated with
%output from model fits to human subjects. %
%
%Postcondition: data is a cell array that stores various data that give
%some indication of model behavior. the exact structure of this cell is as
%of yet unspecified. 
%
%CalenW(2010)
function data = AnalyzeFits(modelOutput)

    paramValues = [];

    for i = 1:length(modelOutput)
        paramValues = [paramValues;modelOutput{i,2}];
        
    end

    data = {paramValues};
    
    
end