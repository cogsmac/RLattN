RLattN contains 3 sub-folders

> analysis
> fittingAndSeeds
> model
w

For information about how the RLattN model works, and what its input and output conditions are, please see the readme.txt file contained in the 'model subfolder.

===== Fitting and Seeds =======

The main file from which the RLattN model is normally called is frandsearchRL.m This file has a toggle that allows you to generate randomized parameter valued subjects (what we call 'random seeds'), or do local fitting. Random seeds are themselves pretty self-explanatory, the function simply generates 5 random values for RLattN, along with the experiment structures for the specified experiment.

The fitting is a little bit more involved. All of the support files for the fitting are contained in the aptly named sub directory 'fittingAndSeedSupport'. RlattN will fit well with fminsearchbnd set to 600 func evals and 100 max iterations. We use mean square error as the distance calculation.

The subfolder 'compilerversion' contains a stripped down version of fransearchRL called frandsearchRLserialCompile located in >> src. This file does not do random seeds, requires an experiment .mat file, and takes as input, an integer which tells it which subject to grab from the experiment .mat file. It does 1 fit at a time. We do this so that it can be compiled as a single unit, and arguments fed into it dynamically from qsub call made in frandscripter.py This file will make 1600 calls to the batch script 'frandsearchRL.pbs' which will in turn pass those calls on to the bash script that runs the compiled code, resulting in 1600 separate jobs on a given computer cluster. For help compiling the code, please see the lab wiki. 


===== Analysis =======

Out analysis scripts are specific to the goals of calculating error bias. Details for the pre and post conditions of each script can be found in the individual files. They are not required files for the running of the script.
