pacman::p_load(shiny,shinydashboard,dashboardthemes,tidyverse,glue,plotly,R6,forecast)

setwd("/home/kozeluhh/Documents/TreatPre")

source('ui.R')
source('server.R')
# source('data_sup.R')

shiny::shinyApp(ui, server)