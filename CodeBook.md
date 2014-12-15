#### Data set
#### Programmatic analysis
* The data set is downloaded as a zip file and unzipped in a local directory.
* The three tables comprising test data are read and merged.
* Corresponding tables that comprise training data are read and merged.
* Text files containing features and activity labels are read.
* The training and test data are merged into one complete set.
* From the complete data set, a subset is extracted, containing, in this order,
  * subject
  * activity
  * means of variables, using _-mean()_ as search pattern
  * standard deviations of variables, using _-std()_ as search pattern
* The columns of the resulting data set are relabeled, using _features.txt_ as key.
* The activities in the _activity_ column are decoded, using _activity_labels.txt_ as key.
* Each column is then averaged by activity and by subject. 
* _(At each step of analysis, data integrity is checked using functions defined in _quality_controls.R_.  Please see comments in _quality_controls.R_ for details.)_
* The tidy data table of averages by activity and subject is written to a text file.
* A high-level log file is written to a text file.
* The workspace is cleaned up.#### Output

#### Output
* **_grouped_means_**
  * A text file that contains averages, by activity and by subject, of
    * Means of variables
    * Standard deviations of variables
  * Variables are defined in the _features.txt_ of the original data set
* **_run_analysis_log_**
  * A high level log that contains
    * Download and analysis dates
    * File names of output and log files
    * A small snippet of the output data table
    * Quality control results