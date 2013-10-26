-- 
-- Structure for table `daily_hurtrank`
-- 

DROP TABLE IF EXISTS `daily_hurtrank`;
CREATE TABLE IF NOT EXISTS `daily_hurtrank` (
  `d` date NOT NULL,
  `hurtrank` float DEFAULT NULL,
  `total_views` int(11) DEFAULT NULL,
  `total_ratings` int(11) DEFAULT NULL,
  `today_views` int(11) DEFAULT NULL,
  `today_ratings` int(11) DEFAULT NULL,
  PRIMARY KEY (`d`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 
-- Structure for table `dim_date`
-- 

DROP TABLE IF EXISTS `dim_date`;
CREATE TABLE IF NOT EXISTS `dim_date` (
  `date_key` int(11) NOT NULL,
  `date_value` date DEFAULT NULL,
  `date_iso` char(10) DEFAULT NULL,
  `year` smallint(6) DEFAULT NULL,
  `quarter` tinyint(4) DEFAULT NULL,
  `quarter_name` char(2) DEFAULT NULL,
  `month` tinyint(4) DEFAULT NULL,
  `month_name` varchar(10) DEFAULT NULL,
  `month_abbreviation` varchar(10) DEFAULT NULL,
  `week` char(2) DEFAULT NULL,
  `day_of_month` tinyint(4) DEFAULT NULL,
  `day_of_year` smallint(6) DEFAULT NULL,
  `day_of_week` smallint(6) DEFAULT NULL,
  `day_name` varchar(10) DEFAULT NULL,
  `day_abbreviation` varchar(10) DEFAULT NULL,
  `is_weekend` tinyint(4) DEFAULT NULL,
  `is_weekday` tinyint(4) DEFAULT NULL,
  `is_today` tinyint(4) DEFAULT NULL,
  `is_yesterday` tinyint(4) DEFAULT NULL,
  `is_this_week` tinyint(4) DEFAULT NULL,
  `is_last_week` tinyint(4) DEFAULT NULL,
  `is_this_month` tinyint(4) DEFAULT NULL,
  `is_last_month` tinyint(4) DEFAULT NULL,
  `is_this_year` tinyint(4) DEFAULT NULL,
  `is_last_year` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`date_key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=103;

-- 
-- Structure for table `normalized_traffic`
-- 

DROP TABLE IF EXISTS `normalized_traffic`;
CREATE TABLE IF NOT EXISTS `normalized_traffic` (
  `path` varchar(127) NOT NULL,
  `date` date NOT NULL,
  `views` int(11) NOT NULL,
  UNIQUE KEY `UK_normalized_traffic` (`date`,`path`),
  KEY `IDX_normalized_traffic_date` (`date`),
  KEY `IDX_normalized_traffic_path` (`path`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 AVG_ROW_LENGTH=391 ROW_FORMAT=FIXED COMMENT='traffic by day, paths normalized and aggregated etc..';

-- 
-- Structure for table `raw_ratings`
-- 

DROP TABLE IF EXISTS `raw_ratings`;
CREATE TABLE IF NOT EXISTS `raw_ratings` (
  `COMMENT_ID` int(11) NOT NULL DEFAULT '0' COMMENT 'primary key but assigned by comment collection script',
  `IGNORE` varchar(2) DEFAULT NULL,
  `RATE` int(1) DEFAULT NULL,
  `COMMENT_DATE` date DEFAULT NULL,
  `EMAIL` varchar(255) DEFAULT NULL,
  `COMMENT_VALUE` varchar(2048) DEFAULT NULL,
  `SUGGESTION_VALUE` varchar(2048) DEFAULT NULL,
  `USERNAME` varchar(32) DEFAULT NULL,
  `URL` varchar(255) DEFAULT NULL,
  `STATE` varchar(45) DEFAULT NULL,
  `COUNTRY` varchar(45) DEFAULT NULL,
  `IP` varchar(20) DEFAULT NULL,
  `HOST` varchar(255) DEFAULT NULL,
  `RESOLUTION` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`COMMENT_ID`),
  KEY `URL_IX` (`URL`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- 
-- Structure for table `raw_traffic`
-- 

DROP TABLE IF EXISTS `raw_traffic`;
CREATE TABLE IF NOT EXISTS `raw_traffic` (
  `path` varchar(127) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `views` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COMMENT='Traffic per page per day, extracted from GA, imported by script. Needs normalizing etc..';

-- 
-- Structure for table `recent_views`
-- 

DROP TABLE IF EXISTS `recent_views`;
CREATE TABLE IF NOT EXISTS `recent_views` (
  `path` varchar(127) NOT NULL,
  `views` int(11) NOT NULL,
  PRIMARY KEY (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- 
-- View `earliest_ratings_by_page`
-- 

DROP VIEW IF EXISTS `earliest_ratings_by_page`;
CREATE ALGORITHM=UNDEFINED DEFINER=`hurtuser`@`%` SQL SECURITY DEFINER VIEW `earliest_ratings_by_page` AS select `r`.`URL` AS `path`,min(`r`.`COMMENT_DATE`) AS `first_rate_date` from `ratings` `r` group by `r`.`URL`;

-- 
-- View `formatted_ratings`
-- 

DROP VIEW IF EXISTS `formatted_ratings`;
CREATE ALGORITHM=UNDEFINED DEFINER=`hurtuser`@`%` SQL SECURITY DEFINER VIEW `formatted_ratings` AS select `ratings`.`COMMENT_ID` AS `comment_ID`,`ratings`.`COMMENT_DATE` AS `comment_date`,`ratings`.`RATE` AS `rate`,replace(`ratings`.`URL`,'+',' ') AS `URL`,if((length(concat(trim(`ratings`.`USERNAME`),trim(`ratings`.`EMAIL`))) > 0),concat(`ratings`.`USERNAME`,' (',`ratings`.`EMAIL`,')'),'') AS `contact`,concat(`ratings`.`COMMENT_VALUE`,'   ',`ratings`.`SUGGESTION_VALUE`) AS `comment_value` from `ratings` order by `ratings`.`COMMENT_ID` desc;

-- 
-- View `rating_trends`
-- 

DROP VIEW IF EXISTS `rating_trends`;
CREATE ALGORITHM=UNDEFINED DEFINER=`hurtuser`@`%` SQL SECURITY DEFINER VIEW `rating_trends` AS select concat(date_format(makedate(year(`r`.`COMMENT_DATE`),(week(`r`.`COMMENT_DATE`,0) * 7)),'%b %e')) AS `year_and_week`,sum((`r`.`RATE` = 1)) AS `rated1`,sum((`r`.`RATE` = 2)) AS `rated2`,sum((`r`.`RATE` = 3)) AS `rated3`,sum((`r`.`RATE` = 4)) AS `rated4`,sum((`r`.`RATE` = 5)) AS `rated5`,count(0) AS `TOTAL_RATECOUNT` from `ratings` `r` where ((`r`.`COMMENT_DATE` + interval 26 week) > now()) group by yearweek(`r`.`COMMENT_DATE`,0) order by yearweek(`r`.`COMMENT_DATE`,0),`r`.`RATE`;

-- 
-- View `ratings`
-- 

DROP VIEW IF EXISTS `ratings`;
CREATE ALGORITHM=UNDEFINED DEFINER=`hurtuser`@`%` SQL SECURITY DEFINER VIEW `ratings` AS select `raw_ratings`.`COMMENT_ID` AS `COMMENT_ID`,`raw_ratings`.`RATE` AS `RATE`,`normalized_path`(`raw_ratings`.`URL`) AS `URL`,`raw_ratings`.`RESOLUTION` AS `RESOLUTION`,`raw_ratings`.`EMAIL` AS `EMAIL`,`raw_ratings`.`USERNAME` AS `USERNAME`,`raw_ratings`.`COMMENT_DATE` AS `COMMENT_DATE`,`raw_ratings`.`COMMENT_VALUE` AS `COMMENT_VALUE`,`raw_ratings`.`SUGGESTION_VALUE` AS `SUGGESTION_VALUE`,`raw_ratings`.`STATE` AS `STATE`,`raw_ratings`.`COUNTRY` AS `COUNTRY`,`raw_ratings`.`IP` AS `IP`,`raw_ratings`.`HOST` AS `HOST` from `raw_ratings` where ((`raw_ratings`.`RATE` > 0) and (1 or (not((`raw_ratings`.`EMAIL` like '@mulesoft%'))) or (not((`raw_ratings`.`EMAIL` like '@mulesource%')))));

-- 
-- View `ratings_agg_per_page`
-- 

DROP VIEW IF EXISTS `ratings_agg_per_page`;
CREATE ALGORITHM=UNDEFINED DEFINER=`hurtuser`@`%` SQL SECURITY DEFINER VIEW `ratings_agg_per_page` AS select max(`ratings`.`COMMENT_DATE`) AS `latest_comment`,`ratings`.`URL` AS `url`,count(0) AS `comment_count`,min(`ratings`.`COMMENT_DATE`) AS `earliest_comment` from `ratings` group by `ratings`.`URL` order by max(`ratings`.`COMMENT_DATE`) desc,`ratings`.`URL`;

-- 
-- View `recent_rated_views`
-- 

DROP VIEW IF EXISTS `recent_rated_views`;
CREATE ALGORITHM=UNDEFINED DEFINER=`hurtuser`@`%` SQL SECURITY DEFINER VIEW `recent_rated_views` AS select `recent_views`.`path` AS `path`,`recent_views`.`views` AS `views` from (`recent_views` join `ratings`) where (`recent_views`.`path` = `ratings`.`URL`);

-- 
-- Function `agg_hurtrankfn`
-- 

DROP FUNCTION IF EXISTS `agg_hurtrankfn`;
CREATE DEFINER=`hurtuser`@`%` FUNCTION `agg_hurtrankfn`(`indate` date) RETURNS float
    DETERMINISTIC
BEGIN


DROP TEMPORARY TABLE IF EXISTS recent_views;
CREATE TEMPORARY TABLE IF NOT EXISTS recent_views  (
  path varchar(127) NOT NULL,
  views int(11) NOT NULL,
            PRIMARY KEY (path)  
) ENGINE=innodb;
   
 
INSERT INTO recent_views SELECT
    path, SUM(views) AS views
  FROM normalized_traffic r
  WHERE r.date <= indate AND r.date >= DATE_SUB(indate, INTERVAL 28 DAY)
  GROUP BY path;

  
  SET @total_recent_views = (SELECT SUM(views) AS v FROM recent_views);
  set @today_views_count = (SELECT sum(views) FROM normalized_traffic WHERE normalized_traffic.date=indate) ;
  set @total_ratings_count = (SELECT COUNT(*) FROM ratings WHERE COMMENT_DATE <= indate); -- be sure to count only ratings up through indate
  set @today_ratings_count = (SELECT COUNT(*) FROM ratings WHERE COMMENT_DATE = indate);

  DROP temporary TABLE IF EXISTS t_hurt;
 
  CREATE temporary TABLE t_hurt ENGINE=memory AS (SELECT
      url,
      AVG(r.rate) AS avgrate,
      COUNT(r.rate) AS rating_count,
      AVG(5 - r.rate) * COUNT(r.rate) AS hurtshare, 
      v.views AS views,

     AVG(r.rate) * COUNT(r.RATE) * v.views / (@total_ratings_count * @total_recent_views) AS hurtscore
     FROM ratings r, recent_views v
     WHERE r.COMMENT_DATE <= indate AND v.path = r.url
     GROUP BY r.url);


   SET @result = (SELECT
      100 * sum(t_hurt.hurtscore) AS total_hurtrank
    FROM t_hurt);

  SET @rankcount = (SELECT
      count(t_hurt.hurtscore) AS total_hurtrank
    FROM t_hurt);

  
  INSERT INTO daily_hurtrank (d, hurtrank, total_views, total_ratings, today_views, today_ratings)
     VALUES (indate, @result, @total_recent_views, @total_ratings_count,  @today_views_count, @today_ratings_count)
    ON DUPLICATE KEY UPDATE hurtrank=@result, total_views=@total_recent_views,
      total_ratings=@total_ratings_count, today_views=@today_views_count, today_ratings=@today_ratings_count;

  RETURN @result;

END;

-- 
-- Function `agg_hurtrankfn_rated_pages_only`
-- 

DROP FUNCTION IF EXISTS `agg_hurtrankfn_rated_pages_only`;
CREATE DEFINER=`hurtuser`@`%` FUNCTION `agg_hurtrankfn_rated_pages_only`(`indate` date) RETURNS float
    DETERMINISTIC
BEGIN


  DROP TEMPORARY TABLE IF EXISTS recent_rated_views;
 
  CREATE TEMPORARY TABLE recent_rated_views ENGINE = MEMORY AS
  SELECT
    path,
    SUM(views) AS views
  FROM rated_traffic r
  WHERE r.date <= indate AND r.date >= DATE_SUB(indate, INTERVAL 28 DAY)
  GROUP BY path;

  

  SET @total_rated_views = (SELECT
      SUM(views) AS v
    FROM rated_traffic);

  SET @total_recent_rates = (SELECT
      COUNT(*)
    FROM ratings
    WHERE ratings.COMMENT_DATE <= indate);

  

  
  

  

  DROP TEMPORARY TABLE IF EXISTS t;

  CREATE TEMPORARY TABLE t AS (SELECT
      url,
      AVG(5 - r.rate) AS avghurt,
      COUNT(r.rate) AS rcount,
      AVG(5 - r.rate) * COUNT(r.rate) AS hurtshare,
      v.views AS hurtviews,
      @total_recent_views AS trv,
      AVG(5 - r.rate) * COUNT(r.rate) * (v.views * 100 / (@total_recent_rates * @total_rated_views)) AS hurtscore
    FROM ratings r,
         recent_rated_views v
    WHERE r.COMMENT_DATE <= indate AND v.path = r.url
    GROUP BY r.url);

  SET @result = (SELECT
      SUM(t.hurtscore) AS total_hurtrank
    FROM t);
  INSERT INTO daily_denom (d, denom, result)
    VALUES (indate, @total_recent_views, @result);

  RETURN @result;

  RETURN 1;
END;

-- 
-- Function `agg_hurtrank_daterangesfn`
-- 

DROP FUNCTION IF EXISTS `agg_hurtrank_daterangesfn`;
CREATE DEFINER=`hurtuser`@`%` FUNCTION `agg_hurtrank_daterangesfn`(`viewstartdate` date, `viewenddate` date, `rankstartdate` date, `rankenddate` date) RETURNS float
    DETERMINISTIC
BEGIN


DROP TEMPORARY TABLE IF EXISTS recent_views;
CREATE TEMPORARY TABLE IF NOT EXISTS recent_views  (
  path varchar(127) NOT NULL,
  views int(11) NOT NULL,
            PRIMARY KEY (path)  
) ENGINE=innodb;
   
 
INSERT INTO recent_views SELECT
    path, SUM(views) AS views
  FROM normalized_traffic r
  WHERE r.date BETWEEN viewstartdate and viewenddate
  GROUP BY path;

  
  SET @total_recent_views = (SELECT SUM(views) AS v FROM recent_views);
  set @today_views_count = (SELECT sum(views) FROM normalized_traffic WHERE normalized_traffic.date=rankenddate) ;
  set @total_ratings_count = (SELECT COUNT(*) FROM ratings WHERE COMMENT_DATE between rankstartdate and rankenddate); -- be sure to count only ratings up through indate
  set @today_ratings_count = (SELECT COUNT(*) FROM ratings WHERE COMMENT_DATE = rankenddate);

  DROP temporary TABLE IF EXISTS t_hurt;
 
  CREATE temporary TABLE t_hurt ENGINE=memory AS (SELECT
      url,
      AVG(r.rate) AS avgrate,
      COUNT(r.rate) AS rating_count,
      AVG(5 - r.rate) * COUNT(r.rate) AS hurtshare, 
      v.views AS views,

     AVG(r.rate) * COUNT(r.RATE) * v.views / (@total_ratings_count * @total_recent_views) AS hurtscore
     FROM ratings r, recent_views v
     WHERE (r.COMMENT_DATE between rankstartdate and rankenddate) AND v.path = r.url
     GROUP BY r.url);


   SET @result = (SELECT
      100 * sum(t_hurt.hurtscore) AS total_hurtrank
    FROM t_hurt);

  SET @rankcount = (SELECT
      count(t_hurt.hurtscore) AS total_hurtrank
    FROM t_hurt);

  
--  INSERT INTO daily_hurtrank (d, hurtrank, total_views, total_ratings, today_views, today_ratings)
--    VALUES (indate, @result, @total_recent_views, @total_ratings_count,  @today_views_count, @today_ratings_count)
--    ON DUPLICATE KEY UPDATE hurtrank=@result, total_views=@total_recent_views,
--      total_ratings=@total_ratings_count, today_views=@today_views_count, today_ratings=@today_ratings_count;

  RETURN @result;

END;

-- 
-- Function `basepath`
-- 

DROP FUNCTION IF EXISTS `basepath`;
CREATE DEFINER=`hurtuser`@`%` FUNCTION `basepath`(`inpath` varchar(512)) RETURNS varchar(512) CHARSET utf8
    DETERMINISTIC
    COMMENT 'determines base path for a page with version or book title and page title '
BEGIN
  DECLARE result varchar(512);
  SET result = TRIM(inpath);

  
  SET result = SUBSTRING_INDEX(result, "?", 1);
  SET result = SUBSTRING_INDEX(result, "&", 1);
  SET result = TRIM(TRAILING '/' FROM result);
  SET result = SUBSTRING_INDEX(result, "/", - 1);

  RETURN result;
END;

-- 
-- Procedure `buildranktable`
-- 

DROP PROCEDURE IF EXISTS `buildranktable`;
CREATE DEFINER=`hurtuser`@`%` PROCEDURE `buildranktable`(IN indate date)
BEGIN
  DROP TABLE IF EXISTS ranktable;
  CREATE TABLE RankTable ENGINE MYISAM AS SELECT
    date_value,
    agg_hurtrankfn(date_value) AS agg_hurtrank
  FROM dim_date dd
  WHERE date_value < indate;

  ANALYZE TABLE RankTable;
END;

-- 
-- Procedure `hurtrank_by_quarter`
-- 

DROP PROCEDURE IF EXISTS `hurtrank_by_quarter`;
CREATE DEFINER=`hurtuser`@`%` PROCEDURE `hurtrank_by_quarter`()
BEGIN
drop temporary table if exists quarters;
CREATE Temporary TABLE quarters as 
	select year, quarter_name, min(date_value) as first_date, max(date_value) as last_date
	from dim_date, ratings 
	where dim_date.date_value <= (select max(ratings.comment_date) from ratings) 
		and dim_date.date_value>= (select min(ratings.comment_date) from ratings)
	group by year,quarter_name order by last_date;

select concat(year,'-',quarter_name) as quarter, 
	agg_hurtrank_daterangesfn(first_date, last_date, first_date, last_date) as quarter_rank, 
	(select avg(rate) from ratings where comment_date between first_date and last_date) avg_rating,
	(select count(rate) from ratings where comment_date between first_date and last_date) count_ratings from quarters;

END;

-- 
-- Procedure `load_normalized_traffic`
-- 

DROP PROCEDURE IF EXISTS `load_normalized_traffic`;
CREATE DEFINER=`hurtuser`@`%` PROCEDURE `load_normalized_traffic`()
    COMMENT 'Updates the "normalized traffic" table to match the raw traffic'
BEGIN
  TRUNCATE TABLE normalized_traffic;

  INSERT INTO normalized_traffic (path, date, views)
    SELECT
      normalized_path(r.path) AS npath,
      r.date AS date,
      SUM(r.views) AS views

    FROM raw_traffic r
    GROUP BY npath,
             r.date
    ORDER BY npath, date desc;
OPTIMIZE TABLE normalized_traffic;
ANALYZE TABLE normalized_traffic;
 
END;

-- 
-- Procedure `load_rated_traffic`
-- 

DROP PROCEDURE IF EXISTS `load_rated_traffic`;
CREATE DEFINER=`hurtuser`@`%` PROCEDURE `load_rated_traffic`()
BEGIN

    DROP TABLE IF EXISTS rated_traffic;
    CREATE TABLE rated_traffic  ENGINE MYISAM AS SELECT
    path,
    date,
    views
  FROM normalized_traffic
  WHERE path IN (SELECT
      url
    FROM ratings);
  ANALYZE TABLE rated_traffic;
 










END;

-- 
-- Function `normalized_path`
-- 

DROP FUNCTION IF EXISTS `normalized_path`;
CREATE DEFINER=`hurtuser`@`%` FUNCTION `normalized_path`(`inpath` varchar(512)) RETURNS varchar(512) CHARSET utf8
    DETERMINISTIC
    COMMENT 'strips  away GET params and other noise characters from a path'
BEGIN
  DECLARE result varchar(512);
  SET result = TRIM(inpath);

  
  SET result = SUBSTRING_INDEX(result, "?", 1);
  SET result = SUBSTRING_INDEX(result, "&", 1);
  SET result = TRIM(TRAILING '/' FROM result);
  SET result = SUBSTRING_INDEX(result, "/", - 1);
  RETURN result; 
END;

-- 
-- Procedure `populate_all_hurtranks`
-- 

DROP PROCEDURE IF EXISTS `populate_all_hurtranks`;
CREATE DEFINER=`hurtuser`@`%` PROCEDURE `populate_all_hurtranks`()
BEGIN
select dim_date.date_value, agg_hurtrankfn(dim_date.date_value) from dim_date 
	where date_value <= (select max(comment_date) from ratings) 
	and date_value >= (select min(comment_date) from ratings);
-- side effect: agg_hurtrankfn saves each calculated hurtrank into the daily_hurtrank table
SELECT * FROM daily_hurtrank;
END;

-- 
-- Procedure `p_load_dim_date`
-- 

DROP PROCEDURE IF EXISTS `p_load_dim_date`;
CREATE DEFINER=`hurtuser`@`%` PROCEDURE `p_load_dim_date`(IN `p_from_date` date
, IN `p_to_date` date)
BEGIN
  DECLARE v_date date DEFAULT p_from_date;
  DECLARE v_month tinyint;
  CREATE TABLE IF NOT EXISTS dim_date (
    date_key int PRIMARY KEY, 
    date_value date,
    date_iso char(10),
    year smallint,
    quarter tinyint,
    quarter_name char(2),
    month tinyint,
    month_name varchar(10),
    month_abbreviation varchar(10),
    week char(2),
    day_of_month tinyint,
    day_of_year smallint,
    day_of_week smallint,
    day_name varchar(10),
    day_abbreviation varchar(10),
    is_weekend tinyint,
    is_weekday tinyint,
    is_today tinyint,
    is_yesterday tinyint,
    is_this_week tinyint,
    is_last_week tinyint,
    is_this_month tinyint,
    is_last_month tinyint,
    is_this_year tinyint,
    is_last_year tinyint
  );
  WHILE v_date < p_to_date DO
    SET v_month := MONTH(v_date);
    INSERT INTO dim_date (date_key
    , date_value
    , date_iso
    , year
    , quarter
    , quarter_name
    , month
    , month_name
    , month_abbreviation
    , week
    , day_of_month
    , day_of_year
    , day_of_week
    , day_name
    , day_abbreviation
    , is_weekend
    , is_weekday)
      VALUES (v_date + 0, v_date, DATE_FORMAT(v_date, '%y-%c-%d'), YEAR(v_date), ((v_month - 1) DIV 3) + 1, CONCAT('Q', ((v_month - 1) DIV 3) + 1), v_month, DATE_FORMAT(v_date, '%M'), DATE_FORMAT(v_date, '%b'), DATE_FORMAT(v_date, '%u'), DATE_FORMAT(v_date, '%d'), DATE_FORMAT(v_date, '%j'), DATE_FORMAT(v_date, '%w') + 1, DATE_FORMAT(v_date, '%W'), DATE_FORMAT(v_date, '%a'), IF(DATE_FORMAT(v_date, '%w') IN (0, 6), 1, 0), IF(DATE_FORMAT(v_date, '%w') IN (0, 6), 0, 1));
    SET v_date := v_date + INTERVAL 1 DAY;
  END WHILE;
  CALL p_update_dim_date();
END;

-- 
-- Procedure `p_update_dim_date`
-- 

DROP PROCEDURE IF EXISTS `p_update_dim_date`;
CREATE DEFINER=`hurtuser`@`%` PROCEDURE `p_update_dim_date`()
UPDATE dim_date
  SET is_today = IF(date_value = CURRENT_DATE, 1, 0),
      is_yesterday = IF(date_value = CURRENT_DATE - INTERVAL 1 DAY, 1, 0),
      is_this_week = IF(year = YEAR(CURRENT_DATE) AND week = DATE_FORMAT(CURRENT_DATE, '%u'), 1, 0),
      is_last_week = IF(year = YEAR(CURRENT_DATE - INTERVAL 7 DAY) AND week = DATE_FORMAT(CURRENT_DATE - INTERVAL 7 DAY, '%u'), 1, 0),
      is_this_month = IF(year = YEAR(CURRENT_DATE) AND month = MONTH(CURRENT_DATE), 1, 0),
      is_last_month = IF(year = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) AND month = MONTH(CURRENT_DATE - INTERVAL 1 MONTH), 1, 0),
      is_this_year = IF(year = YEAR(CURRENT_DATE), 1, 0),
      is_last_year = IF(year = YEAR(CURRENT_DATE - INTERVAL 1 year), 1, 0)
  WHERE is_today
  OR is_yesterday
  OR is_this_week
  OR is_last_week
  OR is_this_month 
  OR is_last_month
  OR is_this_year
  OR is_last_year
  OR IF(date_value = CURRENT_DATE, 1, 0)
  OR IF(date_value = CURRENT_DATE - INTERVAL 1 DAY, 1, 0)
  OR IF(year = YEAR(CURRENT_DATE) AND week = DATE_FORMAT(CURRENT_DATE, '%u'), 1, 0)
  OR IF(year = YEAR(CURRENT_DATE - INTERVAL 7 DAY) AND week = DATE_FORMAT(CURRENT_DATE - INTERVAL 7 DAY, '%u'), 1, 0)
  OR IF(year = YEAR(CURRENT_DATE) AND month = MONTH(CURRENT_DATE), 1, 0)
  OR IF(year = YEAR(CURRENT_DATE - INTERVAL 1 MONTH) AND month = MONTH(CURRENT_DATE - INTERVAL 1 MONTH), 1, 0)
  OR IF(year = YEAR(CURRENT_DATE), 1, 0)
  OR IF(year = YEAR(CURRENT_DATE - INTERVAL 1 year), 1, 0);

