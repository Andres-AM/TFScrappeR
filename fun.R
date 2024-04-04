
### Extracting urls 
get_url_day <- function(date_start = date_start , date_end = today()) {
  
  date_start = date(date_start)
  date_end   = date(date_end)
  
  date <- seq(date_start,date_end,by ="1 day") 
  
  date_bis <- date %>% str_remove_all("-")
  
  url <- paste("https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index_aza.php?date=",date_bis,"&lang=fr&mode=news",sep = "")
  # home_page <- "https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index_aza.php?lang=fr&mode=index"
  
  table <- tibble(date = date,url = url )
  
  return(table)
  
}


get_url_decision <- function(i = i, per_day_url = per_day_url, delay = delay) {
  
  date <- per_day_url$date[[i]]
  
  url <- per_day_url$url[[i]]
  
  session <- polite::bow(url,delay = delay,force = T) 
  
  document <- polite::scrape(session)

  if(length(document) != 2){df_temp <- tibble(date = date) ;return(df_temp)}

    document_temp <- 
      document %>% 
      html_elements("#maincontent") 
    
    reference <- 
      document_temp %>%
      html_elements("a") %>% 
      html_text() 
    
    url <-
      document_temp %>%
      html_elements("a") %>% 
      html_attr("href") 
    
    type <-
      document_temp %>% 
      html_elements("cite") %>% 
      html_text2()
    
    df_temp <- 
      tibble(date = date, reference= reference,url= url)   %>%
      filter(!reference %in% c("","Back","jour précédent","jour suivant","retour à la liste")) %>%
      mutate( publication = str_detect(type,"\\*")) %>%
      bind_cols(type = type) %>% 
      select(publication,date,reference,type,url)
    
    # Sys.sleep(delay)
    
    return(df_temp)

}

get_text_decision <- function(i = i,url_decision = url_decision,user_agent = user_agent,delay = delay){
  
  decision_table_temp <- url_decision[i,]
  
  if(is.na(decision_table_temp$url)){decision_table_temp <- tibble(date = decision_table_temp$date) ;return(decision_table_temp)}
  
  session <- polite::bow(decision_table_temp$url,delay = delay,force = T) 
  decision_temp <- polite::scrape(session)
  
  # decision_temp <- rvest::read_html(decision_table_temp$url)
  
  decision <-
    decision_temp %>% 
    html_elements(".content") %>% 
    html_text()
  
  decision_table_temp <- decision_table_temp %>% 
    mutate(decision = decision[1])
  
  # Sys.sleep(delay)
  
  return(decision_table_temp)
  
}

## Wrapper
get_TF_decision <- function(date_start = date_start, date_end = date_end, delay = delay, mc.cores = mc.cores) {
  
  ## Step 1, obtaining the URL for the list of decisions for the chosen days
  per_day_url <- get_url_day(date_start = date_start,date_end = date_end)
  
  url_decision <-  
    pbmclapply(         
      1:nrow(per_day_url),         ### .x
      get_url_decision,            ### FUN
      per_day_url = per_day_url,
      mc.cores = mc.cores,
      delay = delay
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
  
  results <- list(url_decision = url_decision, decision_table = decision_table)
  
  return(results)
  
}