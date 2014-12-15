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
  * standard deviations of variables, _-std()_ as search pattern.
* The columns of the resulting subset are relabeled, using _features.txt_ as key.
* The activities in the subset are decoded, using _activity_labels.txt_ as key.
* Each column is averaged by activity and by subject into a new, tidy data set. 
* (At each step, data integrity is checked using functions defined in _quality_controls.R_.  Please see comments in _quality_controls.R_ for details.)
* The tidy data table of averages by activity and subject is written to a text file.
* A high-level log file is written to a text file.
* The workspace is cleaned up.

#### Output
* **_grouped_means_**
  * A text file that contains the following columns
    * activity
    * subject
    * 33 columns, each column containing an average by activity and by subject of
      * means of variables
      * standard deviations of variables.
  * There are 180 rows, corresponding to 6 activities x 30 human subjects.
* **_run_analysis_log_**
  * A high level log that contains
    * download and analysis dates
    * file names of output and log files
    * a small snippet of the output data table
    * quality control results.
