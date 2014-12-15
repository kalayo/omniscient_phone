* The repository contains
  * R scripts to download, merge and subset data from experiments designed to teach cellphones to recognize human activities.  Creepy, I know. :-)
  * Three output files from original and recent runs of analysis.
  * CodeBook.md with details of the data set, the analysis and the output files.

#### Files

* **_run_analysis.R_**
  * Downloads, merges and subsets data.
  * Data are measurements obtained from cellphone sensors during daily activities.
* **_quality_controls.R_**
  * Defines functions called from inside run_analysis.R to evaluate data integrity at each step of analysis.
* **_CodeBook.md_**
  * Details of data, variables and analysis steps.
* **_standard.txt_**
  * Output data from an analysis performed on 12.04.2014.
  * To test reproducibility, compare future runs to this data set.
* **_grouped_means_151202014.txt_**
  * Output data from a run on 12.15.2014.
* **_run_analysis_log_15122014.txt_**
  * Log file from a run on 12.15.2014.
