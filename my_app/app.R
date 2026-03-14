library(shiny)
library(bslib)

# Skeleton from: https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/

# Read Data
df <- read.csv('../data/raw/walmart_sales_data.csv')
# Clean up data noise per day, assign date object column
df <- df |> mutate(Date = as.Date(Date)) |> 
  group_by(Date) |>
  summarise(across(where(is.numeric), sum))

# Defaults:
metrics_default <- c('Total', 'cogs')
time_default <- c('2019-01-01', '2019-02-01')

# Define UI for app that draws a histogram ----
ui <- page_sidebar(
  # App title ----
  title = "Rwalmonitor",
  # Sidebar panel for date inputs ----
  sidebar = sidebar(
  sliderInput(
    inputId = "date_range",
    label = "Selected Date Range",
    min = as.Date("2019-01-01"),
    max = as.Date("2019-03-30"),
    value = c(as.Date(time_default)[1], as.Date(time_default[2])),
    timeFormat = "%Y-%m-%d"
  )
  ),
  
  # Output: Histogram ----
  plotOutput(outputId = "LinePlot")
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {
  
  
  filtered_data <- reactive(
    {
    df |> filter(Date >= input$date_range[1], Date <= input$date_range[2])
    }
  )
  
  return(filtered_data)
  
  
  output$LinePlot <- renderPlot({
    
    filtered_data() |> pivot_longer(cols = all_of(metrics_default),
                                names_to = "variable", values_to = "value") |>
      filter(Date >= time_default[1], Date <= time_default[2]) |> 
      ggplot(aes(x = Date, y=value, color=variable))+
      geom_line()+
      labs(y = paste(metrics_default, collapse = ", "),
           title = 'Selected Metrics Over Time')
  
  })
  
}

shinyApp(ui = ui, server = server)
