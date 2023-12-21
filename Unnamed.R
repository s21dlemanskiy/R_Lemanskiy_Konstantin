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
# install.packages("gtools")
library(dplyr)
library(qdap)
library(gtools)
# library(sqldf)
#library(plotly)
#library(tidyr)
#library(leaflet)
#library(DT)
#library(rpivotTable)
setwd("C:/Users/vniiz/Desktop/del_it/R_Lemanskiy_Konstantin")


set.seed(100010001)
# я вроде как 16 и человек у нас вроде 25 (я спецально взял только 100 значений что бы не было 100% совподения распределения и выборки)
k <- 16
n <- 25
data_length = 100
norm_variaty <- rnorm(n=data_length, mean=k*100, sd=sqrt(n + k))
binom_variaty <- rbinom(n=data_length, size=n, prob=k/n)
chi_sqr_variaty <- rchisq(n=data_length, df=(n - 1 + k))


my_describe <- function(data) {
  cat("mean:", mean(data), "\n")
  cat("dispersion:", sd(data) ** 2, "\n")
  cat("mode:", mode(data), "\n")
  cat("median:", median(data), "\n")
}
cat("1. norm_variaty", "\n", sep="")
my_describe(norm_variaty)
cat("\n", "2. binom_variaty", "\n", sep="")
my_describe(binom_variaty)
cat("\n", "3. chi_sqr_variaty", "\n", sep="")
my_describe(chi_sqr_variaty)

options(repr.plot.width=6, repr.plot.height=10)
x <- seq(min(norm_variaty), max(norm_variaty), length = 100)
y <- dnorm(x, mean=k*100, sd=sqrt(n + k))
plot(density(norm_variaty))
par(new=TRUE)
plot(x, y, xaxt='n', yaxt='n')



x <- seq(min(binom_variaty), max(binom_variaty), length = max(binom_variaty) - min(binom_variaty) + 1)
y <- dbinom(x, size=n, prob=k/n)
plot(density(binom_variaty)) 
par(new=TRUE)
plot(x, y, xaxt='n', yaxt='n')
# plot(density(chi_sqr_variaty)) 

# options(repr.plot.width=6, repr.plot.height=100)
x <- seq(min(chi_sqr_variaty), max(chi_sqr_variaty), length = 100)
y <- dchisq(x, df=(n - 1 + k))
plot(density(chi_sqr_variaty))
par(new=TRUE)
plot(x, y, xaxt='n', yaxt='n')


cat("задание 2:", "\n")
cat("1)", "\n")
cat("a)", (choose(35, 2) + choose(25, 3)) / choose(60, 5), "\n")
# вероятность того что ремантируется хотя бы один автомобиль ф.р. = 1- вероятности что не ремантируется ни одного авт. ф.р.
cat("б)", 1 - ((choose(25, 5)) / choose(60, 5)), "\n")
cat("2)", "\n")
# ф-ла включений исключений
s <- 0
for (i in 1:360) {
  s <- s + (-1) ** (i + 1) * choose(360, i) * ((1/365) ** i)
}
cat("a)", s, "\n")
magicFun <- function(n_p){
  s <- 0
  for (i in 1:n_p) {
    s <- s + (-1) ** (i + 1) * choose(n_p, i) * ((1/365) ** i)
  }
  return(s > 0.5)
}
# на самом деле binsearch тут не обьязательно я просто сначала накосячил и сделал бесконечный цикл, так что пусть будет.
x <- binsearch(magicFun, range = c(1,360), showiter = F, target = 0.5)
cat("б)", x$where[1], "\n")



# Не играл в покер. Только где то видел какую то разновидность в какой то компьютерной игрушке, так что за комбинации шарю.
cat("задание 3:", "\n")
cards_count <- 52
# 52 / 4 = 13
# всего комбинаций
all_comb <- choose(52, 5)
# на самом деле не так уж и много. Можно и перебрать.
p_royal_flesh <- 4 / all_comb
cat("ь)", p_royal_flesh, "\n")
p_street_flesh <- 8 * 4 / all_comb
cat("з)", p_street_flesh, "\n")
p_care <- 13 * 48 / all_comb
cat("ж)", p_care, "\n")
p_tree_two <- 13 * choose(4, 3) * 12 * choose(4, 2) / all_comb
cat("е)", p_tree_two, "\n")
p_flesh <- 4 * choose(13, 5) / all_comb  - p_street_flesh - p_royal_flesh
cat("д)", p_flesh, "\n")
# если здесь заменить 13 в двух местах на 10 то ответы сойдутся с https://www.nkj.ru/archive/articles/2463/#:~:text=%D0%9E%D0%B1%D1%89%D0%B5%D0%B5%20%D1%87%D0%B8%D1%81%D0%BB%D0%BE%20%D0%B2%D1%81%D0%B5%D1%85%20%D0%BA%D0%B0%D1%80%D1%82%D0%BE%D1%87%D0%BD%D1%8B%D1%85%20%D0%BA%D0%BE%D0%BC%D0%B1%D0%B8%D0%BD%D0%B0%D1%86%D0%B8%D0%B9,21%2C%20%D0%BF%D0%B0%D1%80%D1%83%201%2F2.
# так 
p_street <- 13 * (4 ** 5) / all_comb - p_street_flesh - p_royal_flesh - 13 * 4 / all_comb
cat("г)", p_street, "\n")
p_tree <- 13 * choose(4, 3) *  choose(48, 2) / all_comb - p_tree_two
cat("в)", p_tree, "\n")
p_two_two <- choose(13, 2) * (choose(4, 2) ** 2) * 44 / all_comb
cat("б)", p_two_two, "\n")
# p_two <- 13 * choose(4, 2) * choose(48, 3) / all_comb - 12 * choose(4, 3) / all_comb -  12 * choose(4, 2)* (11 * 4) / all_comb
# # я учел два-два и три-два а есть еще флеш
# # p_two <- p_two - 
# cat("а)", p_two, "\n")
# в двойке много включений исключений.... крч душно. Так что на двойку я забил.

