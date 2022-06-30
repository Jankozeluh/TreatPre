pacman::p_load(shiny,shinydashboard,dashboardthemes,tidyverse,plotly,forecast)

setwd("/home/kozeluhh/Documents/TreatPre")

source('ui.R')
source('server.R')

shiny::shinyApp(ui, server)