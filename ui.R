
## app.R ##
source("libraries.R")
source("fun.R")

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = "CaseBrief"),
  dashboardSidebar(disable = TRUE),
  
  dashboardBody(
    fluidRow(
      column(width = 6,
             box( width = NULL,                          
                  h3("How to use this app"),
                  "Please select a specific case law from the table on the left to view its summary in the panel on the right.",
             ),
             
             tabBox( width = NULL,
                     tabPanel(
                       "Decision table", 
                       DT::dataTableOutput(outputId = "table_output")
                     ),
                     tabPanel("Input File", 
                              fileInput(inputId = "input_table",
                                        label = "Choose a file:",
                                        multiple = F,
                                        placeholder = "data/240508_results.csv",
                                        accept = ".csv"
                              )
                     )
             ),
      ),
      column(width = 6,
             box(  width = NULL,
                   h2("Summary"),
                   DT::dataTableOutput(outputId = "table_output_summary")
             )
      )
    )
  )
)
