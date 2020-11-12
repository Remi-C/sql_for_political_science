## R demo using direct access to postgres table 

​
library(DBI) # necessary to connect to db
library(RPostgreSQL) # postgres specific drivers
#password can only be used locally (after a ssh), so it is safe to share the password.
​
driver <- dbDriver("PostgreSQL")
​
##now we connect to the server  
con <- DBI::dbConnect(drv = driver, 
                      host = "xvii.mit.edu",
                      dbname = "sql_workshop",
                      port = "5434",
                      user = "postgres_ro_sql_workshop",
                      password = "FIXME"
)
library(dplyr) # data manipulation package
library(dbplyr) # compatibility with DBI
​
#we load a distant table into R. Note that no data is retrieved here.
#data will be retrieved only when needed.
#the table is not in the schema "public", but rather in the schema "covid"
df_distant <- tbl(con, in_schema("covid", "relational___ppp_over_150"))  
​​
#actually get the data from the db
df_distant %>% collect()
# now do something with the data

​
# If you want, you can also send raw queries with DBI
dbListTables(con)
res <- dbSendQuery(con, "SELECT loan_uid, loan_category, business_name
	, jobs_reported
	, date_approved 
FROM covid.relational___ppp_over_150 
LIMIT 10;")
dbFetch(res)
# do something with what you got

dbClearResult(res)

​# do not forget to close the connection when you are finished
dbDisconnect(con)