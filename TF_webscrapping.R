
## Importing the libraries and functions
source("../libraries.R")
source("fun.R")

# date_start = "2023-01-16"
# date_end = "2023-01-16"
# publication_filter = T
# delay = 5 
# mc.cores = 8
# 
# date_start = "2024-04-28"
# date_end = "2024-04-28"  

## Function to use 
decision_table <- get_TF_decision(
  date_start = "2024-03-01", 
  date_end = "2024-03-16"  ,
  publication_filter = T,
  delay = 5 , 
  mc.cores = 8
);decision_table
# 
# $decision_table

## Writing the output of the functions in a csv table
write_csv2(decision_table,"data/decision_table.csv")

rm(list = ls()); gc()
view(decision_table$recap_table)
decision_table$decision_table[1,]$decision
