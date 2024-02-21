pnorm(135, 100, 15)
pnorm(115, 100, 15)
pnorm(100, 100, 15)
pnorm(85, 100, 15)



########### COMBINATION

#choose(n, k) # choose k items from n items

choose(6,3)


pbinom(5,10, 0.25,lower.tai = TRUE) # Pr(X<= 5)

1- pbinom(4,10, 0.25) # Pr(X>=5)
# lower.tail: logical; if TRUE (default), probabilities are P[X = x], otherwise, P[X > x].




###########   FINDING PROBABILITY AND QUANTILE FOR NORMAL DISTRIBUTION

# slide 76

pnorm(1,lower.tail = F)

pnorm(2.3)

pnorm(1.18,lower.tail = F)

pnorm(0,lower.tail = F)

pnorm(1.96,lower.tail = F)

pnorm(-1.96)

qnorm(0.32)
by default, mean is 0 and sd is 1



#SAT example

probabilty from a normal distribution 
mean 1500 and sd 900

pnorm(1800, mean = 1500, sd = sqrt(90000)) 

pnorm(1630, mean = 1500, sd = sqrt(90000), lower.tail = TRUE) # LEFT area, default

pnorm(1630, mean = 1500, sd = sqrt(90000), lower.tail = FALSE) # RIGHT area



#hypertension example

qnorm(0.1, mean = 95, sd = sqrt(144))






########################  SECTION ON R



#### Generating values that follows binomial distribution
#slide 88 - 91

y = rbinom(10, 100, 0.5); y

#finding probability
pbinom(2000, 3889, 0.531, lower.tail = TRUE) # prob(X<=2000) 

pbinom(2000, 3889, 0.531, lower.tail = FALSE) # prob(X>2000)



#finding quantile value
qbinom(0.9, 100, 0.5)

qbinom(0.98, 3889, 0.531)

find the 0.98 percentile

#Generate a set of 6 random observations that follow N(100; 152).
IQ = rnorm(6, mean = 100, sd = 15); IQ

IQ = round(IQ, digits = 2); IQ
digits = decimal places
IQ = round(IQ, digits = 0); IQ

# binomial distribution is approximated by normal distribution:

coin = rbinom(500, 100, 0.5); coin

hist(coin, breaks = 12)

sd(coin) # should be close to n*p*(1-p) = 5 if n = 100 and  p =0.5


# another example:

die = rbinom(500, 120, 1/6); die

hist(die, breaks = 20)

sd(die) # should be close to n*p*(1-p) = sqrt(120*1/6*5/6 )


