#library(dplyr)

setwd("C:/Users/koly36/Desktop/RScripts")


df <- read.csv("ДЗ3_superstore_data.csv", header = TRUE)

print(head(df))
print(colnames(df))
#print( df %>% filter(Income > 30000))
print( filter(df, Income > 30000))


