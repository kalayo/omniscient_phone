#### Data set
* The complete data set is comprised of multiple files.
* The data set has previously split into training and test data sets.
* Training and test data each contain multiple files, of which only the following were used
  * **_x_test.txt_** and **_x_train.txt_**
    * Contains measurements from cellphone sensors during daily human activities.
  * **_y_test.txt_** and **_y_train.txt_**
    * Contains the activity being performed during each experiment.
  * **_subject_test.txt_** and **_subject_train.txt_**
    * Contains the subject performing the activity.
* For this analysis, only the following files were used:
  * **_features.txt_**
    * Contains variable names that correspond to columns in _x_test.txt_ and _x_train.txt_.
  * **_activity_labels.txt_**
    * Contains the activities coded as numbers in _y_test.txt_ and _y_train.txt_.

#### Programmatic analysis
* The data set was downloaded as a zip file and unzipped in a local directory.
* The three tables comprising test data were read and merged.
* Corresponding tables that comprise training data were read and merged.
* Text files containing features and activity labels were read.
* The training and test data were merged into one complete set.
* From the complete data set, a subset was extracted, containing, in this order,
  * subject
  * activity
  * means of variables, using _-mean()_ as search pattern
  * standard deviations of variables, _-std()_ as search pattern.
* The columns of the resulting subset were relabeled, using _features.txt_ as key.
* The activities in the subset were decoded, using _activity_labels.txt_ as key.
* Each column in the subset was averaged by activity and by subject into a new, tidy data set. 
* (At each step, data integrity was checked using functions defined in _quality_controls.R_.  Please see _quality_controls.R_ for details.)
* The tidy data table of averages by activity and subject was written to a text file.
* A high-level log file was written to a text file.
* The workspace was cleaned up.

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
