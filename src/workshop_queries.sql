--------------------------------------------------------------------------------
-- SQL WORKSHOP FOR POLITICAL SCIENCE -------------
-- Remi Cura, 2020/11/11





------------------------------------------------
--------------- QUERYING DATA ------------------

-------------------------
--- THE SELECT PART  ----

-- just tell what you want ! 
SELECT 1 ; 

		--	?column?|
		--	--------|
		--	       1|


-- we can name the columns in the result
SELECT 1 AS my_first_column ;

		--	my_first_column|
		--	---------------|
		--	              1|
		

-- several columns, several types of data	
SELECT 1 AS an_int
	, 'some text' as a_text
	, true as a_boolean
	, 1.0 as a_number; 

		--	an_int|a_text   |a_boolean|a_number|
		--	------|---------|---------|--------|
		--	     1|some text|true     |     1.0|
		

-- we can run operators
SELECT
	1+1 AS an_int
	, 'some '||'text' as a_text
	, true AND true as a_boolean
	, 10^2 as a_number; 

	--	an_int|a_text   |a_boolean|a_number|
	--	------|---------|---------|--------|
	--	     2|some text|true     |   100.0|
	 

-- we can run functions
SELECT 
	power(2, 5) AS an_int
	, regexp_replace('some text', 'some', 'all') as a_text ; 

	--	an_int|a_text  |
	--	------|--------|
	--	  32.0|all text|


-- all good, but what about using real data?

-------------------------
--- BASIC FROM PART  ----

-- querying data from a table
SELECt legislator_first_name, legislator_last_name
	, legislator_birthday, legislator_gender 
		-- list the columns you are interested in
FROM consolidated___congress.legislators l -- tell where the data is 
LIMIT 5 ; -- only 10 rows please

	--	legislator_first_name|legislator_last_name|legislator_birthday|legislator_gender|
	--	---------------------|--------------------|-------------------|-----------------|
	--	Sherrod              |Brown               |         1952-11-09|M                |
	--	Maria                |Cantwell            |         1958-10-13|F                |
	--	Benjamin             |Cardin              |         1943-10-05|M                |
	--	Thomas               |Carper              |         1947-01-23|M                |
	--	Robert               |Casey               |         1960-04-13|M                |



--  