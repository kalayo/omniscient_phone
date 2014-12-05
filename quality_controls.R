# The following script defines functions that perform quality control tests
#		after every step of run_analysis.R.
# Each function contains a battery of tests to verify data integrity.
# Ideally, all tests should return TRUE, although a FALSE result
#		will not prevent run_analysis.R from completing.
# If future results are different from a past result (standard.txt),
#		the script may identify the step at which results started to diverge.

	merge = logical()										# Lists to contain QC results.
	subset = logical()
	relabel = logical()
	recode = logical()
	grouped = logical()
	final = logical()


# QC after merging training and test data.
# 1.  Test of consistency of number of observations.
# 2.  High-level test of training and test data after merging.
# 3.  Element by element comparison of a random row.
# 4.  Element by element comparision of a random column.

	merge_qc = function() {
		q = logical()
		testrow = sample(1:nrow(x_train), 1)
		testcolumn = sample(colnames(complete_set), 1)
		q = c(q, identical(nrow(complete_set), nrow(x_train) + nrow(x_test)))
		q = c(q, identical(sum(complete_set[1:nrow(x_train), ]), sum(x_train)))
		q = c(q, identical(sum(complete_set[(nrow(x_train) + 1):nrow(complete_set), ]), sum(x_test)))
		q = c(q, !sum(complete_set[testrow, ] != x_train[testrow, ]))
		q = c(q, !sum(complete_set[(nrow(x_train) + 1):nrow(complete_set), testcolumn] != 
										x_test[ , testcolumn]))
		merge <<- q
	}


# QC after subsetting means and standard deviations.
# 1. Test of consistency of number of variables.
# 2. Test of consistency of number of observations.
# 3. High-level test of training and test data after subsetting.
# 4. Element by element comparison of a random row.
# 5. Element by element comparision of a random column.
	
	subset_qc = function() {
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
		subset <<- q
	}
	

# QC after relabeling columns according to features.
# Element by element comparison of activity and subject columns.

	relabel_qc = function() {
		q = logical()
		q = c(q, !sum(set_means_sd$subject[1 : nrow(subject_train)] != subject_train[ , 1]))
		q = c(q, !sum(set_means_sd$subject[(nrow(subject_train) + 1) : nrow(set_means_sd)] != 
						subject_test[ , 1]))
		q = c(q, !sum(set_means_sd$activity[1 : nrow(subject_train)] != y_train[ , 1]))
		q = c(q, !sum(set_means_sd$activity[(nrow(subject_train) + 1) : nrow(set_means_sd)] != 
						y_test[ , 1]))
		relabel <<- q
	}


# QC after recoding activity according to activity_labels.
# 1. Test of consistency of number of observations per activity.
# 2. Element by element comparison of a random column. 

	recode_qc = function() {
		q = logical()
		mutated_count = count(set_means_sd, activity, sort = T)
		testcolumn = sample(colnames(set_means_sd)[-c(1,2)], 1)
		test_count = count(complete_set, V1.2, sort = T)
		test_count[ , 1] = activity_labels[as.numeric(test_count$V1.2), 2]
		q = c(q, !sum(test_count != mutated_count))
		q = c(q, !sum(set_means_sd[1 : nrow(x_train), testcolumn] !=
						x_train[ , which(features$V2 == testcolumn)]))
		q = c(q, !sum(set_means_sd[(nrow(subject_train) + 1) : nrow(set_means_sd), testcolumn] !=
						x_test[ , which(features$V2 == testcolumn)]))
		recode <<- q
	}
	

# QC after summarizing data by activity and subject.
# Test of a random mean from summarise_each against the same mean obtained "manually."

	grouped_qc = function() {
		q = logical()
		testsubject = sample(unique(set_means_sd$subject), 1)
		testactivity = sample(unique(set_means_sd$activity), 1)
		testcolumn = sample(colnames(set_means_sd), 1)
		testmean = mean(set_means_sd[(set_means_sd$activity == testactivity &
							set_means_sd$subject == testsubject), testcolumn][[1]])
		testindex = grouped_means[['subject']] == testsubject &
						grouped_means[['activity']] == testactivity
		summarymean = grouped_means[[testcolumn]][testindex]
		q = identical(testmean, summarymean) 
		grouped <<- q
	}


# Final QC.
# Test of current results against results from 04 Dec 2014.

	final_qc = function() {
		q = logical()
		testdata = read.table(file = 'standard.txt', header = T)
		currentdata = read.table(file = filename, header = T)
		q = identical(currentdata, testdata)
		final <<- q
	}