#install.packages("shiny")
#install.packages("shinydashboard")
#install.packages("readr")
#install.packages("ggplot2")
#install.packages("dplyr")
#install.packages("plotly")
#install.packages("sqldf")
# install. packages('xlsx') 
# library(shiny)
# library(shinydashboard)
library (xlsx) 
library(ggplot2)
library(readr)
library(dplyr)
library(plotly)
library(sqldf)
setwd("C:/Users/vniiz/Desktop/del_it/R_Lemanskiy_Konstantin")
path_to_save <- './data/final_task_data/'
vars <- c("print_additinal_data"=TRUE, "dinner"=1300, "autonext"=FALSE, "curr_day"=700, "save tables"=TRUE)
df <- read_csv("data/df.csv", col_types = "iciiididiiddicccccccccccccccc")
if (vars["print_additinal_data"]) {
  print("df:")
  print(df)
}


######task1########
if (vars["print_additinal_data"]) {
  print("df.TRANS_TIME in range")
  cat("df.TRANS_TIME in range (", min(df$TRANS_TIME), ", ", max(df$TRANS_TIME), ")", end="\n")
}
df <- sqldf(paste('select 
              *,
              CASE
                  WHEN t1.TRANS_TIME < ', vars["dinner"], ' THEN "До обеда"
                  ELSE "после обеда"
              END as time_of_day
              FROM df as t1'))
count_transaction_by_time_of_day <- sqldf(' select 
              time_of_day,
              count(*) as frequency
              FROM df as t1
              GROUP BY time_of_day')
dansity_of_transaction_time <- density(df$TRANS_TIME)
par(fig=c(0,1,0,0.5))
barplot(count_transaction_by_time_of_day$frequency, names.arg= count_transaction_by_time_of_day$time_of_day, main="Purchase depends on time of day")
par(fig=c(0,1,0.5,1), new=TRUE)
plot(dansity_of_transaction_time, xaxt='n', xlab="time of day", main="Purchase density depends on time")
axis(1, at=c(0,500, 1000, 1500, 2000, 2500), labels=c("0:00","5:00", "10:00", "15:00", "20:00", "25:00"))
# mtext("time of day", side=1)
if (!vars["autonext"]) {
readline("type enter to continue")
}





######task2########
count_transaction_by_product_id <- sqldf(' select 
              PRODUCT_ID,
              count(*) as transactions_count
              FROM df as t1
              GROUP BY PRODUCT_ID')
count_sold_by_product_id <- sqldf(' select 
              PRODUCT_ID,
              sum(QUANTITY) as sales
              FROM df as t1
              GROUP BY PRODUCT_ID')
price_amount_by_product_id <- sqldf(' select 
              PRODUCT_ID,
              sum(SALES_VALUE) as sales_price_amount
              FROM df as t1
              GROUP BY PRODUCT_ID')
if (vars["print_additinal_data"]) {
  print("df.PRODUCT_ID top 30 by transaction count")
  print(sqldf(' select 
              PRODUCT_ID,
              transactions_count
              FROM count_transaction_by_product_id as t1
              ORDER BY transactions_count DESC
              LIMIT 30'))
  print("df.PRODUCT_ID top 30 by sold count")
  print(sqldf(' select 
              PRODUCT_ID,
              sales
              FROM count_sold_by_product_id as t1
              ORDER BY sales DESC
              LIMIT 30'))
  print("df.PRODUCT_ID top 30 by price")
  print(sqldf(' select 
              PRODUCT_ID,
              sales_price_amount
              FROM price_amount_by_product_id as t1
              ORDER BY sales_price_amount DESC
              LIMIT 30'))
}
top10_product_id_by_count_sold <- sqldf(' SELECT 
              PRODUCT_ID,
              sales
              FROM count_sold_by_product_id as t1
              ORDER BY sales DESC
              LIMIT 10')
top10_product_id_by_price_amount <- sqldf(' select 
              PRODUCT_ID,
              sales_price_amount
              FROM price_amount_by_product_id as t1
              ORDER BY sales_price_amount DESC
              LIMIT 10')
par(fig=c(0,1,0,0.5))
barplot(top10_product_id_by_count_sold$sales, names.arg= top10_product_id_by_count_sold$PRODUCT_ID, main="top 10 product id by sold couunt")
par(fig=c(0,1,0.5,1), new=TRUE)
barplot(top10_product_id_by_price_amount$sales, names.arg= top10_product_id_by_price_amount$PRODUCT_ID, main="top 10 product id by amount income")
if (!vars["autonext"]) {
  readline("type enter to continue")
}





income_by_shops <- sqldf('select 
              STORE_ID,
              sum(SALES_VALUE) as income
              FROM df as t1
              GROUP BY STORE_ID')
if (vars["print_additinal_data"]) {
  print("top 30 shops by income")
  print(sqldf(' select 
              STORE_ID,
              income
              FROM income_by_shops as t1
              ORDER BY income DESC
              LIMIT 30'))
}
top10_shops_by_income <- sqldf(' select 
              STORE_ID,
              income
              FROM income_by_shops as t1
              ORDER BY income DESC
              LIMIT 10')
df_only_top_10_shops <- sqldf(' select 
              t1.*,
              t2.income
              FROM df as t1
              INNER JOIN top10_shops_by_income as t2 
              ON t1.STORE_ID = t2.STORE_ID')
df_top_10_shops_income_by_products <- sqldf(' SELECT 
                                STORE_ID,
                                PRODUCT_ID,
                                sum(SALES_VALUE) as product_income_in_shop,
                                min(t1.income) as shop_income
                              FROM df_only_top_10_shops as t1
                              GROUP BY STORE_ID, PRODUCT_ID')
df_top_10_shops_income_by_products <- sqldf(' SELECT
                                STORE_ID,
                                PRODUCT_ID,
                                sum(SALES_VALUE) as product_income_in_shop,
                                min(t1.income) as shop_income
                              FROM df_only_top_10_shops as t1
                              GROUP BY STORE_ID, PRODUCT_ID')
relative_percentage_top_10_product_income_in_shop <- sqldf(' SELECT
                                STORE_ID,
                                100 * sum(product_income_in_shop) / min(shop_income) as relative_percentage
                              FROM df_top_10_shops_income_by_products as t1
                              WHERE PRODUCT_ID in (select PRODUCT_ID FROM top10_product_id_by_price_amount)
                              GROUP BY STORE_ID')
absolute_top_10_product_income_in_shop <- sqldf(' SELECT
                                STORE_ID,
                                sum(product_income_in_shop) as absolute_sum_income
                              FROM df_top_10_shops_income_by_products as t1
                              WHERE PRODUCT_ID in (select PRODUCT_ID FROM top10_product_id_by_price_amount)
                              GROUP BY STORE_ID')
par(fig=c(0,1,0,0.5))
barplot(relative_percentage_top_10_product_income_in_shop$relative_percentage, names.arg= relative_percentage_top_10_product_income_in_shop$STORE_ID, main="% income from top 10 product in top 10 stores")
par(fig=c(0,1,0.5,1), new=TRUE)
barplot(absolute_top_10_product_income_in_shop$absolute_sum_income, names.arg= absolute_top_10_product_income_in_shop$STORE_ID, main="sum income from top 10 product in top 10 stores")
table_of_income_top10_product_in_top10_shops <- sqldf('                  SELECT
                                t1.STORE_ID,
                                t1.PRODUCT_ID,
                                t1.product_income_in_shop,
                                t1.shop_income,
                                100 * t1.product_income_in_shop / t1.shop_income as percentage_income_from_product_in_shop,
                                100 * t1.product_income_in_shop / t2.sales_price_amount as percentage_income_from_product_in_shop_from_all_income_from_prodict
                              FROM df_top_10_shops_income_by_products as t1
                              INNER JOIN top10_product_id_by_price_amount as t2
                              WHERE t1.PRODUCT_ID = t2.PRODUCT_ID 
                              ORDER BY percentage_income_from_product_in_shop_from_all_income_from_prodict')

View(table_of_income_top10_product_in_top10_shops)
if (!vars["autonext"]) {
 readline("type enter to continue")
}

######task3########
campaign_desc <- read_csv("data/campaign_desc.csv", col_types = "ciii")
count_active_company <- sqldf(paste('select 
              count(DISTINCT t1.CAMPAIGN)
              FROM campaign_desc as t1
              WHERE END_DAY > ', vars["curr_day"], ' AND START_DAY < ', vars["curr_day"]))

cat("текущее количество запущенных маркетинговых кампаний:", as.character(count_active_company[1, 1]), end="\n")
client_count <- sqldf('select 
              count(DISTINCT t1.household_key)
              FROM df as t1')

cat("количество клиентов, которые покупают товары в наших магазинах:", client_count[1, 1], end="\n")
avg_amount_income_from_hh <- sqldf('SELECT AVG(t2.income) FROM (select 
              t1.household_key,
              sum(t1.SALES_VALUE) as income
              FROM df as t1
              GROUP BY household_key) as t2')

cat("среднюю сумму покупок на одно домохозяйство(household_key):", avg_amount_income_from_hh[1, 1], end="\n")
total_count_sold_product <- sqldf("SELECT 
              sum(QUANTITY)
              FROM df as t1")
cat("общее количество проданных товаров:", total_count_sold_product[1, 1], end="\n")




######task4######
if (vars["save tables"]) {
    print("whrite data to file")
    write.csv(count_transaction_by_time_of_day, paste(path_to_save, "count_transaction_by_time_of_day.csv"))
    print("count_transaction_by_time_of_day done")
    # write.csv(dansity_of_transaction_time, paste(path_to_save, ""), sheetName="dansity_of_transaction_time", append=FALSE)
    write.csv(count_sold_by_product_id, paste(path_to_save, "count_sold_by_product_id.csv"))
    print("count_sold_by_product_id done")
    write.csv(price_amount_by_product_id, paste(path_to_save, "price_amount_by_product_id.csv"))
    print("price_amount_by_product_id done")
    write.csv(relative_percentage_top_10_product_income_in_shop, paste(path_to_save, "relative_percentage_top_10_product_income_in_shop.csv"))
    print("relative_percentage_top_10_product_income_in_shop done")
    write.csv(absolute_top_10_product_income_in_shop, paste(path_to_save, "absolute_top_10_product_income_in_shop.csv"))
    print("absolute_top_10_product_income_in_shop done")
    write.csv(table_of_income_top10_product_in_top10_shops, paste(path_to_save, "table_of_income_top10_product_in_top10_shops.csv"))
    print("table_of_income_top10_product_in_top10_shops done")
    write.csv(count_active_company, paste(path_to_save, "count_active_company.csv"))
    print("count_active_company done")
    write.csv(client_count, paste(path_to_save, "client_count.csv"))
    print("client_count done")
    write.csv(avg_amount_income_from_hh, paste(path_to_save, "avg_amount_income_from_hh.csv"))
    print("avg_amount_income_from_hh done")
    write.csv(total_count_sold_product, paste(path_to_save, "total_count_sold_product.csv"))
    print("total_count_sold_product done")
    cat("save data to", path_to_save)
}
# find_time_of_day <-  function(x) {
#   if (x < vars["dinner"]) {
#     return("до обеда")
#   }
#   else{
#     return("после обеда")
#   }
# }
# transaction_data$time_of_day <- lapply(transaction_data$TRANS_TIME, find_time_of_day)
# count_transaction_by_time_of_day <- transaction_data %>% group_by(time_of_day) %>% summarise(count = n())
# count_transaction_by_product_id <- transaction_data %>% group_by(PRODUCT_ID) %>% summarise(count = n())


