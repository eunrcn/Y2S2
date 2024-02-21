setwd("C:\\Users\\Chian Xin Tong\\Desktop\\XINTONG\\Y2S2\\ST1131")

df = read.csv("Animals.csv")
df
# Q1. Response variables: longevity

# Q2.
summary(df$gestation)
# mean of gestation (164.3) > median, the distribution is right-skewed.
summary(df$longevity)

# Q3. correlation btwn `gestation` and `longevity`
cor(df$gestation, df$longevity)

#Q4. 
plot(df$gestation, df$longevity, xlab="gestation", ylab="longevity")
abline(lm(longevity ~ gestation, df))
# It shows sa positive relationship and possibly linear btwn the gestation period and longevity. 
# It looks like the spread/variability of longevity is larger when the gestation period increases. There is a possible outlier at the top right corner.

#Q5.
boxplot(df$gestation)
# Yes, there is an outlier for `gestation` that is greater than the remaining values.
boxplot(df$longevity)
# Yes, there are 4 outliers for `longevity` that are greater than the remaining values.

cor(df$gestation[-8], df$longevity[-8])
