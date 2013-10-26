truncate table raw_traffic;

load data local infile '/opt/ga2csv/output/all-doc-traffic.csv' 
replace
into table raw_traffic
fields terminated by ','
optionally enclosed by '"'
ignore 1 lines
(@pathval,@dateval, views)
  SET date=STR_TO_DATE(@dateval,'%Y%m%d'),
  path=IF (@pathval REGEXP 'search.results' OR @pathval REGEXP '32X' OR LENGTH(@pathval)>128, '#DISCARD', normalized_path(@pathval))
; 

-- clean up bad rows
DELETE FROM raw_traffic WHERE path='#DISCARD' ;
DELETE FROM raw_traffic WHERE YEAR(date)<2012 OR ISNULL(date);
-- I'm sure more special case bad rows will come up

-- may be unnecessary, but can't hurt
OPTIMIZE TABLE raw_traffic;
ANALYZE TABLE raw_traffic;

call load_normalized_traffic();
