server <- function(input, output) {

  data <- reactive({
    input$reload
    return(binancer::binance_klines(input$symbol, input$interval, input$limit))
  })

  values <- reactiveValues()

  output$homeUI <- renderUI({
    fluidRow(
      column(
        width = 4,
        tags$div(
          tags$h2('TreatPre'),
          tags$h3('Predictive Crypto Analysis'),
          tags$hr()
        ),
        tags$div(
          tags$p('
          I made this dashboard/web because I couldn\'t find a public repository anywhere(maybe I missed something).
          So i thought to myself that I will do something, I did it in a couple of hours. A lot of things are missing, I could add some technical analysis stuff, but I may look into it in time, but for now I will probably focus on the trading bot. Edit it as much as you want, I\'d just like you guys to tag me or something.
          '),
          tags$p('You can maybe extend it with a login system that has shiny easy to implement or maybe a trading interface. I tried to make it as extensible as possible. Do what you feel appropriate.')
        ),
        tags$div(
          tags$br(),
          tags$h4('By: Jan Koželuh'),
          tags$a(href="https://www.linkedin.com/in/jan-kozeluh/", "LinkedIn"),
          tags$br(),
          tags$a(href="https://github.com/Jankozeluh", "Github")
        )
      )
    )
  })


  output$predictionUI <- renderUI({
    fluidRow(
      column(12,
             plotlyOutput('predGraph'),
      ),
      column(4,
             style = 'padding-top:15px;padding-bottom: 15px;',
             sliderInput("values", "Number of forecasted values:",
                         min = 1, max = 50, value = 10
             )
      ),
      column(4,
             style = 'padding-top:15px;padding-bottom: 15px;.col-sm-4',
             selectInput("model", "Choose a prediction model:",
                         c(
                           `Arima` = "auto.arima",
                           `Arfima` = "arfima",
                           `ETS` = "ets",
                           `TBATS` = "tbats"
                         )
             ),
      ),
      column(4,
             style = 'padding-top:15px;padding-bottom: 15px;',
             renderText(values$d)
      )
    )
  })

  output$currentUI <- renderUI({
    fluidRow(
      column(12,
             plotlyOutput('actualGraph'),

      ),
      column(
        12,
        style='padding-top:15px;padding-bottom:15px;',
        infoBox("Actual Price", glue("{round(tail(data()$open,n=1),5)} $", icon = icon("dollar-sign", verify_fa = FALSE), width = 4)),
        infoBox("Volume", glue("{round(tail(data()$volume,n=1),0)}", icon = icon(verify_fa = FALSE), width = 4)),
        infoBox("N. of Trades", glue("{round(tail(data()$trades,n=1),0)}", icon = icon(verify_fa = FALSE), width = 4))
      )
    )
  })

  output$actualGraph <- renderPlotly({
    data() %>% plot_ly(x = .$open_time, type = "candlestick",
                       open = .$open, close = .$close,
                       high = .$high, low = .$low)
  })

  output$predGraph <- renderPlotly({
    dates <- seq(as.POSIXct(data()$close_time[length(data()$close_time)], origin = '1970-01-01'), by = data()$close_time[length(data()$close_time)] - data()$open_time[length(data()$close_time)], len = input$values) %>% as.POSIXct(., origin = '1970-01-01')
    dd <- forecast(do.call(input$model, list(data()$close)), h = input$values)
    values$d <- accuracy(dd)

    plot_ly() %>%
      add_lines(x = as.POSIXct(data()$open_time, origin = '1970-01-01'), y = data()$close, color = I("black"), name = "observed") %>%
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