# Requirements.

	library(dplyr)
	source('quality_controls.R')


# Read and merge data.
	subject_test = read.table(file = 'test/subject_test.txt')
	y_test = read.table(file = 'test/y_test.txt')
	x_test = read.table(file = 'test/x_test.txt')
	x_test = data.frame(x_test, subject_test, y_test)

	subject_train = read.table(file = 'train/subject_train.txt')
	y_train = read.table(file = 'train/y_train.txt')
	x_train = read.table(file = 'train/x_train.txt')
	x_train = data.frame(x_train, subject_train, y_train)

	features = read.table(file = 'features.txt')
	activity_labels = read.table(file = 'activity_labels.txt')
	
	complete_set = rbind(x_train, x_test)
	complete_set = as.tbl(complete_set)


# Quality checks to verify integrity of data after merge.  q should be all true.
	merge_qc()	

# Subset.
	means = grep("-mean()", features$V2, fixed = T)
	sd = grep("-std()", features$V2, fixed = T)
	
	set_means_sd = select(complete_set, ncol(complete_set) - 1, ncol(complete_set), means, sd)
	
	subset_qc()
	

# Relabel variables.
	names(set_means_sd) = c('subject', 'activity',
			as.character(features[means, 'V2']), as.character(features[sd, 'V2']))
	
	relabel_qc()
		
	set_means_sd = mutate(set_means_sd, activity = activity_labels[activity, 2])
	
	recode_qc()
	
	

# Build final data set.
	grouped_means = summarise_each(group_by(set_means_sd, activity, subject), funs(mean))
	filename = paste('grouped_means_', format(Sys.Date(), format = '%d%m%Y'), '.txt', sep = '')
	write.table(grouped_means, file = filename, row.names = F)
	
	grouped_qc()
			

#Final qc.  Compare with analysis run on 04 Dec 2014.
	
	final_qc()
	
	qlist = list(merge = merge, subset = subset, relabel = relabel,
					recode = recode, grouped_mean = grouped, final = final)
	print(qlist)


# Clean up workspace.

	rm('y_test', 'subject_test', 'x_test', 'filename', 'subset_qc',
			'y_train', 'subject_train', 'x_train', 'grouped', 'final',
			'means', 'sd', 'merge', 'subset', 'relabel', 'final_qc',
			'recode', 'grouped_qc', 'merge_qc', 'recode_qc', 'relabel_qc')
