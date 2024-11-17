
## Importing the libraries and functions
source("libraries.R")
source("fun.R")

# Web Scrapping -----------------------------------------------------------

# date_test="2024-03-05"

system.time(
  results <- get_TF_decision( date_start = "2024-05-02", 
                              date_end = today(),
                              publication_filter = T,
                              delay = 5 
  )
)

results

## Writing the output of the functions in a csv table (commented)
write_csv2(results$decision_table,paste0("data/temp/",today(),"_temp_results.csv"))
df <- read_delim("data/temp/2024-05-23_temp_results.csv", delim = ";",show_col_types = F)

# Summarizing ---------------------------------------------------------------

system.time(
  results_summarized <- map_dfr(.x = 1:nrow(df),
                                .f = get_summary,
                                df = df,
                                model = "llama3"
  )
)[[3]] |> lubridate::dseconds()

write_csv2(results_summarized,paste0("data/db/",today(),"_results.csv"))

rm(list = ls()); gc()

# test --------------------------------------------------------------------

rollama::query(q = paste("You are a skilled swiss lawyer and are asked your expertise:",
                         "based on the following 94 case law summaries, which ones seems the most interesting to present in an oral presentation and interesting from a law perspective",
                         "give a list of a reason why and the name of the position of the summary  from the list of summaries",
                         data$summary
                         ),model = "llama3",screen = T)

# Creating and updating the db ---------------------------------------------------------------

con <- dbConnect(RSQLite::SQLite(), dbname = "data/db/my_db.sqlite")

dbExecute(con, 
          "
  CREATE TABLE IF NOT EXISTS my_table (
    reference TEXT PRIMARY KEY,
    date TEXT,
    url TEXT,
    publication TEXT,
    log TEXT,
    type TEXT,
    decision TEXT,
    summary TEXT
  )
          "
)

add_data(con, read_delim("data/db/2024-05-08_results.csv", delim = ";",show_col_types = F))
add_data(con, read_delim("data/db/2024-05-23_results.csv", delim = ";",show_col_types = F))

# Query data from the table
data <- as_tibble(dbGetQuery(con, "SELECT * FROM my_table")) |> 
  mutate( date = as_date(date))

dbDisconnect(con)

# test bis ----------------------------------------------------------------
