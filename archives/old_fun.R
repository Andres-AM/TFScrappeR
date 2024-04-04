
get_url_day_old <- function(link = link ) {
  
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