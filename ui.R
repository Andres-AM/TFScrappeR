
## app.R ##
source("libraries.R")
source("fun.R")

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(title = "TFScrapper"),
  dashboardSidebar(disable = TRUE),
  
  dashboardBody(
    fluidRow(
      column(width = 6,
             box( width = NULL,                          
                  h3("How to use this app"),
                  "Please select a specific case law from the table on the left to view its summary in the panel on the right.",
                  "The most recent decision is listed at the top of the table. To update the database, run the TFScrapper script to retrieve the latest case laws.",
                  p("Number of decisions in the database:",textOutput(outputId = "n_rows"),inline= F)
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
                                        placeholder = "data/db/2024-05-08_results.csv",
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
