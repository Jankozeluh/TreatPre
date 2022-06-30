server <- function(input, output) {
  data <- reactive({
    input$reload
    return(binancer::binance_klines(input$symbol,input$interval,input$limit))
  })

  output$homeUI <- renderUI({
    fluidRow(
      column(
        width = 12,
        # tags$h2(glue("Your permission level is: {user_info()$permission}.")),
      )
    )
  })


  output$predictionUI <- renderUI({
    fluidRow(
      column(12,
             plotlyOutput('predGraph'),
      ),
      column(4,
             selectInput("model", "Choose a prediction model:",
                         c(
                           `Arima` = "auto.arima",
                           `Arfima` = "arfima",
                           `ETS` = "ets",
                           `TBATS` = "tbats"
                         )
             ),
             sliderInput("values", "Number of forecasted values:",
                         min = 1, max = 50, value = 10
             ),
             infoBox("Actual Price", glue("{tail(data()$open,n=1)}  $", icon = icon(verify_fa = FALSE), width = 4))
      )
    )
  })

  output$currentUI <- renderUI({
    fluidRow(
      column(12,
             textOutput('kk')
      ),
      column(12,
             plotlyOutput('actualGraph'),
             infoBox("Actual Price", glue("{round(tail(data()$open,n=1),5)} $", icon = icon(verify_fa = FALSE), width = 4)),
             infoBox("Volume", glue("{round(tail(data()$volume,n=1),0)}", icon = icon(verify_fa = FALSE), width = 4)),
             infoBox("N. of Trades", glue("{round(tail(data()$trades,n=1),0)}", icon = icon(verify_fa = FALSE), width = 4))
      ),
      column(
        12,
         DT::datatable(data())
      )
    )
  })

  output$notesUI <- renderUI({
    fluidRow(
      column(12,
             textOutput('kk')
      ),
      column(12,

      ),
      column(
        12,
        DT::datatable(data())
      )
    )
  })

  output$actualGraph <- renderPlotly({
    data() %>% plot_ly(x = .$open_time, type = "candlestick",
                     open = .$open, close = .$close,
                     high = .$high, low = .$low)
  })

  output$predGraph <- renderPlotly({
    dates <- seq(as.POSIXct(data()$close_time[length(data()$close_time)], origin='1970-01-01'), by=data()$close_time[length(data()$close_time)] - data()$open_time[length(data()$close_time)], len=input$values) %>% as.POSIXct(., origin='1970-01-01')
    dd <-  forecast(do.call(input$model,list(data()$close)),h=input$values)

    plot_ly() %>%
      add_lines(x = as.POSIXct(data()$open_time, origin='1970-01-01'), y = data()$close, color = I("black"), name = "observed") %>%
      add_lines(x = dates, y = dd$mean, color = I("blue"), name = "prediction") %>%
      add_ribbons(x = dates,
                  ymin = dd$lower[, 2],
                  ymax = dd$upper[, 2],
                  color = I("gray95"),
                  name = "95% confidence") %>%
      add_ribbons(p,
                  x = dates,
                  ymin = dd$lower[, 1],
                  ymax = dd$upper[, 1],
                  color = I("gray80"), name = "80% confidence")
  })

  output$timeUI <- renderText({
    invalidateLater(as.integer(1000))
    format(Sys.time())
  })
}