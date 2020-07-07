setwd("~/MainProject")

require(here)
set_here()
here()

source(here("R", "01-functions.R"))

source(here("R", "02-cleaning.R"))

source(here("R", "03-imputing.R"))

source(here("R", "03.5-load_data.R"))

source(here("R", "04-analysis.R"))

source(here("R", "04.25-analysis.R"))

source(here("R", "04.5-analysis.R"))

source(here("R", "05-validation.R"))

source(here("R", "06-tables.R"))

source(here("R", "07-export.R"))