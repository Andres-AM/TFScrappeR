
## Basic packages 
library(tidyverse)
library(lubridate) 
library(modelr) 

## Data visualisation packages
library(shinythemes)
library(shinydashboard)
library(shinyjs)
library(rsconnect)
library(plotly)
library(kableExtra)
library(knitr) 
library(DT)

## Others 
library(polite)
library(rvest)
library(pbmcapply)
library(splines)
library(ggrepel)
library(paletteer)
library(flexdashboard)
library(reactable)
library(formattable)

## Other settings 
theme_set(theme_bw())
options(digits=4,dplyr.summarise.inform=F,"lubridate.week.start" = 1)
rm(list = ls())
cat("\014")
 