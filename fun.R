

# Web Scrapping -----------------------------------------------------------


## function wrapper
get_TF_decision <- function(date_start = date_start, 
                            date_end = date_end,
                            publication_filter = publication_filter, 
                            delay = delay 
){
  
  cat("Starting...\n")  
  
  ## Step 1, obtaining the URL for the list of decisions for the chosen days
  per_day_url <- get_url_day(date_start = date_start, date_end = date_end)
  
  url_decision_raw <-  
    map_dfr(
      1:nrow(per_day_url),         ### .x
      get_url_decision,            ### FUN
      per_day_url = per_day_url,
      delay = delay
    ) 
  
  recap_table <- url_decision_raw %>% 
    group_by(publication,date, log) %>% 
    count()
  
  url_decision <- url_decision_raw %>% 
    filter(publication %in% c(publication_filter))
  
  
  ### If no decision, because of filter 
  if(nrow(url_decision) == 0){ 
    
    cat("No published decisions were found...\n")  
    
    url_decision <- per_day_url %>% bind_cols( log = "valid page, no decision after filter")
    results <- list(recap_table= recap_table, decision_table = url_decision, url_decision = url_decision )
    return(results)
    
  }
  
  cat(paste(nrow(url_decision),"valid published decisions were found...\n"))
  
  ## Step 2, retrieving the decisions from the decision list and consolidating them into a table
  decision_table <-  
    map_dfr(
      1:nrow(url_decision),           ### .x
      get_text_decision,              ### FUN
      url_decision = url_decision,
      delay = delay
    )  
  
  results <- list(recap_table = recap_table, decision_table = decision_table, per_day_url = per_day_url)
  
  cat("Finished...\n")  
  
  
  return(results)
  
}


### Extracting urls from main page for each date
get_url_day <- function(date_start = date_start , date_end = today()) {
  
  date <- seq(date(date_start), 
              date(date_end), by ="1 day") 
  
  date_vector <- date %>% str_remove_all("-")
  
  url <- paste("https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index_aza.php?date=",date_vector,"&lang=fr&mode=news",sep = "")
  
  table <- tibble(date = date, url = url )
  
  return(table)
  
}

### Get the url for each decision for one day 
get_url_decision <- function(i = i, per_day_url = per_day_url, delay = delay){
  
  df <- per_day_url[i,]
  
  session <- polite::bow(df$url,delay = delay,force = T) 
  
  document <- polite::scrape(session)
  
  if(length(document) != 2){df <- df %>% mutate(publication = F, log = "invalid page"); return(df)}
  
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
    tibble(reference= reference, url= url, date = df$date,log = "valid page")   %>%
    filter(!reference %in% c("","Back","jour précédent","jour suivant","retour à la liste")) %>%
    mutate( type = type,publication = str_detect(type,"\\*"), ) %>%
    select(publication,date,reference,type,log,url)
  
  if(nrow(df_temp) == 0){df <- df %>% mutate(publication = F, log = "valid page, no results"); return(df)}
  
  df <- df_temp
  
  return(df)
  
}


## Get the text for each decision
get_text_decision <- function(i = i,url_decision = url_decision,delay = delay){
  
  decision_table_temp <- url_decision[i,]
  
  if(is.na(decision_table_temp$url)){decision_table_temp <- tibble(date = decision_table_temp$date, log ="valid page, no decision") ;return(decision_table_temp)}
  
  session <- polite::bow(decision_table_temp$url,delay = delay,force = T) 
  decision_temp <- polite::scrape(session)
  
  decision <-
    decision_temp %>% 
    html_elements(".content") %>% 
    html_text()
  
  decision_table_temp <- decision_table_temp %>% 
    mutate(decision = decision[1])
  
  return(decision_table_temp)
  
}


# Summarize ---------------------------------------------------------------


get_summary <- function(i = i, df = df, model = "llama3",screen = F) {
  
  df1 <- df[i,]
  text <- df1$decision
  
  question <- paste0("Summarize the following text:",text)
  cat(paste0("Decision ",i,"/",nrow(df)," ... \n  "))
  summary_text <- rollama::query(q = question,model = model,screen = screen)$message$content
  
  table <- df1 %>% mutate(summary = summary_text)
  
  return(table)
  
}
