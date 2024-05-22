
## app.R ##
source("libraries.R")
source("fun.R")

server <- function(input, output,session) {
  
  data_table <- reactive({
    
    inFile <- input$input_table
    
    if (is.null(inFile)) inFile$datapath <- "data/240508_results.csv"
    
    table <- read_delim(file = inFile$datapath, delim = ";",show_col_types = F) |> 
      mutate( language = as.factor(case_when( 
        str_detect(decision,"Urteil") ~ "Deutsch",
        str_detect(decision,"Arrêt") ~ "Français",
        str_detect(decision,"Sentenza") ~ "Italiano",
        TRUE ~ "No language found",
      )),
      reference = paste0("<a href=",url,">",reference,"</a>"),
      topic = as.factor(type)
      ) |> 
      select(date,language,topic,reference,summary) |> 
      arrange(language,topic)

    return(table)
    
  })
  
  shared_data <- SharedData$new(data_table)
  
  
  output$table_output <- DT::renderDataTable(
    shared_data,
    options = list(
      paging = F,
      pageLength = 10,
      dom = "t",
      scrollY = TRUE),
    rownames = FALSE,
    filter = "top",
    escape = F,server = F)
  
  output$table_output_summary <- DT::renderDataTable(
    shared_data$summary,
    options = list(
      paging = F,
      pageLength = 10,
      dom = "t",
      scrollY = TRUE),
    rownames = FALSE,
    filter = "top",
    escape = F,server = F)
}


