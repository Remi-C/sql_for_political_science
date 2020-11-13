## R demo using direct access to postgres table 

library(DBI) # necessary to connect to db
library(RPostgreSQL) # postgres specific drivers 

driver <- dbDriver("PostgreSQL")

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


### First option ###
# the simplest option to retrieve data would be : 

res2 <- dbGetQuery(con, "SELECT loan_uid, loan_category, business_name
	, jobs_reported
	, date_approved 
FROM covid.relational___ppp_over_150 
LIMIT 10;")
# cool, the result is a nice dataframe ! 


### Second option ###
# If you are doing serious stuff and perf matters, 
# here is a nicer way to get the data and do something with it
 
#we load a distant table into R. Note that no data is retrieved here.
#data will be retrieved only when needed. 
df_distant <- tbl(con, in_schema("covid", "relational___ppp_over_150"))  

# Show the data
df_distant

# run a remote query on the data
df_distant %>%
  group_by(loan_range) %>%
  count() %>%
  arrange(desc(n))

#actually get the data from the db
df_local <- df_distant %>% collect()

# now do something with the data
local_agregate<- df_local %>%
  filter(owner_gender!="NA", race_ethnicity != "NA")%>%
  group_by(owner_gender, race_ethnicity) %>%
  count() %>%
  ungroup()%>%
  arrange(desc(n))%>%
  pivot_wider(id_cols = owner_gender, names_from = race_ethnicity, values_from = n)
local_agregate

 
######
# do not forget to close the connection when you are finished
dbDisconnect(con)