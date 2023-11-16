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
  
})