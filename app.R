pacman::p_load(shiny,shinydashboard,dashboardthemes,tidyverse,plotly,forecast,glue)

setwd("===your dir===")

source('ui.R')
source('server.R')

shiny::shinyApp(ui, server)
