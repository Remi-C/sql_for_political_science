"""
Demo file to connect to a postgres DB and run first a trivial query then actually get some data
requires to instal pscyopg2, pip
`pip install psycopg2, pandas`
"""

import psycopg2
import pandas as pd

PG_PORT = 5434
HOST = "xvii.mit.edu"
DB_NAME = "sql_workshop"
PG_USER_NAME = "postgres_ro_sql_workshop"
PG_USER_PASSWORD = """FIXME"""

# In[11]:

con = psycopg2.connect(dbname=DB_NAME, host=HOST, port=PG_PORT, user=PG_USER_NAME,
                       password=PG_USER_PASSWORD)
# we define a connection to the DB server
cur = con.cursor()
# we create a handle to be able to retrieve data

# we define what we want to get
query = """ 
SELECT loan_uid, loan_category, business_name
	, jobs_reported
	, date_approved 
FROM covid.relational___ppp_over_150 
LIMIT 10; 
        """

cur.execute(query)  # we send the query to the server
rows = cur.fetchall()  # we get the data locally

# now, do something with rows!
print('Here is what we got from the server')
print(rows)

# In[43]:
# there is another way with pandas, which is cleaner and more generic
df = pd.read_sql_query(query, con)
print('Here is what we got as a panda dataframe')
print(df)

# In[44]:
# Don't forget to close the connection when you don't need it anymore
con.close()
