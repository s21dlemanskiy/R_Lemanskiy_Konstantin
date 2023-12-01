library(shiny)
library(shinydashboard)
library(ggplot2)
library(readr)
library(dplyr)
library(plotly)
library(sqldf)
setwd("C:/Users/vniiz/Desktop/del_it/R_Lemanskiy_Konstantin")
print_additinal_data=FALSE
campaign_desc <- read_csv("data/campaign_desc.csv", col_types = "ciii")
campaign_table <- read_csv("data/campaign_table.csv", col_types = "cii")
causal_data <- read_csv("data/causal_data.csv", col_types = "iiicc")
coupon <- read_csv("data/coupon.csv", col_types = "cii")
coupon_redempt <- read_csv("data/coupon_redempt.csv", col_types = "iici")
hh_demographic <- read_csv("data/hh_demographic.csv", col_types = "ccccccc")
product <- read_csv("data/product.csv", col_types = "iiccccc")
transaction_data <- read_csv("data/transaction_data.csv", col_types = "iciiididiidd")
if (print_additinal_data) {
  print("campaign_desc")
  print(head(campaign_desc))
  print("campaign_table")
  print(head(campaign_table))
  print("causal_data")
  print(head(causal_data))
  print("coupon")
  print(head(coupon))
  print("coupon_redempt")
  print(head(coupon_redempt))
  print("hh_demographic")
  print(head(hh_demographic))
  print("product")
  print(head(product))
  print("transaction_data")
  print(head(transaction_data))
}
df <- sqldf("select
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
            t2.MANUFACTURER,
            t2.DEPARTMENT,
            t2.BRAND,
            t2.COMMODITY_DESC,
            t2.SUB_COMMODITY_DESC,
            t2.CURR_SIZE_OF_PRODUCT,
            t3.AGE_DESC,
            t3.MARITAL_STATUS_CODE,
            t3.INCOME_DESC,
            t3.HOMEOWNER_DESC,
            t3.HH_COMP_DESC,
            t3.HOUSEHOLD_SIZE_DESC,
            t3.KID_CATEGORY_DESC
            from transaction_data as t1
      INNER JOIN product as t2
      ON t1.PRODUCT_ID = t2.PRODUCT_ID
      INNER JOIN hh_demographic as t3
      ON t1.household_key = t3.household_key")
head(df)
write.csv(df, "data/df.csv", row.names=FALSE)