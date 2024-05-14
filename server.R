
## app.R ##
source("libraries.R")
source("fun.R")

server <- function(input, output,session) {
  
  data <- reactive({
    
    inFile <- input$input_table
    
    if (is.null(inFile))
      return(NULL)
    
    table <- read_delim(file = inFile$datapath, delim = ";",show_col_types = F) %>% 
      mutate( language = case_when( 
        str_detect(decision,"Urteil") ~ "DE",
        str_detect(decision,"Arrêt") ~ "FR",
        str_detect(decision,"Sentenza") ~ "IT",
        TRUE ~ "No language found",
      ),
      url = paste0("<a href=",url,">","link","</a>"),
      topic = type
      ) %>%
      select(date,language,topic,reference,summary,url) %>% 
      arrange(topic)
    
    
    updateSelectInput(session = session, 
                      inputId = "language", 
                      choices = table$language
    )
    
    
    updateSelectInput(session = session,
                      inputId = "topic",
                      choices = table$topic
    )
    
    return(table)
    
  })
  
  data_filtered <- reactive({

    table <- data()
    
    if (!is.null(input$language) && input$language != "")
      filteredTable <- filter(filteredTable, language == input$language)
    
    if (!is.null(input$topic) && input$topic != "")
      filteredTable <- filter(filteredTable, topic == input$topic)
    
    table <- table %>% 
      dplyr::filter( language == input$language )
    
    
    table <- table %>%
      dplyr::filter( topic == input$topic)
    
    return(table)
    
  })
  

  # table_reac <- eventReactive(input$action_button,{
  # 
  #   results <- get_TF_decision(
  #     date_start = date(input$date_range[1]),
  #     date_end =  date(input$date_range[2]),
  #     publication_filter = input$publication_filter,
  #     delay = input$delay 
  #     )
  #   
  #   # updateSelectInput(session, "subcategories", choices = results$decision$reference)
  #   
  #   return(results )
  # 
  # })
  
  output$table_output <- DT::renderDataTable(data_filtered())

}


