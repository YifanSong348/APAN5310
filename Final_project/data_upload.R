#transform csv to df
category_df=read.csv('category.csv',stringsAsFactors = T)
coupon_df=read.csv('coupon.csv',stringsAsFactors = T)
customer_df=read.csv('customer.csv',stringsAsFactors = T)
employee_df=read.csv('employee.csv',stringsAsFactors = T)
expense_df=read.csv('expense.csv',stringsAsFactors = T)
inventory_df=read.csv('inventory.csv',stringsAsFactors = T)
loyalty_program_df=read.csv('loyalty_program.csv',stringsAsFactors = T)
loyalty_reward_df=read.csv('loyalty_reward.csv',stringsAsFactors = T)
product_df=read.csv('product.csv',stringsAsFactors = T)
refund_df=read.csv('refund.csv',stringsAsFactors = T)
salary_df=read.csv('salary.csv',stringsAsFactors = T)
sale_df=read.csv('sale.csv',stringsAsFactors = T)
store_df=read.csv('store.csv',stringsAsFactors = T)
supplier_df=read.csv('supplier.csv',stringsAsFactors = T)
transaction_df=read.csv('transaction.csv',stringsAsFactors = T)

drv <- dbDriver('PostgreSQL')
require('RPostgreSQL')
library("DBI")
library("remotes")
library("RPostgres")
library("dplyr")
library("tidyverse")

con <- DBI::dbConnect(
  RPostgres::Postgres(),
  dbname = 'Group14',
  host = 'localhost',
  port = 5432,
  user = 'postgres',
  password = '123'
)

dbListTables(con) 
#Add data to sales database. repeat for all tables.
dbWriteTable(con, name="category", value=category_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="employee", value=employee_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="expense", value=expense_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="coupon", value=coupon_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="customer", value=customer_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="store", value=store_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="loyalty_program", value=loyalty_program_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="supplier", value=supplier_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="product", value=product_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="inventory", value=inventory_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="refund", value=refund_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="salary", value=salary_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="sale", value=sale_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="loyalty_reward", value=loyalty_reward_df, row.names=FALSE, append=TRUE)
dbWriteTable(con, name="transaction", value=transaction_df, row.names=FALSE, append=TRUE)





