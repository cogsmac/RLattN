Documentation for input variable: 'experimentStruc'

A variable experimentStruc needs to be passed into RLattN. It must be of type 'struct'

The following fields are required: 

actionMax - The maximum value that the model's action can be

stateMax - Must be set as the number of distinct states the model can progress though, not including final categorization states. 

featureMax - Total number of features used in the category structure

categoryMax - Total number of categories used in the category structure

stimuli - The stimuli to presented to the model, already ordered the way it will be presented. Each
row represents the values on the dimensions. Values are either 1 or 2. Currently, the model only supports 
binary valued stimulus. 

response - The response that the model is be trained to make on that stimulus. Rows should correspond to
rows of the stimuli field.

Documentation for input variable: 'Params' 

This is a matrix of values: 

Column 1: alp
Column 2: temp
Column 3: accessCost
Column 4: novelInformationBonus
Column 5: correctDecisionReward
Column 6: incorrectDecisionReward


Documentation for output variable 'actionsMade'

This was left consistent with early version of this model. Consultation could be made and this could
be updated. 

The output variable actionsMade has the following structure. 

It is a 1x1 Cell Array. 

In cell actionsMade{1,1} is a 200x3 cell. 

Column 1: Holds the fixation order for the trial that corresponds to the row number
Column 2: Holds the categorization decision that was made for the trial that corresponds to the row number.
Column 3: Determines whether this was a correct or incorrect trial. 

