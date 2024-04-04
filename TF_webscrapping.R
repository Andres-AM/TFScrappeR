
## Importing the libraries and functions
source("../libraries.R")
source("fun.R")

## Parameters for web scrapping
home_page <- "https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index_aza.php?lang=fr&mode=index"
delay = 5
mc.cores = 8
date_start = "2024-03-10"
date_end = "2024-03-14"

## Step 1, obtaining the URL for the list of decisions for the chosen days
per_day_url <- get_url_day(date_start = date_start,date_end = date_end)

url_decision <-  
  pbmclapply(         
    1:nrow(per_day_url),         ### .x
    get_url_decision,            ### FUN
    per_day_url = per_day_url,
    mc.cores = mc.cores,
    delay = 5
  ) %>% 
  map_dfr(~ .x)

## Step 2, retrieving the decisions from the decision list and consolidating them into a table
decision_table <-  
  pbmclapply(         
    1:nrow(url_decision),           ### .x
    get_text_decision,              ### FUN
    url_decision = url_decision,
    mc.cores = mc.cores,
    delay = delay
  ) %>% 
  map_dfr(~ .x)

## Step 3, writting the output of the functions in a csv table
write_csv2(decision_table,"data/decision_table.csv")
