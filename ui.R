ui <- dashboardPage(
  dashboardHeader(
    title = shinyDashboardLogo(
      theme = "grey_light",
      boldText = "TreatPre",
      mainText = "",
      badgeText = "v1.0"
    ),
    tags$li(
      class = 'dropdown',
      style = 'padding-right: 20px; padding-top: 15px',
      textOutput('timeUI')
    )
  ),


  dashboardSidebar(
    sidebarMenu(
      div(glue("by: Jan Kozeluh"), style = "padding: 10px; color:black"),
      menuItem("Homepage", tabName = "home_page", icon = icon("house-user", verify_fa = FALSE), selected = T),
      menuItem("Prediction", tabName = "prediction", icon = icon("user", verify_fa = FALSE)),
      menuItem("Current", tabName = "current", icon = icon("gear", verify_fa = FALSE)),
      menuItem("Notes", tabName = "notes", icon = icon("notes", verify_fa = FALSE)),
      shinyWidgets::sliderTextInput(inputId = "interval",
                                    label = "Interval:",
                                    choices = c("1m", "3m", "5m", "15m", "30m", "1h", "2h", "4h", "6h", "8h", "12h",
                                                "1d", "3d", "1w", "1M"), selected = "1d"),
      sliderInput("limit", "Number of records:",
                  min = 100, max = 1000, value = 100, step = 50
      ),
      selectizeInput(
        'symbol', label = "Symbol:", choices = rjson::fromJSON(file = "symbols.json") %>%
          as.data.frame() %>%
          as.vector(),
        multiple = FALSE, selected = "BTCBUSD"
      ),
      actionButton('reload',icon('refresh'))
    )
  ),

  dashboardBody(
    shinyDashboardThemes(
      theme = "grey_light"
    ),

    tabItems(
      tabItem(tabName = "home_page", selected = T,
              uiOutput("homeUI"),
      ),
      tabItem(tabName = "prediction",
              uiOutput("predictionUI"),
      ),
      tabItem(tabName = "current",
              uiOutput("currentUI"),
      ),
      tabItem(tabName = "notes",
              uiOutput("notesUI"),
      )
    )
  )
)