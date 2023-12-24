#install.packages("shiny")
#install.packages("shinydashboard")
#install.packages("readr")
#install.packages("ggplot2")
#install.packages("dplyr")
#install.packages("plotly")
#install.packages("sqldf")
# install. packages('xlsx') 
# install.packages("mltools")
# install.packages("DescTools")
# install.packages("ggpubr")
# install.packages("psych")
# install.packages("rcompanion")
# install.packages("caTools")
# library(shiny)
# library(shinydashboard)
# library (xlsx)
library(ggplot2)
library(readr)
library(dplyr)
library(plotly)
library(sqldf)
library(mltools)
library(DescTools)
library(data.table)
library(ggpubr)
library (psych)
library (rcompanion)
library(caTools)
library(Metrics) 
library(tidymodels)
library(tidyr)
setwd("C:/Users/vniiz/Desktop/del_it/R_Lemanskiy_Konstantin")
set.seed(1224)
# campaign_desc <- read_csv("data/campaign_desc.csv", col_types = "ciii")
# campaign_table <- read_csv("data/campaign_table.csv", col_types = "cii")
# causal_data <- read_csv("data/causal_data.csv", col_types = "iiicc")
# coupon <- read_csv("data/coupon.csv", col_types = "cii")
# coupon_redempt <- read_csv("data/coupon_redempt.csv", col_types = "iici")
hh_demographic <- read_csv("data/hh_demographic.csv", col_types = "ccccccc")
#product <- read_csv("data/product.csv", col_types = "iiccccc")
transaction_data <- read_csv("data/transaction_data.csv", col_types = "iciiididiidd")
overall_df <- sqldf("select
            t1.household_key,
            t1.BASKET_ID,
            t1.DAY,
            t1.PRODUCT_ID,
            t1.QUANTITY,
            t1.SALES_VALUE,
            t1.STORE_ID,
            t1.RETAIL_DISC,
            t1.TRANS_TIME,
            t1.WEEK_NO,
            t1.COUPON_DISC,
            t1.COUPON_MATCH_DISC,
            t2.AGE_DESC,
            t2.MARITAL_STATUS_CODE,
            t2.INCOME_DESC,
            t2.HOMEOWNER_DESC,
            t2.HH_COMP_DESC,
            t2.HOUSEHOLD_SIZE_DESC,
            t2.KID_CATEGORY_DESC
      FROM transaction_data as t1
      INNER JOIN hh_demographic as t2
      ON t1.household_key = t2.household_key")


avg_daily_check <- sqldf("
    SELECT 
      t1.household_key,
      sum(t1.daily_check) / count(t1.daily_check) as avg_day_daily_check
    FROM 
      (SELECT
            household_key,
            DAY,
            sum(SALES_VALUE) as daily_check
      FROM transaction_data
      GROUP BY household_key, DAY) as t1
    GROUP BY t1.household_key")

avg_daily_check_by_hh <- sqldf("
    SELECT 
      t1.household_key,
      sum(t1.avg_day_daily_check) / count(t1.avg_day_daily_check) as avg_hh_daily_check
    FROM avg_daily_check as t1
    GROUP BY t1.household_key")

df <- sqldf("
    SELECT 
      t2.*,
      t1.avg_hh_daily_check as target
    FROM avg_daily_check_by_hh as t1
    INNER JOIN hh_demographic as t2
    ON t1.household_key = t2.household_key")

barplot(table(df$AGE_DESC), main = "AGE_DESC")
barplot(table(df$MARITAL_STATUS_CODE), main = "MARITAL_STATUS_CODE")
barplot(table(df$INCOME_DESC), main = "INCOME_DESC")
barplot(table(df$HOMEOWNER_DESC), main = "HOMEOWNER_DESC")
barplot(table(df$HH_COMP_DESC), main = "HH_COMP_DESC")
barplot(table(df$KID_CATEGORY_DESC), main = "KID_CATEGORY_DESC")
barplot(table(df$HOUSEHOLD_SIZE_DESC), main = "HOUSEHOLD_SIZE_DESC")
boxplot(df$target, main = "average daily check by hh")

getmode <- function(v) {
  uniqv <- unique(v)
  uniqv[which.max(tabulate(match(v, uniqv)))]
}
cat("mean:", mean(df$target), "median:", median(df$target), "\nmoda:", toString(getmode(df$target)), "std:", sd(df$target), "\n")

# cat(unique(df$HOMEOWNER_DESC))

# corr_matrix <- cramerV(subset(df, select = -c(target)))
# View(corr_matrix)

# print(df)
# cat(sapply(df, class))
df$AGE_DESC <- as.factor(df$AGE_DESC)
df$MARITAL_STATUS_CODE <- as.factor(df$MARITAL_STATUS_CODE)
df$INCOME_DESC <- as.factor(df$INCOME_DESC)
# df$HOMEOWNER_DESC <- as.factor(df$HOMEOWNER_DESC)
df$HOMEOWNER_DESC <- as.factor(df$HOMEOWNER_DESC)
df$HH_COMP_DESC <- as.factor(df$HH_COMP_DESC)
df$KID_CATEGORY_DESC <- as.factor(df$KID_CATEGORY_DESC)
df <- one_hot(as.data.table(df), cols = "auto", dropCols = TRUE)
# print(df)
# cat(sapply(df, class))
# cat(unique(df$HOUSEHOLD_SIZE_DESC))
f <- function(x) {
  if (x == "5+") {
    return ("5")
  }
  return(x)
}
df$HOUSEHOLD_SIZE_DESC <- sapply(df$HOUSEHOLD_SIZE_DESC, f)
df$HOUSEHOLD_SIZE_DESC <- as.integer(df$HOUSEHOLD_SIZE_DESC)
cat("data types:", sapply(df, class))
rownames(df) <- df$household_key
df$household_key <- NULL
# print(df)

plot(density(df$target), main="kde target") 
hist(df$target, main="hist target") 
plot(df$HOUSEHOLD_SIZE_DESC, df$target, xlab="HOUSEHOLD_SIZE_DESC", ylab="target")
print(ggqqplot(df$target))

corr_matrix <- tetrachoric(subset(df, select = -c(target, HOUSEHOLD_SIZE_DESC)))
View(corr_matrix$rho)
# View(subset(df, select = -c(target, HOUSEHOLD_SIZE_DESC)))
# x <- rownames(corr_matrix)
# y <- colnames(corr_matrix)
# data <- expand.grid(X=x, Y=y)
# data$Z <- corr_matrix$rho
# 
# # Heatmap
# ggplot(df, aes(X, Y, fill= Z)) +
#   geom_tile()
# write.csv(corr_matrix$rho, "final_task/data.csv") 

# регресия на двух признаках:
model <- lm(target ~ HOUSEHOLD_SIZE_DESC, data=df)
plot(target ~ HOUSEHOLD_SIZE_DESC, data=df, pch = 16, col = "blue") #Plot the results
print(abline(model))
cat("shitty model mae:", Metrics::mae(df$target,predict(model, new_data=subset(df, select = c(HOUSEHOLD_SIZE_DESC)))), "\n")




sample <- sample.split(df$target, SplitRatio = 0.7)
train  <- subset(df, sample == TRUE)
train_label <- train$target
train_features <- subset(train, select = -c(target))
test   <- subset(df, sample == FALSE)
test_label <- test$target
test_features <- subset(test, select = -c(target))

RSQUARE = function(y_actual,y_predict){
  cor(y_actual,y_predict)^2
}

model <- lm(target ~ ., data=train)
print(summary(model))
cat("LineReg train mae result:", Metrics::mae(train_label,predict(model, newdata=train_features)), "\n")
cat("LineReg test mae result:", Metrics::mae(test_label,predict(model, newdata=test_features)), "\n")
cat("LineReg train RSQUARE result:", RSQUARE(train_label,predict(model, newdata=train_features)), "\n")
cat("LineReg test RSQUARE result:", RSQUARE(as.vector(test_label),as.vector(predict(model, newdata=test_features))))



tree_spec <- decision_tree() %>%
  set_engine("rpart") %>%
  set_mode("regression")

tree_fit <- tree_spec %>%
  fit(target ~ ., data=train)

print(summary(tree_fit))
# print(as.vector(predict(tree_fit, new_data=train_features)$.pred))
# print(as.vector(train_label))
# cat(predict(tree_fit, new_data=test_features))
cat("DT train mae result:", Metrics::mae(as.vector(train_label),as.vector(predict(tree_fit, new_data=train_features)$.pred)), "\n")
cat("DT test mae result:", Metrics::mae(as.vector(test_label),as.vector(predict(tree_fit, new_data=test_features)$.pred)), "\n")
cat("DT train RSQUARE result:", RSQUARE(as.vector(train_label),as.vector(predict(tree_fit, new_data=train_features)$.pred)), "\n")
cat("DT test RSQUARE result:", RSQUARE(as.vector(test_label),as.vector(predict(tree_fit, new_data=test_features)$.pred)), "\n")

cat("predict data for:\n")
print(test_features[5])
cat(predict(model, newdata=test_features[5]))