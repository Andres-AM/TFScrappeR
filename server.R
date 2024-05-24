
## app.R ##
source("libraries.R")
source("fun.R")

server <- function(input, output,session) {
  
  data_table <- reactive({
    
    con <- dbConnect(RSQLite::SQLite(), dbname = "data/db/my_db.sqlite")
    
    data <- as_tibble(dbGetQuery(con, "SELECT * FROM my_table"))  
    
    dbDisconnect(con)
    
    table <- data |> 
      mutate( 
        date = as_date(date),
        language = as.factor(case_when( 
          str_detect(decision,"Urteil") ~ "Deutsch",
          str_detect(decision,"Arrêt") ~ "Français",
          str_detect(decision,"Sentenza") ~ "Italiano",
          TRUE ~ "No language found")),
        reference = paste0("<a href=",url,">",reference,"</a>"),
        topic = as.factor(type)
      ) |> 
      select(date,language,topic,reference,summary) |> 
      arrange(desc(date))
    
    n_rows <- nrow(table)
    
    return(list(table = table, n_rows = n_rows))
    
  })
  
  output$n_rows <- renderText(data_table()$n_rows)
  
  shared_data1 <- SharedData$new(
    reactive({ data_table()$table |>  select(reference,summary)}) ,
    key = ~reference,
    group = "groupdata"
  )
  
  shared_data2 <- SharedData$new(
    reactive({ data_table()$table |>  select(-summary)}),
    key = ~reference,
    group = "groupdata"
  )
  
  output$table_output <- DT::renderDataTable(
    shared_data2,
    options = list(
      paging = T,
      # info = FALSE,
      pageLength = 15,
      # dom = "t"
      scrollY = TRUE
      ),
    rownames = FALSE,
    filter = "top",
    escape = F,
    server = F,
    selection = list(mode = 'single', selected = 1) 
    )
  
  output$table_output_summary <- DT::renderDataTable(
    shared_data1,
    options = list(
      paging = F,
      pageLength = 10,
      dom = "t",
      scrollY = TRUE),
    rownames = FALSE,
    filter = "top",
    escape = F,
    server = F,
    selection = "none",
    )
  
}
