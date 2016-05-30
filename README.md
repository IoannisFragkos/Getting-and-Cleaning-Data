# Getting-and-Cleaning-Data
## Repo with course assigment material

**This repo contains the following files:**

- **run_analysis.R**:   File that downloads the assignment dataset, cleans it and outputs a `tidy_data.csv` file and a `merged.csv` file, as required in part 5.

- **tidy_data.csv**:    File with tidy data, that contains the average of each variable for each activity and each subject, as explained in the assignment.

- **codebook.pdf**:      Codebook file that explains the choices made when cleaning and summarising the data, and their brief description.

- **run_analysis.pdf**:  compiled document with results, created with knitr

Note that the file `merged.csv` is not submitted due to space limitations, but it can be readily reproduced by running the script `run_analysis.R`

## Script description
The script `run_analysis.R` has the following distinct parts:
- Loads the libraries `dplyr, tidyr`
- Sets the working directory
- Initializes folders, downloads the file and unzips the dataset
- Initializes the dataframes
- Part 1: Merges the two dataframes (testing and training)
- Parts 2 and 4: extracts means and standard deviations, and relabels the variable names to those give in file `features.txt`
- Part 3: Relabels the activity names from numbers (1, 2, ...) to actual activity descriptions (LAYING, SITTING, etc).
- Part 5: from the above merged dataset, creates a new tidy dataset that reports the average of each variable for each subject-activity combination.
- Outputs two distinct csv files with the tidy dataset (`tidy_data.csv`) and the merged dataset of steps 1-4 (`merged.csv`) respectively.
 

The file is faily commended and it should be straightforward to follow.
