
### Extracting links 
get_url_day <- function(link = link ) {
  
  document <- rvest::read_html(link)
  
  document_temp <- document %>% 
    html_elements("#maincontent") %>%
    html_elements("a") 
  
  date <- document_temp %>% 
    html_text() 
  
  link <- document_temp %>% 
    html_attr("href") 
  
  df <- tibble(date= date,link= link ) %>%
    filter(!date %in% c("","Back")) %>% 
    mutate(date = as_date(date,format = "%d.%m.%Y"))

  return(df)
  
}

get_url_decision <- function(i = i, per_day_link = per_day_link,delay = delay) {
  
  date <- per_day_link$date[[i]]
  
  link <- per_day_link$link[[i]]
  
  document <- rvest::read_html(link)
  
  document_temp <- 
    document %>% 
    html_elements("#maincontent") 
  
  reference <- 
    document_temp %>%
    html_elements("a") %>% 
    html_text() 
  
  link <-
    document_temp %>%
    html_elements("a") %>% 
    html_attr("href") 
  
  type <-
    document_temp %>% 
    html_elements("cite") %>% 
    html_text2()
  
  df_temp <- 
    tibble(date = date, reference= reference,link= link) %>% 
    filter(!reference %in% c("","Back","jour précédent","jour suivant","retour à la liste")) %>% 
    mutate( publication = str_detect(type,"\\*")) %>% 
    bind_cols(type = type) %>% select(publication,date,reference,type,link)  
  
  Sys.sleep(delay)
  
  return(df_temp)
  
}

get_text_decision <- function(i = i,url_decision = url_decision,user_agent = user_agent,delay = delay) {
  
  decision_table_temp <- url_decision[i,]
  
  decision_temp <- rvest::read_html(decision_table_temp$link)
  
  decision <-
    decision_temp %>% 
    html_elements(".content") %>% 
    html_text()
  
  decision_table_temp <- decision_table_temp %>% 
    mutate(decision = decision[1])
  
  Sys.sleep(delay)
  
  return(decision_table_temp)
  
}

