# R_Lemanskiy_Konstantin
Homework for University R Lessions

final HW data:

**campaign_desc** - Описание кампаний с указанием дат начала и окончания
* DESCRIPTION - TypeA, TypeB, TypeC
* CAMPAIGN - id компании
* START_DAY - начало
* END_DAY - окончание

**campaign_table** - 	Таблица соответствий кампаний и домашних хозяйств
* DESCRIPTION - TypeA, TypeB, TypeC
* household_key - id домохозяйства
* CAMPAIGN - id компании

**causal_data** - Таблица соответствий продуктов и почтовых отправителей с предложением скидки
* PRODUCT_ID - id товара
* STORE_ID - id магазина
* WEEK_NO - номер недели (я так понял среди вот этих двух лет ао которым выгрузка)
* display - какое то чило. может кол-во раз сколько показали скидку? хз.
* mailer - видимо код почтового отправителя в виде 0 или заглавной буквы

**coupon** - 	Таблица соответствий скидочных купонов и маркетинговых кампаний с продуктами
* COUPON_UPC - возможно номер купона
* PRODUCT_ID - id товара
* CAMPAIGN - id компании


**coupon_redempt** - 	Таблица истории использования тех или иных купонов в определённом домашнем хозяйстве
* household_key - id домохозяйства
* DAY - номер дня (я так понял среди вот этих двух лет ао которым выгрузка)
* COUPON_UPC - возможно номер купона
* CAMPAIGN - id компании


**hh_demographic** - Социально-экономический статус домохозяйств
* AGE_DESC - возраст домохозяйства или владельца
* MARITAL_STATUS_CODE - супружеский статусный код (типа женат не женат развыеден)
* INCOME_DESC - доход
* HOMEOWNER_DESC - владеет ли домом
* HH_COMP_DESC - наличие детей и кол-во взрослых
* HOUSEHOLD_SIZE_DESC - кол-во комнат?
* KID_CATEGORY_DESC - сколько детям лет
* household_key - id домохозяйства

**product** - Справочник по продуктам
* PRODUCT_ID - id товара
* MANUFACTURER - id производитель/фабрика
* DEPARTMENT - отделение
* BRAND - бренд
* COMMODITY_DESC - National/Private
* SUB_COMMODITY_DESC - описние товара
* CURR_SIZE_OF_PRODUCT - размер товара

**transaction_data** - Основная таблица с фактом продаж
* household_key - id домохозяйства
* BASKET_ID - id карзины
* DAY - номер дня (я так понял среди вот этих двух лет по которым выгрузка)
* PRODUCT_ID - id товара
* QUANTITY - количество
* SALES_VALUE - обьем продаж? значение продаж?
* STORE_ID - id магазина
* RETAIL_DISC - ???????
* TRANS_TIME - время транзакции (0000 - 2399)
* WEEK_NO - номер недели (я так понял среди вот этих двух лет ао которым выгрузка)
* COUPON_DISC - что то про купон
* COUPON_MATCH_DISC - что то про купон х2
