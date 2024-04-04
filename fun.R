
### Extracting urls 
get_url_day <- function(date_start = date_start , date_end = today()) {
  
  date_start = date(date_start)
  date_end   = date(date_end)
  
  date <- seq(date_start,date_end,by ="1 day") 
  
  date_bis <- date %>% str_remove_all("-")
  
  url <- paste("https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index_aza.php?date=",date_bis,"&lang=fr&mode=news",sep = "")
  
  table <- tibble(date = date,url = url )
  
  return(table)
  
}


get_url_decision <- function(i = i, per_day_url = per_day_url, delay = delay) {
  
  date <- per_day_url$date[[i]]
  
  url <- per_day_url$url[[i]]
  
  document <- rvest::read_html(url)
  
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
    
    Sys.sleep(delay)
    
    return(df_temp)

}

get_text_decision <- function(i = i,url_decision = url_decision,user_agent = user_agent,delay = delay){
  
  decision_table_temp <- url_decision[i,]
  
  if(is.na(decision_table_temp$url)){decision_table_temp <- tibble(date = decision_table_temp$date) ;return(decision_table_temp)}
  
  decision_temp <- rvest::read_html(decision_table_temp$url)
  
  decision <-
    decision_temp %>% 
    html_elements(".content") %>% 
    html_text()
  
  decision_table_temp <- decision_table_temp %>% 
    mutate(decision = decision[1])
  
  Sys.sleep(delay)
  
  return(decision_table_temp)
  
}
# "https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index.php?highlight_docid=aza://12-12-2022-9F_19-2022&lang=fr&zoom=&type=show_document"
# "https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index.php?highlight_docid=aza://12-12-2022-9F_19-2022&lang=fr&zoom=&type=show_document"