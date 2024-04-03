
## Importing the libraries and functions
source("../libraries.R")
source("fun.R")

## Parameters for web scrapping
home_page <- "https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index_aza.php?lang=fr&mode=index"
delay = 5
mc.cores = 8
session <- polite::bow(home_page,delay = delay);session
is.polite(session)

per_day_link <- get_url_day(home_page)

system.time(
  url_decision <-  pbmclapply(X = 1:nrow(per_day_link),
                              FUN = get_url_decision,
                              per_day_link = per_day_link,
                              delay = delay,
                              mc.cores = mc.cores
  ) %>% map_dfr(~ .x)
)

system.time(
  decision_table <-  pbmclapply(X = 1:nrow(url_decision),
                                FUN = get_text_decision,
                                url_decision = url_decision,
                                delay = delay,
                                mc.cores = mc.cores
  ) %>% map_dfr(~ .x)
)

## Writting the output of the functions in a csv table
write_csv2(decision_table,"data/decision_table.csv")


