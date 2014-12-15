#### Data set
#### Variables
* means of variables, identified by searching _features.txt_ for _-mean()_
* standard deviations of variables, identified by searching _features.txt_ for _-std()_
#### Programmatic analysis
* The data set is downloaded as a zip file and unzipped in a local directory.
* The three tables comprising test data are read and merged.
* Corresponding tables that comprise training data are read and merged.
* Text files containing features and activity labels are read.
* The training and test data are merged into one complete set.
* From the complete data set, a subset is extracted, containing, in this order,
  * subject
  * activity
  * means of variables
  * standard deviations of variables
* The columns of the resulting data set are relabeled, using _features.txt_ as key.
* The activities in the _activity_ column are decoded, using _activity_labels.txt_ as key.
* Each column is averaged by activity and by subject into a new, tidy data set. 
* (At each step, data integrity is checked using functions defined in _quality_controls.R_.  Please see comments in _quality_controls.R_ for details.)
* The tidy data table of averages by activity and subject is written to a text file.
* A high-level log file is written to a text file.
* The workspace is cleaned up.

#### Output
* **_grouped_means_**
  * A text file that contains averages, by activity and by subject, of
    * Means of variables
    * Standard deviations of variables
* **_run_analysis_log_**
  * A high level log that contains
    * Download and analysis dates
    * File names of output and log files
    * A small snippet of the output data table
    * Quality control results
