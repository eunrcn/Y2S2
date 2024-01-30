getwd()
[1] "/Users/eunice"

setwd("/Users/eunice/Desktop/ST1131")


read.csv("final_marks", header = TRUE, sep = "")

discrete and continuous

table1=read.table("final_marks", header = TRUE, sep = "")

names(table1)[2] = "mark"

table2 = table1[ ,2:2]

cleaned_data <- gsub("[\",]", "", table2)
numeric_vector <- as.numeric(scan(text = cleaned_data, what = numeric(), sep = ","))
numeric_vector

# Mean
mean_x <- mean(numeric_vector)

# Median
median_x <- median(numeric_vector)

# Interquartile Range (IQR)
iqr_x <- IQR(numeric_vector)

# Variance
variance_x <- var(numeric_vector)

# Range
range_x <- range(numeric_vector)


mean_x 
median_x 
iqr_x 
variance_x
range_x

hist(numeric_vector, main = "Histogram of Final Marks", xlab = "Final Marks", ylab = "Frequency", col = "skyblue", border = "black")




ANSWER:

attach



Tutorial 1 Question 1
# Original matrix with character values
matrix <- matrix(c("1", "96", "2", "119", "3", "119", "4", "108", "5", "126", "6", "128", "7", "110", "8", "105", "9", "94"), nrow = 2, ncol = 9)

# Convert the matrix to numeric values while preserving rows and columns
numeric_matrix <- matrix(apply(matrix, 2, as.numeric), nrow = nrow(matrix), ncol = ncol(matrix))

# Print the numeric matrix
print(numeric_matrix)


(a)
# Original matrix with character values
matrix <- matrix(c("1", "96", "2", "119", "3", "119", "4", "108", "5", "126", "6", "128", "7", "110", "8", "105", "9", "94"), nrow = 2, ncol = 9)

# Extract the second row and convert it to numeric
row_to_calculate <- as.numeric(matrix[2, ])


# Calculate the mean, variance, and standard deviation for the second row
median_value <- median(row_to_calculate)
mean_value <- mean(row_to_calculate)
variance_value <- var(row_to_calculate)
std_deviation_value <- sd(row_to_calculate)

# Print the results
print(median_value)
print(mean_value)
print(variance_value)
print(std_deviation_value)

(c)

# Subtract 10 from each value
row_adjusted <- row_to_calculate - 10

# Calculate the new mean and variance
new_mean <- mean(row_adjusted)
new_variance <- var(row_adjusted)

# Print the results
print(new_mean)
print(new_variance)

(d)

# Create a histogram with probability
hist(row_adjusted, prob = TRUE, main = "Histogram of Adjusted Data", xlab = "Adjusted Values")


