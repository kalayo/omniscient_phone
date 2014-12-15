# The following script builds a tidy, smaller data table
#	from a large data set of measurements from cellphone sensors during daily human activities.
#	Please refer to readme.MD and codebook.MD for more detailed information.
#
# Data integrity is tested after every major step.
#	Quality control tests are defined and described in quality_controls.R
# 
# Requirements
# 	dplyr package
# 	quality_controls.R
#
# Inputs
#	a downloaded data set that includes
#		features.txt        : a key of variables corresponding to columns in x_*.txt
#		activity_labels.txt : a key of activities coded in y_*.txt
#
#		test and training sets that each includes
#			y_*.txt			: the activity being performed			
#			x_*.txt			: measurements obtained during the activity
#			subject_*.txt	: the person performing the activity in y_*.txt
#
# Analysis
# 	1. Download data set, read and merge training and test data.
# 	2. Subset columns, in the following order: activity, subject, means and standard deviations.
# 	3. Relabel columns according to features.txt.
#	4. Decode activity according to activity_labels.txt.
#	5. Build a table of the mean of each variable in the subset, grouped by activity and subject.
#	6. Write data table to file.
#	7. Write log file.
#
# Outputs:
#	date-stamped data table in txt
# 	date-stamped high-level logfile in txt

	
	library(dplyr)														# Requirements.
	source('quality_controls.R')


# Download, read and merge data.
	
	data_set = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
	download.file(data_set, dest = 'har_data.zip', method = 'curl')		# Data set.
	unzip('har_data.zip')
	download_date = Sys.Date()
	analysis_date = Sys.time()												
	
	y_test = read.table(file = 'UCI HAR Dataset/test/y_test.txt')		# Test data.
	x_test = read.table(file = 'UCI HAR Dataset/test/x_test.txt')
	subject_test = read.table(file = 'UCI HAR Dataset/test/subject_test.txt')
	x_test = data.frame(x_test, subject_test, y_test)					

	y_train = read.table(file = 'UCI HAR Dataset/train/y_train.txt')	# Training data.
	x_train = read.table(file = 'UCI HAR Dataset/train/x_train.txt')
	subject_train = read.table(file = 'UCI HAR Dataset/train/subject_train.txt')
	x_train = data.frame(x_train, subject_train, y_train)				

	features = read.table(file = 'UCI HAR Dataset/features.txt')		# Additional files.
	activity_labels = read.table(file = 'UCI HAR Dataset/activity_labels.txt')
	
	complete_set = rbind(x_train, x_test)								# Merge training and test data.
	complete_set = as.tbl(complete_set)

	merge_qc()															# QC after merge.
		

# Subset means and standard deviations.

	means = grep("-mean()", features$V2, fixed = T)
	sd = grep("-std()", features$V2, fixed = T)
	set_means_sd = select(complete_set, ncol(complete_set) - 1,
							ncol(complete_set), means, sd)
	
	subset_qc()															# QC after subset.
	

# Relabel and recode variables according to features.txt and activity_labels.txt.
	
	names(set_means_sd) = c('subject', 'activity',						# Relabel columns.
			as.character(features[means, 'V2']),
							as.character(features[sd, 'V2']))
	
	relabel_qc()														# QC after relabel.
		
	set_means_sd = mutate(set_means_sd, activity =						# Decode activity.
							activity_labels[activity, 2])
	
	recode_qc()															# QC after decode.
	
	
# Build final, tidy data set.
	
	grouped_means = summarise_each(group_by(set_means_sd, activity, subject), funs(mean))
	filename = paste('grouped_means_', format(download_date, format = '%d%m%Y'), '.txt', sep = '')
	write.table(grouped_means, file = filename, row.names = F)
	
	grouped_qc()														# QC after summary.
	final_qc()															# Final QC.
	
	qlist = list(merge = merge, subset = subset,						# Assemble QC results.
					relabel = relabel, decode = recode,
					grouped_mean = grouped, final = final)
	print(qlist)


# Write a short, high level log file.
# Appends to log file if it already exists.

	logfile = paste('run_analysis_log_', format(download_date, format = '%d%m%Y'), '.txt', sep = '')
	write(paste('\n\nDownload date: ', download_date), file = logfile, append = T)
	write(paste('Analysis date: ', analysis_date), file = logfile, append = T)
	write(paste('Output       : ', filename), file = logfile, append = T)
	write(paste('Log file     : ', logfile), file = logfile, append = T)
	write('\n\ngrouped_means[1:6, 1:4]\n',file = logfile, append = T)
	write.table(grouped_means[1:6, 1:4],								# Produces a warning, ignore.
					file = logfile, row.names = F, append = T)
	write('\n\nQC results\n', file = logfile, append = T)
	qc = sapply(names(qlist),function(x) paste(x,paste(qlist[[x]],collapse=" ")))
	write(qc, file = logfile, append = T)


# Clean up workspace.

	rm('y_test', 'subject_test', 'x_test', 'filename', 'subset_qc',
			'y_train', 'subject_train', 'x_train', 'grouped', 'final',
			'means', 'sd', 'merge', 'subset', 'relabel', 'final_qc',
			'recode', 'grouped_qc', 'merge_qc', 'recode_qc', 'relabel_qc',
			'data_set', 'analysis_date', 'download_date', 'logfile')
