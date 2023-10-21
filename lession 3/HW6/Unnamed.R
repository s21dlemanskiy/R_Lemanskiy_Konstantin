#install.packages("tidyr")
#install.packages("dplyr")
#install.packages("plotly")
#install.packages("leaflet")
#install.packages('DT')
#install.packages('htmlwidgets', 'rpivotTable')
library(dplyr)
library(plotly)
library(tidyr)
library(leaflet)
library(DT)
library(rpivotTable)
setwd("C:/Users/koly36/Desktop/RScripts")


df <- read.csv("ДЗ3_superstore_data.csv", header = TRUE)

df <- df %>% mutate(Age = 2023 - Year_Birth, Rich_flag = Income > 80000)

df_updated <- unite(df, col='Education и Marital_Status', c(Education, Marital_Status ), sep = ";", remove = TRUE)
df_updated$Rich_flag = as.numeric(df_updated$Rich_flag)

plot1 <- function (df) {
  fig <- plot_ly(df, x = ~Age, y = ~Income, type = 'scatter', mode = 'markers') #, color=~Rich_flag
  
  fig <- fig %>% layout(title = 'Распределение дохода от возраста', xaxis = list(showgrid = TRUE, title='Ages'), yaxis = list(showgrid = FALSE, title='Income'))
  return(fig)
  
}

#print(plot1(df_updated))
#опа 130 лет. Либо опрошающий заглянул в дом престорелых, либо у нас тут выброс. Давайте удалим (по хорошему такие штуки находить автомотически каким нибудь isolation forest и удалять уже выбросы не в нутри одной фичи, а уже для всех. Но ладно уж пусть пока руками).
mask <- df_updated$Age < 100
df_updated <- df[mask, ]
print(plot1(df_updated))
Sys.sleep(10)

plot2 <- function(df) {
  fig <- plot_ly(df, 
    x = ~Education,
    y = ~Marital_Status,
    z = ~Income_avg_edu,
    type = "heatmap",
    colors = colorRamp(c("green", "yellow", "brown", "red")))
  fig <- fig %>% layout(title = 'Тепловая карта по среднему доходу от образованию и Marital_Status',
                        xaxis = list(showgrid = FALSE, title='Education'),
                        yaxis = list(showgrid = FALSE, title='Marital_Status'))
  return(fig)
}
options(dplyr.summarise.inform = FALSE)
df2 <- df %>% filter(!is.na(Income)) %>% group_by(Education, Marital_Status) %>% dplyr::summarise(Income_avg_edu = mean(Income))
df2 <- merge(x=df, y=df2, by.x=c("Education", "Marital_Status"), by.y=c("Education", "Marital_Status"), suffix = c("", ".aggr"))
print(plot2(df2))
Sys.sleep(10)


plot3 <- function(labels, parents) {
  fig <- plot_ly(
    
    type="treemap",
    
    labels=labels,
    
    parents=parents
    
  )
  return(fig)
}
print(plot3(labels=c("Сотрудник 1", "Сотрудник 2", "Реклама 1", "Реклама 2", "Реклама 3"), parents=c("", "", "Сотрудник 1", "Сотрудник 1", "Сотрудник 2")))
Sys.sleep(10)

plot4 <- function(longitude, latitude) {
  m <- leaflet()
  m <- addTiles(m)
  m <- addMarkers(m, lng=longitude , lat=latitude, popup="point")
  return(m)
}
#if i pass  %>% it doesn't plot? and i don't know why. btw point is out university. 
print(plot4(longitude=37.609074, latitude=55.787918))
Sys.sleep(10)

print(datatable(df))
Sys.sleep(10)
plot6 <- function(df) {
  rpivotTable(df, rows="Education", cols="Marital_Status",width="100%", height="400px")
}
print(plot6(df_updated))