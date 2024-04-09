
## Importing the libraries and functions
source("../libraries.R")
source("fun.R")

date_start = "2024-03-10" 
date_end = "2024-03-10"  
publication_filter = T
delay = 5 
mc.cores = 8

## Function to use 
results <- get_TF_decision(
  date_start = "2024-03-10", 
  date_end = "2024-03-10"  ,
  publication_filter = T,
  delay = 5 , 
  mc.cores = 6
);results 

view(results$recap_table)
 
## Writing the output of the functions in a csv table
write_csv2(results$decision_table,"data/decision_table.csv")

rm(list = ls()); gc()