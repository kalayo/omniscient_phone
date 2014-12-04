# Requirements.

	library(dplyr)


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
	
	q = logical()
	testrow = sample(1:nrow(x_train), 1)
	testcolumn = sample(colnames(complete_set), 1)
	
	q = c(q, identical(nrow(complete_set), nrow(x_train) + nrow(x_test)))
	q = c(q, identical(sum(complete_set[1:nrow(x_train), ]), sum(x_train)))
	q = c(q, identical(sum(complete_set[(nrow(x_train) + 1):nrow(complete_set), ]), sum(x_test)))
	q = c(q, !sum(complete_set[testrow, ] != x_train[testrow, ]))
	q = c(q, !sum(complete_set[(nrow(x_train) + 1):nrow(complete_set), testcolumn] != 
							x_test[ , testcolumn]))
	merge = q
	

# Subset.
	means = grep("-mean()", features$V2, fixed = T)
	sd = grep("-std()", features$V2, fixed = T)
	
	set_means_sd = select(complete_set, ncol(complete_set) - 1, ncol(complete_set), means, sd)

	q = logical()
	testrow = sample(1:nrow(x_train), 1)
	testcolumn = sample(colnames(set_means_sd), 1)
	q = c(q, identical(as.numeric(ncol(set_means_sd)), length(means) + length(sd) + 2))
	q = c(q, identical(nrow(set_means_sd), nrow(x_train) + nrow(x_test)))
	q = c(q, identical(sum(set_means_sd[1:nrow(x_train), ]),
			sum(x_train[ , c(means, sd, ncol(x_train) - 1, ncol(x_train))])))
	q = c(q, identical(sum(set_means_sd[(nrow(x_train) + 1):nrow(set_means_sd), ]),
			sum(x_test[ , c(means, sd, ncol(x_test) - 1, ncol(x_test))])))
	q = c(q, !sum(set_means_sd[testrow, ] !=
			x_train[testrow, c(ncol(x_train) - 1, ncol(x_train), means, sd)]))
	q = c(q, !sum(set_means_sd[(nrow(x_train) + 1):nrow(set_means_sd), testcolumn] != 
							x_test[ , testcolumn]))
	subset = q
	

# Relabel.
	names(set_means_sd) = c('subject', 'activity',
			as.character(features[means, 'V2']), as.character(features[sd, 'V2']))
	set_means_sd = mutate(set_means_sd, activity = activity_labels[activity, 2])
	
	q = logical()
	testcolumn = sample(colnames(set_means_sd), 1)
	
	mutated_count = count(set_means_sd, activity, sort = T)
	test_count = count(complete_set, V1.2, sort = T)
	test_count[ , 1] = activity_labels[as.numeric(test_count$V1.2), 2]
	q = c(q, !sum(test_count != mutated_count))
	q = c(q, !sum(set_means_sd$subject[1 : nrow(subject_train)] != subject_train[ , 1]))
	q = c(q, !sum(set_means_sd$subject[(nrow(subject_train) + 1) : nrow(set_means_sd)] != 
					subject_test[ , 1]))
	q = c(q, !sum(set_means_sd[1 : nrow(x_train), testcolumn] !=
					x_train[ , which(features$V2 == testcolumn)]))
	q = c(q, !sum(set_means_sd[(nrow(subject_train) + 1) : nrow(set_means_sd), testcolumn] !=
					x_test[ , which(features$V2 == testcolumn)]))
	relabel = q


# Build final data set.
	grouped_means = summarise_each(group_by(set_means_sd, activity, subject), funs(mean))
	
	testsubject = sample(unique(set_means_sd$subject), 1)
	testactivity = sample(unique(set_means_sd$activity), 1)
	testcolumn = sample(colnames(set_means_sd), 1)
	testmean = mean(set_means_sd[(set_means_sd$activity == testactivity &
							set_means_sd$subject == testsubject), testcolumn][[1]])
	testindex = grouped_means[['subject']] == testsubject & grouped_means[['activity']] == testactivity
	summarymean = grouped_means[[testcolumn]][testindex]
	
	q = identical(testmean, summarymean) 
	qlist = list(merge = merge, subset = subset, relabel = relabel,
					grouped_mean = q)
	print(qlist)
	

# Clean up workspace.

	rm('y_test', 'subject_test', 'x_test',
			'y_train', 'subject_train', 'x_train',
			'means', 'sd', 'q', 'testrow', 'testcolumn',
			'merge', 'subset', 'relabel', 'test_count',
			'mutated_count')
