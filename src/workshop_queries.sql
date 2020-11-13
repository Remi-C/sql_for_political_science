--------------------------------------------------------------------------------
-- SQL WORKSHOP FOR POLITICAL SCIENCE -------------
-- Remi Cura, 2020/11/11





------------------------------------------------
--------------- QUERYING DATA ------------------

---- Overview ------
SELECt  legislator_last_name, legislator_birthday 
FROM consolidated___congress.legislators -- tell where the data is 
WHERE legislator_birthday > '1970-01-01'
ORDER BY legislator_birthday DESC
LIMIT 5 ; -- only 5 rows please


-------------------------
--- THE SELECT PART  ----
----- 001 Describe the result you want (columns)

-- 0010) just tell what you want ! 
SELECT 1 ; 

		--	?column?|
		--	--------|
		--	       1|


-- 0011) we can name the columns in the result
SELECT 1 AS my_first_column ;

		--	my_first_column|
		--	---------------|
		--	              1|
		

-- 0012) several columns, several types of data	
SELECT 1 AS an_int
	, 'some text' as a_text
	, true as a_boolean
	, 1.0 as a_number; 

		--	an_int|a_text   |a_boolean|a_number|
		--	------|---------|---------|--------|
		--	     1|some text|true     |     1.0|
		

-- 0013) we can run operators
SELECT
	1+1 AS an_int
	, 'some '||'text' as a_text
	, true AND true as a_boolean
	, 10^2 as a_number; 

	--	an_int|a_text   |a_boolean|a_number|
	--	------|---------|---------|--------|
	--	     2|some text|true     |   100.0|
	 

-- 0014) we can run functions
SELECT 
	power(2, 5) AS an_int
	, regexp_replace('some text', 'some', 'all') as a_text ; 

	--	an_int|a_text  |
	--	------|--------|
	--	  32.0|all text|


-- all good, but what about using real data?

-------------------------
--- BASIC FROM PART  ----
--- 002 describe where the data should come from

-- 0020) querying data from a table
SELECt legislator_first_name, legislator_last_name
	, legislator_birthday, legislator_gender 
		-- list the columns you are interested in
FROM consolidated___congress.legislators l -- tell where the data is 
LIMIT 5 ; -- only 5 rows please

	--	legislator_first_name|legislator_last_name|legislator_birthday|legislator_gender|
	--	---------------------|--------------------|-------------------|-----------------|
	--	Sherrod              |Brown               |         1952-11-09|M                |
	--	Maria                |Cantwell            |         1958-10-13|F                |
	--	Benjamin             |Cardin              |         1943-10-05|M                |
	--	Thomas               |Carper              |         1947-01-23|M                |
	--	Robert               |Casey               |         1960-04-13|M                |


-- 0021) using alias
SELECT legislator_last_name AS lname
    , legislator_birthday AS lbday
FROM consolidated___congress.legislators
WHERE legislator_birthday > '1970-01-01'
ORDER BY legislator_birthday DESC
LIMIT  5 ; 


-- 0022) processing rows info 
SELECT upper(legislator_last_name) AS upper_name
    , age(legislator_birthday) AS l_age
FROM consolidated___congress.legislators
WHERE legislator_birthday > '1970-01-01'
ORDER BY legislator_birthday DESC
LIMIT  5 ; 


-- 0023) more columns
SELECT legislator_id 
	, legislator_first_name, legislator_last_name
	, legislator_birthday, legislator_gender 
FROM consolidated___congress.legislators
WHERE legislator_birthday > '1970-01-01'
ORDER BY legislator_birthday DESC
LIMIT  5 ; 




-- 0031) changing filter
SELECT legislator_last_name, legislator_birthday
FROM consolidated___congress.legislators
WHERE legislator_gender = 'F'
ORDER BY legislator_birthday DESC
LIMIT  5 ; 

-- 0032) multiple filter
SELECt  legislator_first_name, legislator_last_name
FROM consolidated___congress.legislators
WHERE legislator_gender = 'F' 
	AND (
		legislator_full_name ILIKE '%cortez%' -- SQL regular expression
		OR
		 regexp_match(legislator_full_name , '.*smith.*', 'i')  -- standard reg. exp.
		 	IS NOT NULL
	)
ORDER BY legislator_birthday DESC
LIMIT  5 ; 



-- 0040) multiple ordering
SELECT legislator_last_name, legislator_first_name 
FROM consolidated___congress.legislators
WHERE legislator_gender = 'F'
ORDER BY legislator_last_name DESC, legislator_first_name ASC
LIMIT  5 ; 


-- 0050) What about people with same name
	-- who is J. Kennedy?
SELECT legislator_last_name, legislator_first_name , legislator_birthday 
FROM consolidated___congress.legislators
WHERE legislator_last_name = 'Kennedy'
	and legislator_first_name = 'John'
ORDER BY legislator_birthday ;


-- 0051) legislator id
SELECT legislator_id, legislator_last_name, legislator_first_name , legislator_birthday 
FROM consolidated___congress.legislators
WHERE legislator_last_name = 'Kennedy'
	and legislator_first_name = 'John'
ORDER BY legislator_birthday ;


-- 0100) Exploring the types of joins
SELECT s1, s2
FROM generate_series(1,3) as s1
	CROSS JOIN generate_series(2,3) as s2
ORDER BY s1, s2;

SELECT s1, s2
FROM generate_series(1,3) as s1
	INNER JOIN generate_series(2,3) as s2 ON (s1 = s2)
ORDER BY s1, s2;

SELECT s1, s2
FROM generate_series(1,3) as s1
	LEFT JOIN generate_series(2,3) as s2 ON (s1 = s2)
ORDER BY s1, s2;




-- 0101) legislators + terms
SELECT l.legislator_id, l.legislator_last_name 
	, lt.term_congress_chamber 
	, lt.term_start_date 
	, lt.term_date_interval 
FROM consolidated___congress.legislators as l 
	INNER JOIN consolidated___congress.legislators_terms lt 
		ON (l.legislator_id = lt.legislator_id)
WHERE legislator_last_name = 'Kennedy'
	and legislator_first_name = 'John'
ORDER BY legislator_id , term_start_date ;


-- 0102) Kennedys bills inner join 
SELECt l.legislator_id, l.legislator_last_name 
	, b.congress_number , b.bill_id 
FROM consolidated___congress.legislators AS l 
	INNER JOIN consolidated___congress.bills AS b 
		USING (legislator_id)
WHERE legislator_last_name = 'Kennedy'
	and legislator_first_name = 'John'
ORDER BY legislator_id
LIMIT 5 ;

-- 0102) Kennedys bills left join 
SELECt l.legislator_id, l.legislator_last_name 
	, b.congress_number , b.bill_id 
FROM consolidated___congress.legislators AS l 
	LEFT JOIN consolidated___congress.bills AS b 
		USING (legislator_id)
WHERE legislator_last_name = 'Kennedy'
	and legislator_first_name = 'John'
ORDER BY legislator_id
LIMIT 5 ;




-- 0103) bills cosponsored by legislator
SELECt l.legislator_id, l.legislator_last_name 
	, b.congress_number , b.bill_id 
FROM consolidated___congress.legislators AS l 
	INNER JOIN consolidated___congress.bill_cosponsors bc 
		USING (legislator_id)
	INNER JOIN consolidated___congress.bills AS b 
		USING (congress_number, bill_id)
WHERE legislator_last_name = 'Kennedy'
	and legislator_first_name = 'John'
ORDER BY legislator_id ;

-- 0104) Did J. Kennedy cosponsored a bill containing ‘education’ in its title during congress 115?
SELECt l.legislator_id, l.legislator_last_name 
	, b.congress_number , b.bill_id 
	, bt.bill_title 
FROM consolidated___congress.legislators AS l 
	INNER JOIN consolidated___congress.bill_cosponsors bc 
		USING (legislator_id)
	INNER JOIN consolidated___congress.bills AS b 
		USING (congress_number, bill_id)
	INNER JOIN consolidated___congress.bill_titles AS bt 
		USING (congress_number, bill_id)
WHERE legislator_last_name = 'Kennedy'
	and legislator_first_name = 'John'
	AND congress_number  = 115
	AND bt.bill_title ILIKE '%education%'
ORDER BY legislator_id ;


-- 0200) Group by basic:
SELECT legislator_last_name, legislator_gender 
FROM consolidated___congress.legislators
WHERE legislator_birthday > '1900-01-01'
ORDER BY legislator_birthday DESC
LIMIT  10 ; 


-- 0201) Group by basic: gorup by gender
SELECT legislator_gender
	, count(*) as c
FROM consolidated___congress.legislators
WHERE legislator_birthday > '1900-01-01'
GROUP BY legislator_gender 
ORDER BY legislator_gender DESC ;  

 
-- 0202) Group by basic: gorup by gender, avg birthday
SELECT legislator_gender
	, avg(date_part('year',legislator_birthday)) as average_year
FROM consolidated___congress.legislators
WHERE legislator_birthday > '1900-01-01'
GROUP BY legislator_gender 
ORDER BY legislator_gender DESC ; 

-- 0203) distinct ON : finding youngest of each gender
SELECT DISTINCT ON (legislator_gender ) 
    legislator_last_name, legislator_gender
	, legislator_birthday 
FROM consolidated___congress.legislators
WHERE legislator_birthday > '1900-01-01'
ORDER BY legislator_gender, legislator_birthday DESC ; 



-- 0301) for all bills, indicate if the sponsor is a female or not
-- look at all bills that were cosponsored, store the cosponsor gender
-- count, for each legislator, how much cosponsr of female vs male bills
SELECT l2.legislator_id as cosponsor_id , l2.legislator_gender AS cosponsor_gender
	, l.legislator_gender as bill_sponsor_gender
	, count(*) as c 
FROM consolidated___congress.bills b 
	INNER JOIN consolidated___congress.bill_cosponsors bc 
		USING (congress_number, bill_id)
	INNER JOIN consolidated___congress.legislators l 
		ON (b.legislator_id = l.legislator_id)
	INNER JOIN consolidated___congress.legislators l2 
		ON (bc.legislator_id = l2.legislator_id)
WHERE l2.legislator_birthday > '1900-01-01'
	AND b.congress_number = 115
GROUP BY l2.legislator_id,  l2.legislator_gender, l.legislator_gender
ORDER BY cosponsor_gender, cosponsor_id, bill_sponsor_gender; 


-- 0400)
-- how to create a table?
-- first create a schema:
CREATE SCHEMA IF NOT EXISTS s1 ;  
-- then create a table :
CREATE TABLE IF NOT EXISTS s1.raw___ppp(
	loanrange text,
	businessname text, 
	state text,
	zip text,
	naicscode text, 
	gender text,
	jobsreported text,
	dateapproved text,
	lender text 
) ; 

-- now we can insert some data.
-- we have to respect the order and type of columns

INSERT INTO s1.raw___ppp (loanrange, businessname, state, zip, naicscode 
		, gender  , jobsreported, dateapproved, lender)
	SELECT loanrange, businessname, state, zip, naicscode 
		, gender  , jobsreported, dateapproved, lender 
	FROM covid.raw___ppp_over_150  ;
	-- in this case, I directly read the data from a CSV file

-- check what we got
SELECt loanrange, businessname, jobsreported, dateapproved
FROM s1.raw___ppp 
LIMIT 10; 

SELECt count(*)
FROM s1.raw___ppp
GROUP BY true ; 

-- delete table if it already exists 
--DROP TABLE IF EXISTS s1.raw___ppp;  

-- do we have the same company receiving mnoey from the same bank?
SELECT  businessname, lender , count(*)  as c 
FROM s1.raw___ppp 
GROUP BY businessname, lender
ORDER BY c DESC;

-- do we have the same company receiving mnoey from the same bank on the same day?
SELECT  businessname, lender , dateapproved , count(*)  as c 
FROM s1.raw___ppp 
GROUP BY businessname, lender, dateapproved 
ORDER BY c DESC;

-- how to clean the types ?
SELECT loanrange, businessname
	, state, zip, naicscode
	, CASE WHEN gender ILIKE 'MALE%' THEN 'M'
		WHEN GENDER ILIKE 'FEMALE%' THEN 'F'
		ELSE NULL
		END AS gender
	, CAST(jobsreported AS INT) as jobsreported
	, CAST(dateapproved AS DATE) as dateapproved
	, lender 
FROM s1.raw___ppp ;

-- check possible values for the 'gender' column
SELECT gender, count(*) as c 
FROM s1.raw___ppp
GROUP BY gender 
ORDER BY c DESC; 

-- check possible values for the 'loanrange' column
SELECT loanrange, count(*) as c 
FROM s1.raw___ppp
GROUP BY loanrange 
ORDER BY c DESC; 

-- clean values for loanrange
SELECT  CASE WHEN loanrange ILIKE 'a%' THEN 5000000
		WHEN loanrange ILIKE 'b%' THEN 2000000
		WHEN loanrange ILIKE 'c%' THEN 1000000
		WHEN loanrange ILIKE 'd%' THEN 350000
		WHEN loanrange ILIKE 'e%' THEN 150000 
		END AS loanrange_cleaned 
FROM s1.raw___ppp ;






