// Functions lifted from Google Apps Script for Hurtrank 
// Antonio Romero, 23 October 2013
// To recreate, paste each into a separate function in a script. Wish Google had some way to export these, but... no. 



function hurtrankFN(startViewDate,endViewDate,startRateDate,endRateDate) {
  var conn = Jdbc.getConnection("jdbc:mysql://hurtrankdb.cpk4jjb2mzwd.us-west-2.rds.amazonaws.com:3306/hurtrank", "hurtuser", "hurtrank");
  var stmt = conn.createStatement();
  stmt.setMaxRows(5000);

  var q="select agg_hurtrank_daterangesfn('" + startViewDate + "', '" + endViewDate+ "', '" + startRateDate + "', '" + endRateDate +"') from dual;"
  var rs = stmt.executeQuery(q);
  rs.next();
  result= rs.getString(1);

  rs.close();
  stmt.close();
  conn.close();
  return result;
}

