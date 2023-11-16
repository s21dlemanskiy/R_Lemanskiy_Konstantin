library(shiny)
library(readr)
library(dplyr)
library(ggplot2)
library(lubridate)
options(shiny.reactlog=TRUE)

shinyServer(function(input, output) {
  
  dat <- reactive({
    
    df <- read.csv("ДЗ2_vgsales.csv", header = TRUE)
    
    #moma_by_year <- 
     # moma %>%
     # filter(Department == input$department) %>%
     # filter(!is.na(DateAcquired)) %>%
     # mutate(year.acquired = year(DateAcquired)) %>%
     # group_by(year.acquired) %>%
     # summarise(nworks = n())
    
  })
  
  #output$yearplot <- renderPlot({
    
    #ggplot(dat(), aes(year.acquired, nworks)) +
     # geom_line(stat = "identity")
    
 # })
  
  #output$yeartable <- renderDataTable({
    
    #arrange(dat(), desc(nworks))
    
  #})
  output$kpi_summary_box_1 <- renderValueBox({
    valueBox(
      value = sprintf("%s", compress(245923)),
      subtitle = sprintf("KPI 1 (%.1f%%)", 8.9202),
      icon = icon("arrow-up"),
      color = "green"
    )
  })
  
  output$kpi_summary_box_2 <- renderValueBox({
    valueBox(
      value = sprintf("%s", compress(190)),
      subtitle = sprintf("KPI 2 (%.1f%%)", -0.23),
      icon = icon("arrow-down"),
      color = "red"
    )
  })
  output$kpi_summary_box_3 <- renderValueBox({
    valueBox(
      value = sprintf("%s", compress(104924422)),
      subtitle = sprintf("KPI 3 (%.1f%%)", -5.422),
      icon = icon("arrow-down"),
      color = "green"
    )
  })
  output$kpi_summary_box_4 <- renderValueBox({
    valueBox(
      value = sprintf("%s", compress(104924422)),
      subtitle = sprintf("KPI 3 (%.1f%%)", -5.422),
      icon = icon("arrow-down"),
      color = "green"
    )
  })
  
})