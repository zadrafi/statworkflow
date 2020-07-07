# set up warning catching script

library(here)

set_here()

source(here("R", "01-functions.R")) 

# Above is calling the .R script that has all the package/functions

cleaning_02 <- file(here("Errors", "02-cleaning.txt"), open = "wt") 

# Above script `file` creates a .txt file within the errors folder

sink(cleaning_02, type = "message") 

# Above function starts the process of compiling messages into the .txt file to catch messages

# This is where my data inspection and cleaning might start

set.seed(1031) # My birthday

# Time to simulate fake data

df <- data.frame((x <- rnorm(500)), 
                 (y <- rnorm(500)))  

str(df) # inspect data frame

summary(df)

sum(is.na(df)) # Look at missing values etc.

colSums(is.na(df))

# I think you get the point

view(dfSummary(df)) 

# end of cleaning/inspection

# Below script closes the message catching script and saves the file

sink(type = "message") 

close(cleaning_02)

# Below opens the .txt file for inspection

readLines(here("Errors", "02-cleaning.txt")) 