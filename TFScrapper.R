

# Web Scrapping -----------------------------------------------------------

## Importing the libraries and functions
source("libraries.R")
source("fun.R")

# date_start = "2024-03-02"
# date_end = "2024-03-02"
# publication_filter = T
# delay = 5

date_test="2024-03-05"

system.time(
  results <- get_TF_decision( date_start = date_test, 
                              date_end = date_test,
                              publication_filter = T,
                              delay = 5 
  )
)

results

## Writing the output of the functions in a csv table (commented)
# write_csv2(results$decision_table,"data/results_temp.csv")
# df <- read_delim("data/results_temp.csv", delim = ";",show_col_types = F)

# Summarize ---------------------------------------------------------------

df <- results$decision_table

system.time(
  results_summarized <- map_dfr(.x = 1:nrow(df),
                                .f = get_summary,
                                df = df
  )
)

write_csv2(results_summarized,"data/results.csv")


rm(list = ls()); gc()

