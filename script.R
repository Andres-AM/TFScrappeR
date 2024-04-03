
source("../libraries.R")
source("fun.R")
library(rvest)

## Parameters
home_page <- "https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index_aza.php?lang=fr&mode=index"
delay = 5
mc.cores = 8

# Is the webscrapping process polite
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


write_csv2(decision_table,"data/decision_table.csv")


### Partie 2 

  ## avec la recherche
# "https://www.bger.ch/ext/eurospider/live/fr/php/clir/http/index.php?lang=fr&type=simple_query&query_words=7B_1014%2F2023++&lang=fr&top_subcollection_clir=bge&from_year=1954&to_year=2024&x=63&y=10"
# "https://www.bger.ch/ext/eurospider/live/fr/php/clir/http/index.php?lang=fr&type=simple_query&page=1&from_date=&to_date=&from_year=1954&to_year=2024&sort=relevance&insertion_date=&from_date_push=&top_subcollection_clir=bge&query_words=7B_1014%2F2023++&part=all&de_fr=&de_it=&fr_de=&fr_it=&it_de=&it_fr=&orig=&translation="
# "https://www.bger.ch/ext/eurospider/live/fr/php/clir/http/index.php?lang=fr&type=simple_query&page=2&from_date=&to_date=&from_year=1954&to_year=2024&sort=relevance&insertion_date=&from_date_push=&top_subcollection_clir=bge&query_words=7B_1014%2F2023++&part=all&de_fr=&de_it=&fr_de=&fr_it=&it_de=&it_fr=&orig=&translation="
#  
# combiner avec le search engine