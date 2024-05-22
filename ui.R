
## app.R ##
source("libraries.R")
source("fun.R")

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = "TFScrapper"),
  dashboardSidebar(disable = TRUE),
  
  dashboardBody(
    fluidRow(
      box(                          
        width = 12,
        h2("Summary"),
        # DT::dataTableOutput(outputId = "table_output_summary")
      ),
      
      tabBox(width = 12,
             tabPanel("Table", 
                      DT::dataTableOutput(outputId = "table_output")
             ),
             tabPanel("Param", 
                      fileInput(inputId = "input_table",
                                label = "Choose a file:",
                                multiple = F,
                                placeholder = "data/240508_results.csv",
                                accept = ".csv"
                      )
             )
      )
    )
  )
)


