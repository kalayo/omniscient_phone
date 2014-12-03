# Read data.

subject_test = read.table(file = 'test/subject_test.txt')
y_test = read.table(file = 'test/y_test.txt')
x_test = read.table(file = 'test/x_test.txt')
x_test = data.frame(x_test, subject_test, y_test)

subject_train = read.table(file = 'train/subject_train.txt')
y_train = read.table(file = 'train/y_train.txt')
x_train = read.table(file = 'train/x_train.txt')
x_train = data.frame(x_train, subject_train, y_train)

complete_set = rbind(x_train, x_test)

# Quality checks.
print(identical(nrow(complete_set), nrow(x_train) + nrow(x_test)))
print(identical(sum(complete_set[1:7352, ]), sum(x_train[ , ])))
print(identical(sum(complete_set[7353:10299, ]), sum(x_test[ , ])))

colnames(complete_set)[562] = 'subject'
colnames(complete_set)[563] = 'activity'

# Clean up workspace.
rm('y_test', 'subject_test', 'x_test',
	'y_train', 'subject_train', 'x_train')
