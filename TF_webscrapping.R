
## Importing the libraries and functions
source("../libraries.R")
source("fun.R")


## Function to use 
decision_table <- get_TF_decision(date_start = "2024-03-19", date_end = "2024-03-19", delay = 5 , mc.cores = 8)$decision_table

## Writing the output of the functions in a csv table
write_csv2(decision_table,"data/decision_table.csv")

rm(list = ls()); gc()
