# Given data
sample_mean <- 62.2
sample_std_dev <- 4.71
sample_size <- 36
confidence_level <- 0.95

# Point estimate of the population mean
point_estimate <- sample_mean

# Multiplier for the standard error (using a t-distribution for a small sample size)
t_multiplier <- qt((1 + confidence_level) / 2, df = sample_size - 1)

# Standard error
standard_error <- sample_std_dev / sqrt(sample_size)

# Margin of error
margin_of_error <- t_multiplier * standard_error

# Lower and upper bounds of the confidence interval
lower_bound <- point_estimate - margin_of_error
upper_bound <- point_estimate + margin_of_error

# Display the results
cat("Point estimate:", round(point_estimate, 1), "\n")
cat("Multiplier for standard error:", round(t_multiplier, 2), "\n")
cat("Margin of error:", round(margin_of_error, 2), "\n")
cat("Lower bound of the confidence interval:", round(lower_bound, 2), "\n")
cat("Upper bound of the confidence interval:", round(upper_bound, 2), "\n")


# Given data
sample_size <- 1170
yes_responses <- 344
confidence_level <- 0.95
point_estimate <- yes_responses / sample_size

# Standard error for the population proportion
standard_error <- sqrt((point_estimate * (1 - point_estimate)) / sample_size)

# Multiplier for the standard error (using a normal distribution for large sample size)
z_multiplier <- qnorm((1 + confidence_level) / 2)

# Margin of error
margin_of_error <- z_multiplier * standard_error

# Lower and upper bounds of the confidence interval
lower_bound <- point_estimate - margin_of_error
upper_bound <- point_estimate + margin_of_error

# Likelihood of 0.35 being the population proportion
likelihood_0.35 <- pnorm(0.35, mean = point_estimate, sd = standard_error)

# Display the results
cat("Point estimate of p:", round(point_estimate, 3), "\n")
cat("Margin of error:", round(margin_of_error, 3), "\n")
cat("Lower bound of the confidence interval:", round(lower_bound, 3), "\n")
cat("Upper bound of the confidence interval:", round(upper_bound, 2), "\n")
cat("Likelihood of 0.35 being the population proportion:", likelihood_0.35, "\n")


# Scenario 1
p_guideline <- 0.44
E_guideline <- 0.05
Z_95 <- qnorm((1 + 0.95) / 2)  # Z-score for 95% confidence

# Calculate sample size
n_guideline <- ceiling((Z_95^2 * p_guideline * (1 - p_guideline)) / E_guideline^2)

# Display the result
cat("Required sample size (Guideline):", n_guideline, "\n")


# Scenario 2
p_no_guideline <- 0.5  # Maximum variability
E_no_guideline <- 0.05
Z_95_no_guideline <- qnorm((1 + 0.95) / 2)  # Z-score for 95% confidence

# Calculate sample size
n_no_guideline <- ceiling((Z_95_no_guideline^2 * p_no_guideline * (1 - p_no_guideline)) / E_no_guideline^2)

# Display the result
cat("Required sample size (No Guideline):", n_no_guideline, "\n")


# Given values
E <- 25
confidence_level <- 0.95
Z <- qnorm((1 + confidence_level) / 2)  # Z-score for 95% confidence
population_std_dev <- 200

# Calculate sample size
n <- ceiling((Z^2 * population_std_dev^2) / E^2)

# Display the result
cat("Required sample size:", n, "\n")

# Given values
num_yes <- 344
total_subjects <- 1170
confidence_level <- 0.95

# 1. Point estimate of p
point_estimate <- num_yes / total_subjects

# 2. Margin of error (E)
Z <- qnorm((1 + confidence_level) / 2)
margin_of_error <- Z * sqrt((point_estimate * (1 - point_estimate)) / total_subjects)

# 3. Lower bound
lower_bound <- point_estimate - margin_of_error

# 4. Upper bound
upper_bound <- point_estimate + margin_of_error

# Display results
cat("1. Point estimate of p:", round(point_estimate, 3), "\n")
cat("2. Margin of error for a 95% confidence interval for p:", round(margin_of_error, 3), "\n")
cat("3. Lower bound of the 95% confidence interval for p:", round(lower_bound, 3), "\n")
cat("4. Upper bound of the 95% confidence interval for p:", round(upper_bound, 2), "\n")

# Check if 0.35 is likely the population proportion
population_proportion_check <- ifelse(0.35 >= lower_bound & 0.35 <= upper_bound, 1, 2)
cat("Is 0.35 likely the population proportion? [1=Yes, 2=No]:", population_proportion_check, "\n")
