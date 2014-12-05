# The following script builds a tidy dat
	
	library(dplyr)														# Requirements.
	source('quality_controls.R')


# Download, read and merge data.
	
	#data_set = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
	#download.file(data_set, dest = 'har_data.zip', method = 'curl')	# Data set.
	#unzip('har_data.zip')												
	
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
		

# Subset means and standard deviations of variables.

	means = grep("-mean()", features$V2, fixed = T)
	sd = grep("-std()", features$V2, fixed = T)
	set_means_sd = select(complete_set, ncol(complete_set) - 1,
							ncol(complete_set), means, sd)
	
	subset_qc()															# QC after subset.
	

# Relabel and recode variables according to features and activity_labels.
	
	names(set_means_sd) = c('subject', 'activity',						# Relabel columns.
			as.character(features[means, 'V2']),
							as.character(features[sd, 'V2']))
	
	relabel_qc()														# QC after relabel.
		
	set_means_sd = mutate(set_means_sd, activity =						# Recode activities.
							activity_labels[activity, 2])
	
	recode_qc()															# QC after recode.
	
	
# Build final, tidy data set.
	
	grouped_means = summarise_each(group_by(set_means_sd, activity, subject), funs(mean))
	filename = paste('grouped_means_', format(Sys.Date(), format = '%d%m%Y'), '.txt', sep = '')
	write.table(grouped_means, file = filename, row.names = F)
	
	grouped_qc()														# QC after summary.
	final_qc()															# Final QC.
	
	qlist = list(merge = merge, subset = subset,						# Assemble QC tests.
					relabel = relabel, recode = recode,
					grouped_mean = grouped, final = final)
	print(qlist)


# Clean up workspace.

	rm('y_test', 'subject_test', 'x_test', 'filename', 'subset_qc',
			'y_train', 'subject_train', 'x_train', 'grouped', 'final',
			'means', 'sd', 'merge', 'subset', 'relabel', 'final_qc',
			'recode', 'grouped_qc', 'merge_qc', 'recode_qc', 'relabel_qc',
			'data_set')
