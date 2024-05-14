
## app.R ##
source("libraries.R")
source("fun.R")

ui <- dashboardPage(skin = "red",
                    dashboardHeader(title = "TFScrapper"),
                    dashboardSidebar(
                      
                      fileInput(inputId = "input_table",
                                label = "Choose a file:",
                                multiple = F,
                                placeholder = "data/240508_results.csv"
                      )
                      
                    ),
                    dashboardBody(
                      fluidRow(
                        
                        box(
                          h2("TF Scrapper"),
                          selectInput(inputId = "language",
                                      label = "language",
                                      choices = NULL
                                      ),           
                          
                          selectInput(inputId = "topic",
                                      label = "topic",
                                      choices = NULL
                          ),  
                        ),
                        
                        box(
                          h2("Output table"),
                          DT::dataTableOutput(outputId = "table_output")
                        ),
                      )
                    )
)


