
## Web scrapping the Swiss Federal Tribunal case law using R

This web scraping tool is designed to retrieve the most recent case laws from the Swiss Federal Tribunal. It operates by parsing the content available at the specified website URL: https://www.bger.ch/ext/eurospider/live/fr/php/aza/http/index_aza.php?lang=fr&mode=index&search=false. It then organizes the extracted decisions, along with their corresponding texts, into a convenient table format.

## Dependencies

This project relies on the following R packages:

- dplyr: utilized for data manipulation
- rvest: employed for web scraping
- purr: utilized for automating processes

## How to run it 

Execute the complete TF_webscrapping.R script to fetch the most recent case laws from the Swiss Federal Tribunal and generate the corresponding table.