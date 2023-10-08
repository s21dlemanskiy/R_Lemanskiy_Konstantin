#install.packages("pivottabler")
#install.packages("dplyr")
#install.packages("ggplot2")
library(pivottabler)
library(dplyr)
library(ggplot2)
Sys.setlocale("LC_ALL", "ru_RU.UTF-8")
setwd("C:/Users/koly36/Desktop/RScripts")
run_all=TRUE
all_on_one_plot=FALSE

df <- read.csv("ДЗ3_superstore_data.csv", header = TRUE)

if (run_all) {
  print("1.С помощью функции View отобразите весь датасет в виде плоской таблицы. Насколько удобно из такого представления сделать какие-либо выводы? В каких случаях нужна именно плоская таблица, а не какая-либо другая визуализация? Напишите ваше мнение в комментариях в самом коде.")
  
  #Ну как... во-первых, я бы все же предпочел Excel тогда уж. Но даже так я считаю ниже своего достоинства пытаться делать выводы по неагрегированным данным. Впринципе, если бы мне очень хорошо заплптили, то я бы выполнил такую работу, и даже что нибудь нашел, но это был бы единоразовый прецендент. Единственное, что надо сказать, что из такого типа визуализации можно получить 1. Названия полей 2. типы полей, но пытаться вчитываться в данные в табличку на 2000 строк это унизительно, и не дай боже кому либо из програмистов этим заниматься.
  
  #View(df)

  print("2.По желанию: с помощью библиотеки pivottabler создайте сводную таблицу, где в столбцах будет Marital_Status, в строках — Education, а метрикой будет n() — кол-во наблюдений. Подробнее про построение сводной в R вы можете прочитать\n\n")
  agregatedDf <- df %>%
    group_by(Marital_Status, Education) %>%
    summarise(n=length(Id))
  
  #to stdout
  print(agregatedDf, n=31)
  
  #to stdout
  pt <- PivotTable$new()
  pt$addData(df) 
  pt$addColumnDataGroups("Marital_Status")
  pt$addRowDataGroups("Education")
  pt$defineCalculation(calculationName="TotalCount", summariseExpression="n()")
  pt$evaluatePivot()
  print(pt)
  #to viewer
  print(qhpvt(df, "Marital_Status", "Education", "n()"))
  #Ну отсюда можно узнать что я не знаю что такое YOLO. Гугл пишет что это абревиатура  "you only live once". Видимо синоним беспордочных половых связей? А еще что такое Absurd... Ну да ладно. Можно заметить что это себе выдумывают только умные ребята у которых хотя бы Master или даже PhD Но анализороать все равно сложно. Я бы лучше сделал как то так:
  colors1 <- c("grey", "green", "red", "blue", "yellow")
  df2 <- df[, c("Education", "Marital_Status", "Id")]
  edu <- (df %>% distinct(Education))$Education
  ms <- (df %>% distinct(Marital_Status))$Marital_Status
  if (all_on_one_plot) {
    par(fig=c(0,1,0,0.5), new=TRUE)
  }else{
    readline("next?:");
  }
  plot(NA, NA, type = "n", xlim = c(1, length(ms)), ylim = c(0, 400), 
       xlab = "Marital_Status", ylab = "Count", main = "Multiple Lines Plot", xaxt = "n")
  for(i in 1:length(edu)) {
    mask <- df2$Education == edu[i]
    to_plot <- df2[mask, ] %>% 
      group_by(Marital_Status) %>%
      summarise(n=length(Id))
    to_plot$Marital_Status <- sapply(to_plot$Marital_Status, function (x) which(ms == x))
    to_plot <- to_plot %>% arrange(Marital_Status)
    lines(to_plot$Marital_Status, to_plot$n, col=colors1[i], lty=i, pch=18)
  }
  legend(1, 400, title="Education", legend=edu, col=colors1, lty=seq(1, length(ms)), cex=0.8)
  axis(1, at = seq(1, length(ms)), labels = ms)
  
  
  
  if (all_on_one_plot) {
    par(fig=c(0,1,0.5,1), new=TRUE)
  }else{
    readline("next?:");
  }
  colors1 <- c("grey", "green", "red", "blue", "yellow", "black", "pink", "brown")
  plot(NA, NA, type = "n", xlim = c(1, length(edu)), ylim = c(0, 400), 
       xlab = "Education", ylab = "Count", main = "Multiple Lines Plot", xaxt = "n")
  for(i in 1:length(ms)) {
    mask <- df2$Marital_Status == ms[i]
    to_plot <- df2[mask, ] %>% 
      group_by(Education) %>%
      summarise(n=length(Id))
    to_plot$Education <- sapply(to_plot$Education, function (x) which(edu == x))
    to_plot <- to_plot %>% arrange(Education)
    lines(to_plot$Education, to_plot$n, col=colors1[i], lty=i, pch=18)
  }
  legend(1, 400, title="Marital_Status", legend=ms, col=colors1, lty=seq(1, length(ms)), cex=0.8)
  axis(1, at = seq(1, length(edu)), labels = edu)
  #тут сразу видно распределения и тп. Сводная таблица это хорошо, но не наглядно, но зато просто делается за 1 строчку а не за 120 как я тут рисовал. Хотя в matplolib было бы короче и намного быстрее... Кажется...
  print("3.Создайте столбчатую диаграмму по количеству наблюдений в датасете в разрезе столбца Education. Покрасьте столбцы по Rich_flag. Какие выводы вы можете сделать с помощью этой визуализации? Напишите их в комментариях в коде.")
  #Даничего из него не понятно. Ну можно  сравнить кол-во опрошенных с разными типами образования. Ну или сказать что фатального раскола по достатку в сфере образования вроде не наблюдается.
  df["Rich_flag"] <- df$Income > 80000
  aggr_df <- df[!is.na(df["Rich_flag"]), c("Education", "Id", "Rich_flag")] %>% 
    group_by(Education, Rich_flag) %>%
    summarise(n=length(Id))
  p <- ggplot(data=aggr_df, aes(x=n, y=Education, fill=Rich_flag)) +
    geom_bar(stat="identity")
  if (all_on_one_plot) {
    par(fig=c(0,1,0,1), new=TRUE)
  }else{
    readline("next?:");
  }
  print(p)
  print("4.Создайте линейную диаграмму, где по оси «X» будет Year_Birth, по оси «Y» — количество наблюдений (в нашем случае — людей, рождённых в конкретный год). Какие выводы вы можете сделать с помощью этой визуализации? Напишите их в комментариях в коде.")
  # ну кажется мы можем прикинуть возраст опрошенных людей... только нужно найти год опроса
  aggr_df <- df[, c("Year_Birth", "Id")] %>% 
    group_by(Year_Birth) %>%
    summarise(n=length(Id))
  p <- ggplot(data=aggr_df, aes(x=Year_Birth, y=n)) +
    geom_line(color="red") +
    ylab("год рождения") +
    xlab("кол-во людей")
  if (all_on_one_plot) {
      par(fig=c(0,1,0,1), new=TRUE)
    }else{
      readline("next?:");
    }
  print(p)
} else {
  print("sopme part of script are disabled")
}