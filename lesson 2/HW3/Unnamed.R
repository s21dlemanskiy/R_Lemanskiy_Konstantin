library(dplyr)

setwd("C:/Users/koly36/Desktop/RScripts")


df <- read.csv("ДЗ3_superstore_data.csv", header = TRUE)

print(head(df))
print(colnames(df))
#print( df %>% filter(Income > 30000))
print( filter(df, Income > 30000))

print( df %>% select(Id, Year_Birth, Education, Marital_Status, Income, Response))

df <- df %>% mutate(Age = 2023 - Year_Birth, Rich_flag = Income > 80000)

df2 <- df %>% filter(!is.na(Income)) %>% group_by(Education) %>% summarise(Income = mean(Income))

print(merge(df, df2, by=c("Education", "Education"), suffix = c("", ".aggr")))



