
## Basic packages 
library(tidyverse)
library(lubridate) 

## Others 
library(polite)
library(rvest)
library(rollama)
library(shinydashboard)
library(shiny)
library(crosstalk)

## db
library(DBI)
library(RSQLite)

## Other settings 
theme_set(theme_bw())
options(digits=4,dplyr.summarise.inform=F,"lubridate.week.start" = 1)
rm(list = ls())
cat("\014")
 