## Reshaping data
## http://www.cookbook-r.com/Manipulating_data/Converting_data_between_wide_and_long_format/

setwd("~/Documents/Development/Coursera/coursera-datascience/012-getdata/week3")

# Goal is to tidy data
# Each variable forms a column
# Each observation forms a row
# Each table/file stores data about one kind of observtion (e.g. people/hospitals)

install.packages("reshape2")
library(reshape2)
head(mtcars)

# Melting data frames
mtcars$carname <- rownames(mtcars)
carMelt <- melt(mtcars, id=c("carname", "gear", "cyl"), measure.vars=c("mpg", "hp"))
head(carMelt, n=3)
tail(carMelt, n=3)
carMelt[carMelt$carname %in% c("Volvo 142E"),]

# Casting data frames
cylData <- dcast(carMelt, cyl ~ variable)
cylData
cylData <- dcast(carMelt, cyl ~ variable, mean)
cylData

# Averaging values
data("InsectSprays")

# Q: I want to calculate some statistics for lots for different groups
# http://www.r-bloggers.com/a-quick-primer-on-split-apply-combine-problems/
head(InsectSprays)

#    count spray
# 1  10    A
# 2  7     A

# A: First, we split the count column by the spray column
count_by_spray <- with(InsectSprays, split(count, spray))
count_by_spray

# $A
# [1] 10  7 20 14 14 12 10 23 17 20 14 13
# 
# $B
# [1] 11 17 21 11 16 14 17 17 19 21  7 13
# 
# $C
# [1] 0 1 7 2 3 1 2 1 3 0 1 4

#    Secondly, we apply statistics to each element of the list (e.g. Mean)
mean_by_spray <- lapply(count_by_spray, mean)
mean_by_spray
#    Finally, (if possible) we recombine the list as a vector
unlist(mean_by_spray)
#    This procedure is such a common thing that there are many functions to speed up the process
#    sapply and vapply do the last two steps together
sapply(count_by_spray, mean)
vapply(count_by_spray, mean, numeric(1))
# We can do even better than that however, tapply, aggregate and by all provide a one-function solution to these S-A-C problems
with(InsectSprays, tapply(count, spray, mean))
with(InsectSprays, by(count, spray, mean))
aggregate(count ~ spray, InsectSprays, mean)
# The plyr package also provides several solution, with a choice of output formula
# ddply take a data frame and returned another data frame (which is useful)
library(plyr)
ddply(InsectSprays, .(spray), summarise, mean.count = mean(count))
# dlply takes a data frame and returns the uncombined list, which is useful if you want to do another processing step before combining
dlply(InsectSprays, .(spray), summarise, mean.count = mean(count))

# Variable to the problem, when you want to output statistic vector to have the same length as the original input vectors, use ave
with(InsectSprays, ave(count, spray))

# Another way to Split
spIns <- split(InsectSprays$count, InsectSprays$spray)
spIns
sprCount = lapply(spIns, sum)
sprCount

# Creating a new variable
spraySums <- ddply(InsectSprays, .(spray), summarise, sum=ave(count, FUN=sum))
spraySums

# Other functions
# acast - for casting as multi-dimensional arrays
# arrange - for faster reordering without using order() commands
# mutate - adding new variables