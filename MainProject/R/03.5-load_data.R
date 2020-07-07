source(here("R", "01-functions.R"))


load_data_03.5 <- file(here("Errors", "03.5-load_data.txt"), open = "wt")

sink(load_data_03.5, type = "message")

z <- readRDS("~/MainProject/Data/z.rds")

sink(type = "message")
close(load_data_03.5)

readLines(here("Errors", "03.5-load_data.txt"))
