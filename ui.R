library(shiny)
library(shinydashboard)

shinyUI(fluidPage(
  
  titlePanel("EmptyPlot"),
  
  # sidebarLayout(
  #sidebarPanel(
  # selectInput("name", label = "Name", choices = unique(data$Name))
  #),
  
  mainPanel(
  plotOutput("kpi_summary_box_1"),
  valueBoxOutput("kpi_summary_box_1")
  )
))