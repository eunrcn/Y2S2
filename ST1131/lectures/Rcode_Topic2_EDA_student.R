
#TOPIC 2 - PART 3

rm(list= ls()) #to remove the history previously saved in R

lung = read.csv("C:\\Data\\lung_cancer.csv",  header = TRUE)
lung
#Smoke: 1 = yes; 0 = No
#Gender: 1 = male; 0 = female
#Cancer:  1 = yes; 0 = no.

attach(lung) #


########### FREQUENCY TABLES

table(Gender) # with 0, 1

prop.table(table(Gender))

prop.table(table(Gender))*100




############ LABEL a categorical variable
# create a new variable 
gender <- ifelse(lung$Gender=="0","Female","Male") 
# for every observation in Gender, if 0 then label as Female, else label as Male

table(gender) # variable gander with labels

prop.table(table(gender))

prop.table(table(gender))*100





############ LABEL a categorical variable
# directly change labels of the original variable in the data frame

lung$Gender = factor(lung$Gender) 

attach(lung)### need this step

levels(Gender)

levels(Gender) = c("Female","Male")

table(Gender) 

prop.table(table(Gender))

prop.table(table(Gender))*100



########################### BAR PLOT

barplot(table(gender))

barplot(table(gender), ylab = "Frequency", xlab = "Gender", 
    col = c(2,5),main = "Bar plot of Gender")



# ANOTHER WAY TO CREATE A BARPLOT (MORE ADVANCED)
count<-c(17066,14464,788,126,37)
Alcohol = c('0', '1', '1-2','3-5', '6 or more')
df = data.frame(Alcohol, count)
library(ggplot2)
attach(df)
p<-ggplot(data=df, aes(x=Alcohol, y=count)) +
  geom_bar(stat="identity")
p
# ADDING LABELS/
ggplot(data=df, aes(x=Alcohol, y=count)) +
  geom_bar(stat="identity", fill="steelblue")+
  geom_text(aes(label=count), vjust=-0.3, size=3.5)+
  theme_minimal()
#label = count: labels above the bars are the values from column "count"
# vjust to let the count numbers appear above the bars
#size to specify the text size of the numbers

########################### PIE CHART

pie(table(gender), col = c(2,5), main = "Pie chart of Gender")

#############
####################### QUANTITATIVE VARIABLES

BMI = c(29.5,28.6,24.7, 28.8, 23.7, 23.3,28.8, 26.7, 23.6, 27.1, 24.5,20.7,28,24.7, 16.3,26,14,
25.8,17.5,30.7,17.5,30.6, 29.7, 24.5,35,21.9,20.9,24.3,27.3, 26.5, 22,16.3, 30.1, 27.2)

hist(BMI, col = 3)

hist(BMI, col = 4, prob = TRUE, ylab = "Probability")





############   MIDTERM MARKS DATA

rm(list= ls())

data<- read.csv("C:/Data/midterm_marks")
data
mark<- data[,2]


########## SUMMARIES

summary(mark)

summaries = c(min(mark),max(mark),mean(mark), median(mark), 
 quantile(mark, 0.3), IQR(mark), range(mark), var(mark), sd(mark))
summaries

########## HISTOGRAM

hist(mark)

hist(mark, prob = TRUE, col = 2, xlab = "Midterm Marks", ylab = "Density", main = "Histogram of the Midterm Marks")

######### BOX PLOT

boxplot.stats(mark)


boxplot(mark)

boxplot(mark, ylab = "Midterm marks", main = "Boxplot of midterm marks", col = 5)
abline(h = median(mark), col = "red")

########## OUTLIERS

# outliers:

mark = c(mark, 45)# adding a point with value of 45 to the variable mark.

boxplot(mark) #the outlier (45) appears above median. 

mark = c(mark, -10) # add another point with value of -10 to the variable mark.

boxplot(mark) #the outlier (45) appears above median, and the outlier (-10) appear below median

which(mark<0 | mark >29)

mark[which(mark<0 | mark >29)] 

mark<- data[,2] # return to the original mark









#TOPIC 2 -PART 5


### Breast Cancer dataset

rm(list= ls())

bc = read.csv("C:/Data/breast_cancer.csv")

# bbd: cancer status, 0 = no; 1 = yes
# pmh: post-menopausal hormone usage: 2 = no; 3 = yes
# alcohol: amount of alcohol consumed 
# hgt: height of participant
# agemenop: age of participant at menopause
# bmi: body mass index of participant

attach(bc)


############### TWO CATEGORICAL VARIABLES

table(bbd, pmh)

#create new variables for bbd and pmh:

cancer <- ifelse(bbd=="0","Absent","Present") 

pmh.use <- ifelse(pmh == "2", "No", "Yes")

# replace the original values of bbd by new labels:
# bbd <- ifelse(bbd=="0","Absent","Present")

tab = table(cancer,pmh.use) #pmh.use in column
tab
proptab = prop.table(tab)*100 # joint probabilities

tab = table(pmh.use,cancer) # cancer in column

proptab = prop.table(tab)*100 # joint probabilities

proptab = prop.table(tab, "pmh.use")*100 # create conditional percentage (condition on pmh.use)
#or
proptab = prop.table(tab, "cancer")*100 # create conditional percentage (condition on cancer)

proptab


############## CLUSTERED BAR PLOT (has 'beside = TRUE')
# it plots the clusters = columns
# we need the conditional probability on pmh.use
tab = table(cancer,pmh.use) #pmh.use in column
tab
proptab = prop.table(tab, "pmh.use")*100 

barplot(proptab, beside = TRUE) # 2 clusters are formed by the column's categories, this is by default.

barplot(proptab, beside = TRUE, xlab = "PMH Usage", main="",col=c("darkblue","red"),legend = rownames(proptab), ylim = c(0, 70) )



############ STACKED BAR PLOT

tab = table(cancer, pmh.use) #pmh in column
 
proptab = prop.table(tab, "pmh.use")*100 ; proptab

barplot(proptab, xlab = "PMH Usage", main="",col=c("darkblue","red"),
  legend = rownames(proptab))

# each bar is 100% for each group of PMH.

#######  If cancer is in column then:

tab = table(pmh.use, cancer)

proptab = prop.table(tab, "pmh.use")*100

barplot(proptab,  xlab = "Cancer", main="",col=c(2,5),legend = rownames(proptab) )
#not recommended




######################################  ONE CATEGORICAL AND ONE QUANTITATIVE VARIABLE

########### BOX PLOT and SOME DETAILS ABOUT BOX PLOT

boxplot(agemenop~cancer, col = c(5,5), ylab = "Age at Menopause", xlab = "Cancer Status")

boxplot(agemenop~cancer)$out # values of all the 57 outliers for both 2 boxplots above

grp = boxplot(agemenop~cancer)$group ; grp # outliers in each group



which(grp ==1) # index of outlier in grp == 1 (Absent)

boxplot(agemenop~cancer)$out[which(grp ==1)]# values of outliers in grp ==1, 41 values

which(grp ==2) # index of outlier in grp == 2 (Present)

boxplot(agemenop~cancer)$out[which(grp ==2)]# values of outliers in grp ==2, 16 values


boxplot(agemenop~cancer)$names




###############   HDB RESALE_FLAT DATA


rm(list=ls())

hdb = read.csv("C:/Data/hdb_2017_now.csv")

#flat_type: 1 room, 2 room, 3 room, 4 room, 5 room, Excecutive and Multi-Generation.

attach(hdb)

boxplot(resale_price~flat_type, col = c(2,3,4,5,6,7,8))

hist(resale_price[which(flat_type == "3 ROOM")], col = 2, main = " ", xlab = "Price of 3 ROOM flat")


######### SCATTER PLOT

plot(floor_area_sqm, resale_price, col = 2)

cor(floor_area_sqm, resale_price)