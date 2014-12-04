
merge = logical()
subset = logical()
relabel = logical()
recode = logical()
grouped = logical()
final = logical()

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

grouped_qc = function() {
	q = logical()
	testsubject = sample(unique(set_means_sd$subject), 1)
	testactivity = sample(unique(set_means_sd$activity), 1)
	testcolumn = sample(colnames(set_means_sd), 1)
	testmean = mean(set_means_sd[(set_means_sd$activity == testactivity &
							set_means_sd$subject == testsubject), testcolumn][[1]])
	testindex = grouped_means[['subject']] == testsubject & grouped_means[['activity']] == testactivity
	summarymean = grouped_means[[testcolumn]][testindex]
	
	q = identical(testmean, summarymean) 
	grouped <<- q

}

final_qc = function() {
	testdata = as.data.frame(grouped_means)
	q = logical()
	q = c(q, identical(dim(testdata), c(180L, 68L)))
	q = c(q, !(abs(sum(testdata[-1]) - -2964.23)/2964.23 > 0.001))
	q = c(q, !(abs(sum(testdata[6,-1]) - -41.15578)/41.15578 > 0.001))
	q = c(q, !(abs(sum(testdata[ ,40]) - -171.4373)/171.4373 > 0.001))
	final <<- q
}