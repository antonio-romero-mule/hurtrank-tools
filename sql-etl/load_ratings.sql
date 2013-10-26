
\! wget -O /tmp/ratingsdata.csv http://www.mulesoft.org/star-rate-report/
#truncate table raw_ratings; -- for now ; incremental load would require no truncate
load data local infile '/tmp/ratingsdata.csv'
  IGNORE -- for now; incremental load would require IGNORE
  into table raw_ratings
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
ignore 1 LINES
(comment_ID,email,username,@cdate,comment_value, suggestion_value,rate,@FullURL,state,country,IP,host)
set comment_date=str_to_date(@cdate,'%Y-%m-%d'),
 url=replace(@FullURL,'http://www.mulesoft.org','')
; 

