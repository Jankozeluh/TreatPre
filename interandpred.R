pacman::p_load(tidyverse,R6,quantmod,plotly)

data_sup <- R6Class("data_sup",
                    public = list(
                      set_dt = function(symbol,interval) {
                        tryCatch({
                          private$dt <- binancer::binance_klines(symbol='BTCBUSD',interval='1d', limit=1000)
                        },
                          warning = function(warn) {
                            print(paste("Something went not as expected: ", warn))
                          },
                          error = function(err) {
                            print(err)
                            stop()
                          })
                      },
                      get_dt = function() {
                        return(private$dt)
                      }
                    ),
                    private = list(
                      dt = NULL
                    )
)

data <- data_sup$new()
data <- data_sup$new() %>% .$set_dt()

# plot(x=data$open_time,y=data$open, xlab ="Weekly Data of Sales",
#      ylab ="Total Revenue",
#      main ="Sales vs Revenue", col.main ="darkgreen")

fig <- data %>% plot_ly(x = .$open_time, type="candlestick",

                      open = .$open, close = .$close,

                      high = .$high, low = .$low)

# dig <- data %>%

