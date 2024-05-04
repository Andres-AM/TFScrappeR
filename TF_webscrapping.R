
## Importing the libraries and functions
source("../libraries.R")
source("fun.R")

## Function to use 
results <- get_TF_decision(
  date_start = "2024-03-01", 
  date_end = "2024-03-01"  ,
  publication_filter = F,
  delay = 5 , 
  mc.cores = 6
)

decision_table$reference

## Writing the output of the functions in a csv table
decision_table <- read_delim("data/decision_table.csv",show_col_types = F)
# write_csv2(results$decision_table,"data/decision_table.csv")

rm(list = ls()); gc()
