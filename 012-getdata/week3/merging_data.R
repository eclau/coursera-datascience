# Merging data
if (!file.exists("./data")) {
  dir.create("./data")
}
fileURL1 <- "https://dl.dropboxusercontent.com/u/7710864/data/reviews-apr29.csv"
fileURL2 <- "https://dl.dropboxusercontent.com/u/7710864/data/solutions-apr29.csv"
download.file(fileURL1, destfile = "./data/reviews.csv", method = "curl")
download.file(fileURL2, destfile = "./data/solutions.csv", method = "curl")
reviews <- read.csv("./data/reviews.csv")
solutions <- read.csv("./data/solutions.csv")
head(reviews, 2)
# id solution_id reviewer_id      start       stop time_left accept
# 1  1           3          27 1304095698 1304095758      1754      1
# 2  2           4          22 1304095188 1304095206      2306      1
head(solutions, 2)
# id problem_id subject_id      start       stop time_left answer
# 1  1        156         29 1304095119 1304095169      2343      B
# 2  2        269         25 1304095119 1304095183      2329      C

# merge() - merges data frames
# Important parameters: x, y, by, by.x, by.y, all
names(reviews)
names(solutions)
mergeData <- merge(reviews, solutions, by.x = "solution_id", by.y = "id", all = TRUE)
head(mergeData)

# solution_id id reviewer_id    start.x     stop.x time_left.x accept problem_id subject_id    start.y     stop.y time_left.y answer
# 1           1  4          26 1304095267 1304095423        2089      1        156         29 1304095119 1304095169        2343      B
# 2           2  6          29 1304095471 1304095513        1999      1        269         25 1304095119 1304095183        2329      C
# 3           3  1          27 1304095698 1304095758        1754      1         34         22 1304095127 1304095146        2366      C
# 4           4  2          22 1304095188 1304095206        2306      1         19         23 1304095127 1304095150        2362      D
# 5           5  3          28 1304095276 1304095320        2192      1        605         26 1304095127 1304095167        2345      A
# 6           6 16          22 1304095303 1304095471        2041      1        384         27 1304095131 1304095270        2242      C

# Default - merge all common column names
intersect(names(solutions), names(reviews))
mergeData2 <- merge(reviews, solutions, all = TRUE)
head(mergeData2)

# id      start       stop time_left solution_id reviewer_id accept problem_id subject_id answer
# 1  1 1304095119 1304095169      2343          NA          NA     NA        156         29      B
# 2  1 1304095698 1304095758      1754           3          27      1         NA         NA   <NA>
# 3  2 1304095119 1304095183      2329          NA          NA     NA        269         25      C
# 4  2 1304095188 1304095206      2306           4          22      1         NA         NA   <NA>
# 5  3 1304095127 1304095146      2366          NA          NA     NA         34         22      C
# 6  3 1304095276 1304095320      2192           5          28      1         NA         NA   <NA>

# using join in the plyr package
# faster, but less full featured - defaults to left join, see help file for more
df1 <- data.frame(id = sample(1:10), x = rnorm(10))
df2 <- data.frame(id = sample(1:10), y = rnorm(10))
arrange(join(df1, df2), id)

# Joining by: id
# id           x           y
# 1   1 -0.73336896  0.12997424
# 2   2  0.02895328 -1.11267237
# 3   3 -0.03975897  1.18187302
# 4   4 -1.08953731 -1.77010124
# 5   5  0.49000949 -0.50570519
# 6   6  0.56435813 -0.47136298
# 7   7  0.42387569  0.48234255
# 8   8  0.66031513  1.04485772
# 9   9  0.08144497 -0.08616314
# 10 10 -0.79456135  1.54588055

df3 <- data.frame(id = sample(1:10), z = rnorm(10))
dfList <- list(df1, df2, df3)
join_all(dfList)

# Joining by: id
# Joining by: id
# id           x           y           z
# 1   7  0.42387569  0.48234255 -0.58646389
# 2   9  0.08144497 -0.08616314 -0.42045124
# 3   6  0.56435813 -0.47136298 -0.31842998
# 4   1 -0.73336896  0.12997424  0.57482410
# 5   4 -1.08953731 -1.77010124  0.04106155
# 6   5  0.49000949 -0.50570519 -1.00669264
# 7   3 -0.03975897  1.18187302 -0.16797501
# 8   2  0.02895328 -1.11267237  1.06925611
# 9  10 -0.79456135  1.54588055 -0.06073147
# 10  8  0.66031513  1.04485772  0.01690924

