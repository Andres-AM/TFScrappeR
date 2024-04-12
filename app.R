
## app.R ##
source("libraries.R")
source("fun.R")

ui <- dashboardPage(skin = "red",
  dashboardHeader(title = "TFScrapper"),
  dashboardSidebar(
    
    dateRangeInput(inputId = "date_range",label = "Date range:",start = "2024-03-01",end = "2024-03-01"),
    
    sliderInput(inputId = "delay",label = "Web Scrapping delay:",min = 5,max = 10,value = 5),
    
    checkboxInput(inputId = "publication_filter",label = "Only select publications",value = T),
    
    hr(),
    
    actionButton(inputId = "action_button",label = "Run Web Scrapping")
    
  ),
  dashboardBody(
    # Boxes need to be put in a row (or column)
    fluidRow(
      
      box(
        h2("TF Scrapper"),
        "This web scraping tool is designed to retrieve the most recent case laws from the Swiss Federal Tribunal. It operates by parsing the content available at the specified website URL. It then organizes the extracted decisions, along with their corresponding texts, into a convenient table format."),
      
      
      box(
        h2("Reference menu:"),
        selectInput(inputId = "subcategories",
                    label = "reference",
                    choices = NULL)
        
      ),

      box(
        h2("Output table"),
        DT::dataTableOutput(outputId = "df_output")),

    )
  )
)

server <- function(input, output,session) {
  
  output$args <- renderText({
    
    paste(
    as.character(lubridate::as_date(input$date_range)),
    input$delay
    )
    
    
  })
  
  table_reac <- eventReactive(input$action_button,{
 
    results <- get_TF_decision(
      date_start = date(input$date_range[1]),
      date_end =  date(input$date_range[2]),
      publication_filter = input$publication_filter,
      delay = input$delay 
      )
    
    updateSelectInput(session, "subcategories", choices = results$decision$reference)
    
    return(results )
  
  })
  
  output$df_output <- DT::renderDataTable(table_reac()$recap_table)
  
}

shinyApp(ui, server)

