
## Importing the libraries and functions
source("../libraries.R")
source("fun.R")

## Function to use 
results <- get_TF_decision(
  date_start = "2024-03-01", 
  date_end = "2024-03-01"  ,
  publication_filter = T,
  delay = 5 , 
  mc.cores = 6
);results 

results$decision_table %>% 
  group_by(type) %>% 
  count() %>% 
  view()


## Writing the output of the functions in a csv table
write_csv2(results$decision_table,"data/decision_table.csv")

rm(list = ls()); gc()
