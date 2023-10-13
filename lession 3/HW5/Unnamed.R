#install.packages("tidyr")
#install.packages("dplyr")
#install.packages("stringr")
#install.packages("ggplot2")
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
setwd("C:/Users/koly36/Desktop/RScripts")


df <- read.csv("ДЗ3_superstore_data.csv", header = TRUE)

df <- df %>% mutate(Age = 2023 - Year_Birth, Rich_flag = Income > 80000)

df_updated <- unite(df, col='Education и Marital_Status', c(Education, Marital_Status ), sep = ";", remove = TRUE)
df_updated$Rich_flag = as.numeric(df_updated$Rich_flag)

haveNanValues <- function(x) {
  any(is.nan(x))
}

print(sapply(df_updated, haveNanValues))

plot1 <- ggplot(df_updated, aes(x=factor(Response), y=Age)) + geom_boxplot()
print(plot1)

#можно испольщрвать и просто "9", тк он проверяет не всю стоку, а просто ищет вхождение
print(df_updated[str_which(as.factor(df_updated$Age), "^.*9.*$"),])
