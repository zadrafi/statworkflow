source(here("R", "01-functions.R"))

library(beepr)

# multiple imputation package that uses multiple imputation by chained equations

library(mice) 

# temporary dataset to be used in the imputation workflow 

temp <- df 

z <- parlmice(data = temp, method = "midastouch", m = 100, maxit = 100,
              cluster.seed = 1031, n.core = 8, n.imp.core = 25, cl.type = "FORK") 

# I'm not really going to comment on the above function because it'll take an extraordinary amount of time. 

# I recommend checking out Stef van Buuren's papers and books for R as he is an expert on MICE and multiple imputation

# Also, check out the works of some other missing data researchers (Tim Morris, Ian White, Donald Rubin, Jonathan Bartlett, Paul Gustafson, etc.)

beep(3) # I will touch on this function below.

saveRDS(z, here("Main Project", "Data", "z.rds"))