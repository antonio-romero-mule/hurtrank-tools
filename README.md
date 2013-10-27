hurtrank-tools
==============

All the different pieces of the Hurtrank dashboard system  (and, alas, there are many). 


Linux ETL process
*github: sql-etl directory
* Java command line tool ga2csv (from here) extracts Google Analytics traffic -- views per page per day -- ~250K rows of data as of October 2013, adding ~1K rows per day. 
* wget used to fetch CSV with hurtrank data
* Full data set is pulled every day
* Shell script calls MySQL scripts that use stored procedures to cleanse, normalize and load data

MySQL processing
* github: sql-etl and sql-dbdump directories
* sql-dbdump contains stored procedures and db schema create script
* MySQL scripts load these raw files into Hurtrank MySQL database schema
* Subsequent MySQL Stored Procedures and Views generate aggregations of traffic for a time period and compute the Hurtrank.
* Linux ETL process  kicks off stored procedures to do cleansing, normalizing and aggregation, process can take 10-15 minutes
* Runs once per day

Google Apps Script and Spreadsheet
* github: google-script directory
* Each makes JDBC connection to MySQL DB, runs desired queries, and posts results to a Google Spreadsheet named range. These run every two hours.
* Google Spreadsheet here:	 https://docs.google.com/a/mulesoft.com/spreadsheet/ccc?key=0AqXwDUi2oP6hdG02c1N0S2Q2YmVjODV5ejN0OW5OUkE&usp=drive_web#gid=0
* Tabs capture MySQL query results in named ranges
* Google Sites graphing widgets pull data from here
* Once per 2 hours events pull the query results again 

Google Sites and graphing widgets
* Site is hosted here: https://sites.google.com/a/mulesoft.com/doc-metrics/
* Hurtrank dashboard shows various hurtranks by date or date range, and recent ratings. 

Known issues:
* Analysis currently provides no means of tracking hurtrank improvements when fixes are implemented in doc. Would be simple to add, frankly-- column exists in the MySQL table for the comments; just set it to a date, and update the queries to exclude rankings with a “fixed” date specified. Cheaper alternative: just limit queries to last N days, so old feedback ages out. Stored procedure is available to compute hurtrank for any date range of traffic and of comments. (i.e. “hurtrank based on feedback between date1 and date2, and traffic between date3 and date4.”)
* Generallly limited volume of ratings data.
* Would be interesting to see ratings weighted by e.g. users who have visited the doc site more than 10 times, rather than all visits. I tried some preliminary looks at this and the traffic patterns for frequent visitors are rather different. Not hard to do this query in GA, but I think very useful because it factors out the first-time visitors’ experience to focus on the day to day long term user.. 

