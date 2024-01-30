##########  TOPIC 1 ##########

#################### Creating a Vector in R ####################

#creating a vector of numbers:
number<-c(2,4,6,8,10); number
#operations can be done on a vector:
number * 10 # gives vector 20 40 60 80 10
number - 2 # gives vector 0 2 4 6 8

# creating a vector of strings/characters:
string<-c("weight", "height", "gender"); string
# string * 2 is not allowed because the vector is not numeric

#creating a Boolean vector (T/F):
logic<- c(T, T, F, F, T); logic
#numeric operations ckan be done on a boolean vector:
logic * 5 # gives vector 5 5 0 0 5

# using numeric(x), where x is the size of the vector
vector1 <- numeric(3) # gives vector 0 0 0

# using rep(x, y), where there will be y of x
vector2 <- rep(4, 2) # gives vector 4 4
vector3 <- rep(vector2, 3) # gives vector 4 4 4 4 4 4 

# using seq(from, to, by)
vectorA <- seq(2, 10, 2) # gives vector 2 4 6 8 10
vectorB <- seq(2, 10, length=3) # gives vector 2 5 8
vectorC <- 1:5 # gives vector 1 2 3 4 5
vectorD <- seq(8) # gives vector 1 2 3 4 5 6 7 8 
vectorE <- 1:5 * 2 # gives vector 2 4 6 8 10




data<-read.csv("C:/Data/crab.txt", sep = "", header = TRUE)
data
names(data)
colMeans(data)

which(data$color == 3)


#################### Creating a Matrix in R ####################
# matrix(vector, nrow, ncol)

m = matrix(seq(2,20,2), 10, 3)
# or
m = matrix(0,10, 3)
for(i in 1:3){m[,i] = seq(2,20,2)}; m

colMeans(m)

> v = c(2, 6, 10, 8)
> matrix (v, 2, 2 )
     [,1] [,2]
[1,]    2   10
[2,]    6    8
> matrix (v, 2, 2 , byrow = TRUE)
     [,1] [,2]
[1,]    2    6
[2,]   10    8
> M = matrix (v, 2, 2 , byrow = TRUE)
> M
     [,1] [,2]
[1,]    2    6
[2,]   10    8

#################### Multiply a Matrix in R ####################
n = c(1:10)
> n
 [1]  1  2  3  4  5  6  7  8  9 10
> N = matrix(n, 2, 5, byrow = TRUE)
> N
     [,1] [,2] [,3] [,4] [,5]
[1,]    1    2    3    4    5
[2,]    6    7    8    9   10
> M%*%N
     [,1] [,2] [,3] [,4] [,5]
[1,]   38   46   54   62   70
[2,]   58   76   94  112  130


#################### Inverse a Matrix in R ####################
M * M-1 = I

 m = solve(M)
> M%*%m
              [,1]         [,2]
[1,]  1.000000e+00 5.551115e-17
[2,] -2.220446e-16 1.000000e+00

5.551115e-17 is close to 0

#################### Bind a Vector in R ####################
> a = 1:4
> b = 5:8
> rbind(a, b)
  [,1] [,2] [,3] [,4]
a    1    2    3    4
b    5    6    7    8
> cbind(a, b)
     a b
[1,] 1 5
[2,] 2 6
[3,] 3 7
[4,] 4 8
> 
> z = 1:8
> rbind(a,z)
  [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
a    1    2    3    4    1    2    3    4
z    1    2    3    4    5    6    7    8

repeat a twice

> z = 1:7
> rbind(a,z)
  [,1] [,2] [,3] [,4] [,5] [,6] [,7]
a    1    2    3    4    1    2    3
z    1    2    3    4    5    6    7
Warning message:
In rbind(a, z) :
  number of columns of result is not a multiple of vector length (arg 1)

#################### Set working directory ####################
setwd("/Users/eunice/Desktop/ST1131")

?read.csv for help

read.csv("crab.txt", header = TRUE, sep = "")
    color spine width satell weight
1       3     3  28.3      8  3.050
2       4     3  22.5      0  1.550
3       2     1  26.0      9  2.300
4       4     3  24.8      0  2.100
5       4     3  26.0      4  2.600
6       3     3  23.8      0  2.100
7       2     1  26.5      0  2.350
8       4     2  24.7      0  1.900
9       3     1  23.7      0  1.950
10      4     3  25.6      0  2.150
11      4     3  24.3      0  2.150
12      3     3  25.8      0  2.650
13      3     3  28.2     11  3.050
14      5     2  21.0      0  1.850
15      3     1  26.0     14  2.300
16      2     1  27.1      8  2.950
17      3     3  25.2      1  2.000
18      3     3  29.0      1  3.000
19      5     3  24.7      0  2.200
20      3     3  27.4      5  2.700

data1 = read.table("crab.txt", header = TRUE, sep = "")
names(data1)
[1] "color"  "spine"  "width"  "satell" "weight"
> names(data1)[1] = "COLOR"
> names(data1)
[1] "COLOR"  "spine"  "width"  "satell" "weight"

#################### data1$weight ####################
data1$weight
  [1] 3.050 1.550 2.300 2.100 2.600 2.100 2.350 1.900 1.950 2.150 2.150 2.650 3.050 1.850 2.300
 [16] 2.950 2.000 3.000 2.200 2.700 1.950 2.300 1.600 2.600 2.000 1.300 3.150 2.700 2.600 2.100
 [31] 3.200 2.600 2.000 2.000 2.700 1.850 2.650 3.150 1.900 2.800 3.100 2.800 2.500 3.300 3.250
 [46] 2.800 2.600 2.100 3.000 3.600 2.100 2.900 2.700 1.600 2.000 3.000 2.700 2.300 2.750 

#################### attach(data1) ####################
> attach(data1)
> weight
  [1] 3.050 1.550 2.300 2.100 2.600 2.100 2.350 1.900 1.950 2.150 2.150 2.650 3.050 1.850 2.300
 [16] 2.950 2.000 3.000 2.200 2.700 1.950 2.300 1.600 2.600 2.000 1.300 3.150 2.700 2.600 2.100
 [31] 3.200 2.600 2.000 2.000 2.700 1.850 2.650 3.150 1.900 2.800 3.100 2.800 2.500 3.300 3.250
 [46] 2.800 2.600 2.100 3.000 3.600 2.100 2.900 2.700 1.600 2.000 3.000 2.700 2.300 2.750 

#################### displaying certain rows ####################
data1{rows. col]
data1[1:10, ]
COLOR spine width satell weight
1      3     3  28.3      8   3.05
2      4     3  22.5      0   1.55
3      2     1  26.0      9   2.30
4      4     3  24.8      0   2.10
5      4     3  26.0      4   2.60
6      3     3  23.8      0   2.10
7      2     1  26.5      0   2.35
8      4     2  24.7      0   1.90
9      3     1  23.7      0   1.95
10     4     3  25.6      0   2.15

#################### displaying certain columns ####################
data1[ ,3:4]
    width satell
1    28.3      8
2    22.5      0
3    26.0      9
4    24.8      0
5    26.0      4
6    23.8      0
7    26.5      0
8    24.7      0

#################### filtering based on a condition ####################
data1[COLOR == 3,]

will only show rows where color == 3
