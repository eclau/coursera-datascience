# dplyr Introduction
install.packages("dplyr")
library(dplyr)
setwd("~/Documents/Development/Coursera/coursera-datascience/012-getdata/week3")

# Few verbs - arrange, filter, select, mutate, rename
# dplyr is all about working with data frames
# Developed by Hadley Wickham of RStudio
# It's an optimised and distilled version of the plyr package
# It's fast, as many key operations are coded in C++
# can use with other data frame backends (e.g. using dplyr on data.table)

# dplyr verbs:
# 1. select - return a subset of the columns of a data frame
# 2. filter - extract a subset of rows from a data frame based on logical conditions
# 3. arrange - reorder rows of a data frame
# 4. rename - rename variables in a data frame
# 5. mutate - add new variables/columns or transform existing variables
# 6. summarise / summarize - generate summary statistics of different variables in the data frame, possibly within strata

# Params style
# The first argument is a data frame
# The subsequent arguments describe what to do with it (can refer to columns in the df directly without using the $ operator)
# The result is a new data frame

chicago <- readRDS("chicago.RDS")
head(chicago, n=3)
str(chicago)
names(chicago)
# Let's look at the columns starting from city to dptp:
head(select(chicago, city:dptp))
# look at everything except columns between city:dptp
head(select(chicago, -(city:dptp)))
# subset rows using filter
chic.f <- filter(chicago, pm25tmean2 > 30)
head(chic.f)
# more complicated subsetting
chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
head(chic.f)
# arrange can be used to reorder the df
chicago <- arrange(chicago, date)
head(chicago)
tail(chicago)
chicago <- arrange(chicago, desc(date))
head(chicago)
tail(chicago)
# rename can be used to rename a variable
chicago <- rename(chicago, pm25 = pm25tmean2, dewpoint = dptp)
head(chicago)
# mutate transform existing or create new variables
chicago <- mutate(chicago, pm25detred = pm25 - mean(pm25, na.rm = TRUE))
head(select(chicago, pm25, pm25detred))
chicago <- mutate(chicago, tempcat = factor(1 * (tmpd > 80), labels = c("cold", "hot")))
head(chicago)
hotcold <- group_by(chicago, tempcat)
# What is the mean pm 25, max ozone and median no2 on a hot/cold day?
summarise(hotcold, pm25 = mean(pm25), o3 = max(o3tmean2), no2 = median(no2tmean2))
# tempcat    pm25        o3      no2
# (fctr)   (dbl)     (dbl)    (dbl)
# 1    cold      NA 66.587500 24.54924
# 2     hot      NA 62.969656 24.93870
# 3      NA 47.7375  9.416667 37.44444
summarise(hotcold, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
# tempcat     pm25        o3      no2
# (fctr)    (dbl)     (dbl)    (dbl)
# 1    cold 15.97807 66.587500 24.54924
# 2     hot 26.48118 62.969656 24.93870
# 3      NA 47.73750  9.416667 37.44444
chicago <- mutate(chicago, year = as.POSIXlt(date)$year + 1900)
years <- group_by(chicago, year)
head(years)
summarize(years, pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
# year     pm25       o3      no2
# (dbl)    (dbl)    (dbl)    (dbl)
# 1   1987      NaN 62.96966 23.49369
# 2   1988      NaN 61.67708 24.52296
# 3   1989      NaN 59.72727 26.14062
# 4   1990      NaN 52.22917 22.59583
# 5   1991      NaN 63.10417 21.38194
# 6   1992      NaN 50.82870 24.78921
# 7   1993      NaN 44.30093 25.76993
# 8   1994      NaN 52.17844 28.47500
# 9   1995      NaN 66.58750 27.26042
# 10  1996      NaN 58.39583 26.38715
# 11  1997      NaN 56.54167 25.48143
# 12  1998 18.26467 50.66250 24.58649
# 13  1999 18.49646 57.48864 24.66667
# 14  2000 16.93806 55.76103 23.46082
# 15  2001 16.92632 51.81984 25.06522
# 16  2002 15.27335 54.88043 22.73750
# 17  2003 15.23183 56.16608 24.62500
# 18  2004 14.62864 44.48240 23.39130
# 19  2005 16.18556 58.84126 22.62387

# you can use the pipeline operator %>% to pass the result from one dplyr output to another input. Data frame is implied between each pipe
chicago %>% mutate(month = as.POSIXlt(date)$mon + 1) %>% group_by(month) %>% summarize(pm25 = mean(pm25, na.rm = TRUE), o3 = max(o3tmean2), no2 = median(no2tmean2))
# month     pm25       o3      no2
# (dbl)    (dbl)    (dbl)    (dbl)
# 1      1 17.76996 28.22222 25.35417
# 2      2 20.37513 37.37500 26.78034
# 3      3 17.40818 39.05000 26.76984
# 4      4 13.85879 47.94907 25.03125
# 5      5 14.07420 52.75000 24.22222
# 6      6 15.86461 66.58750 25.01140
# 7      7 16.57087 59.54167 22.38442
# 8      8 16.93380 53.96701 22.98333
# 9      9 15.91279 57.48864 24.47917
# 10    10 14.23557 47.09275 24.15217
# 11    11 15.15794 29.45833 23.56537
# 12    12 17.52221 27.70833 24.45773