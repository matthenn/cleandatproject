run_analysis.R is the script that takes the raw data files provided in the assignment and 'cleans' them to eventually produce the tidydataset file that was submitted earlier in the assignment. That file is also here in the repository. 

The data itself was obtained from (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), 

and a description of it can be gotten (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

The files named codebook_x in this repository are all available descriptions of the variables in the dataset. The script itself is annotated with comments that describe what is happening at various parts of the analysis. 

To my knowledge the script should run on its own, as there is code in there that specifies everything from downloading the data to creating the final table. That being said, the functions may work slightly different between systems, particularly with regards to how the data is downloaded and retrieved from temporary directories. I used R Studio Version 0.98.1103 for the analysis on a Mac OS, so if one is using a different system, such things such as paths or certain function arguments (ie, in download.file()) may have to be changed for the code to work. 


