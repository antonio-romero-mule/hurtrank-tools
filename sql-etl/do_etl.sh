#!/bin/bash
echo Started at `date`
cd /home/ec2-user/etl
mv /opt/ga2csv/output/all-doc-traffic.csv /opt/ga2csv/output/all-doc-traffic.csv.old
echo Started ga2csv extract at `date`
/opt/ga2csv/ga2csv.sh /opt/ga2csv/recipes/all-doc-traffic.xml /opt/ga2csv/output/all-doc-traffic.csv
echo ...finished at `date` -- starting mysql import
mysql -vvv --host=hurtrankdb.cpk4jjb2mzwd.us-west-2.rds.amazonaws.com --user=hurtuser --password=hurtrank hurtrank < /home/ec2-user/etl/hurtrank_etl.sql 
echo ...all ETL finished at `date`
