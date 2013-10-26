/* ultimately should replace this with a perl script or similar that both fetches the data from Google Analytics 
  and runs the MySQL mysqlimport command */

source load_traffic.sql;
source load_ratings.sql;
-- kick off the rest of the sequence
call load_normalized_traffic();
call populate_all_hurtranks();

