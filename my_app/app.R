library(shiny)
library(bslib)
library(dplyr)
library(tidyverse)
library(ggplot2)

# Skeleton from: https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/

# Read Data
df <- read.csv('../data/raw/walmart_sales_data.csv')
# Clean up data noise per day, assign date object column
df <- df |> mutate(Date = as.Date(Date)) |> 
  group_by(Date) |>
  summarise(across(where(is.numeric), mean))

# Defaults:
metrics_default <- c('Total', 'cogs')
metric_choices <- colnames(df |> select(-Date))

time_default <- c('2019-01-01', '2019-02-01')

# Define UI for app that draws a line plot
ui <- page_sidebar(
  # App title ----
  title = "Rwalmonitor",
  
  # Sidebar panel for metric and date inputs ----
  sidebar = sidebar(width = 300,
  sliderInput(
    inputId = "date_range",
    label = "Selected Date Range",
    min = as.Date("2019-01-01"),
    max = as.Date("2019-03-30"),
    value = c(as.Date(time_default)[1], as.Date(time_default[2])),
    timeFormat = "%Y-%m-%d"
  ),
  checkboxGroupInput(
    inputId = "input_metrics",
    label = "Selected Metrics",
    choices = metric_choices,
    selected = metrics_default
  )
  ),
  
  layout_columns(
    value_box(
      title = "Total Sales in Date Range",
      value = textOutput("total_sales"),
      height='50px'
    ),
    value_box(
      title = "Total Gross Income in Date Range",
      value = textOutput("gross_income"),
      height='50px'
    ),
    value_box(
      title = "Gross Margin % in Date Range",
      value = textOutput("margin"),
      height='50px'
    )
  ),
  
  # Output Line Plot
  plotOutput(outputId = "LinePlot")
)

# Define server logic with reactive inputs
server <- function(input, output) {
  
  
  filtered_data <- reactive(
    {
    df |> filter(Date >= input$date_range[1],
                 Date <= input$date_range[2])
    }
  )
  
  output$total_sales <- renderText(
    {
      total <- filtered_data() |> 
        summarise(Total = sum(Total)) |> 
        pull(Total)
      
      scales::dollar(total)
    }
  )
  
  output$gross_income <- renderText(
    {
      gross <- filtered_data() |> 
        summarise(gross = sum(gross.income)) |> 
        pull(gross)
      
      scales::dollar(gross)
    }
  )
  
  output$margin <- renderText(
    {
      margin <- filtered_data() |> 
        summarise(margin = mean(gross.margin.percentage)/100) |> 
        pull(margin)
      
      scales::percent(margin)
    }
  )
  
  output$LinePlot <- renderPlot(
    {
    filtered_data() |> pivot_longer(cols = all_of(input$input_metrics),
                        names_to = "variable", values_to = "value") |>
      ggplot(aes(x = Date, y=value, color=variable))+
      geom_line()+
      labs(y = paste(metrics_default, collapse = ", "),
           title = 'Selected Metrics Over Time')
    }
  )
  
}

shinyApp(ui = ui, server = server)
