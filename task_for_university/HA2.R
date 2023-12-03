#install.packages("tidyr")
#install.packages("dplyr")
#install.packages("plotly")
#install.packages("leaflet")
#install.packages('DT')
#install.packages('htmlwidgets', 'rpivotTable')
#install.packages("shiny")
#install.packages("readr")
#install.packages("lubridate")
#install.packages("shinydashboard")
#install.packages("qdap")
library(dplyr)
library(qdap)
# library(sqldf)
#library(plotly)
#library(tidyr)
#library(leaflet)
#library(DT)
#library(rpivotTable)
setwd("C:/Users/vniiz/Desktop/del_it/R_Lemanskiy_Konstantin")

# Лично я люблю нормальное распределение со среднем в 0 и еденичной дисперсией
lst <- as.list(rnorm(100, mean=0, sd=1))
lst <- append(lst, 10001)
print(lst[[101]])
cat("len1:", length(lst), end="\n")
lst[[101]] <- NULL
cat("len2:", length(lst), end="\n")
lst[3:8] <- c(0.0, 0.0, 1.0, 1.10, 2.0, 100.0)
lst[0:10] <- lapply(lst[0:10], function (x) as.integer(x))
cat("first 10 elem:", as.character(lst[0:10]), end="\n")
lap_res <- lapply(lst[30:33], function (x) x**2)
sap_res <- sapply(lst[30:33], function (x) x**2)
cat("sapply result type:", typeof(sap_res), "\nlapply result type:", typeof(lap_res), end="\n")
print("double type is mean that it is vaector not list, lets show it:")
cat("sapply result:", sap_res, "\nlapply result:", as.character(lap_res), end="\n")

lst <- as.list(rnorm(100, mean=0, sd=1))
lst2 <- as.list(rbinom(100, 1000, 0.25))
print(dbinom(27, 1000, 0.25))
df <- data.frame(norm = unlist(lst), bin = unlist(lst2), stringsAsFactors = FALSE)
print(head(df))
#  Сформировать датафрейм со входными параметрами не менее 10. Ну чтож, 10 так 10.
df$bin1 <- lapply(df$bin, function (x) x ** 2)
df$bin2 <- lapply(df$bin, function (x) x ** 3)
f1 <- function (x) {
  if (x > 250) {
    return("более 250")
  } 
  else {
    return ("менее 250")
  }
}
df$bin3 <- lapply(df$bin, f1)
df$bin4 <- lapply(df$bin, function (x) x * min(df$bin))
df$norm1 <- lapply(df$norm, function (x) x ** 2)
df$norm2 <- lapply(df$norm, function (x) x ** 3)
df$norm3 <- lapply(df$norm, function (x) x / 2)
df$norm4 <- lapply(df$norm, function (x) x * min(df$norm))
par(fig=c(0,1,0,0.5))
hist(df$norm)
# plot(density(df$norm))
par(fig=c(0,1,0.5,1), new=TRUE)
r1 <- df %>% group_by(bin3) %>% summarise(frequency=n())
barplot(r1$frequency, names.arg= r1$bin3)


# меня на пере не было, поэтому дорабоатать не судьба. могу с нуля попробовать что то придумать
text <- "На опушке молодого леса есть пруд. Из него бьёт подземный ключ. Это в болотах и вязких трясинах рождается Волга. Отсюда она направляется в далекий путь. Поэты и художники прославляют красоту нашей родной реки в удивительных сказках, песнях, картинах. Низкий берег покрыт зеленым ковром лугов и кустарниками. На лугу пестреют цветочки. Их сладкий запах разливается в мягком воздухе. Полной грудью вдыхаешь аромат лугов. Откос на берегу Волги очень красив. Местные жители любят проводить здесь выходные дни. Они любуются окрестностями, ловят рыбу, купаются."
# я так понял важно кол-во не повторяющихся слов
words_candidates <- strsplit(text, " ")
print(words_candidates)
normalize <- function (x) {
  x = qdap::strip(x, lower.case=TRUE)
  return (x)
}
words_candidates <- sapply(words_candidates, FUN=normalize)
print(unique(words_candidates))
print(length(unique(words_candidates)))
# print(grep("\\w", text, value = TRUE))