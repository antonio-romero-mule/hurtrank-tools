// Functions lifted from Google Apps Script for Hurtrank 
// Antonio Romero, 23 October 2013
// To recreate, paste each into a separate function in a script. These had to be cut and pasted to make up a single file. 



function GetQuarterlyHurtrank() {
  var conn = Jdbc.getConnection("jdbc:mysql://hurtrankdb.cpk4jjb2mzwd.us-west-2.rds.amazonaws.com:3306/hurtrank", "hurtuser", "hurtrank");
  var stmt = conn.createStatement();
  stmt.setMaxRows(5000);
  var start = new Date();
  var rs = stmt.executeQuery("call hurtrank_by_quarter();");

  var doc = SpreadsheetApp.getActiveSpreadsheet();
  var cell=doc.getRangeByName("QuarterlyHurtrank");
  /* var cell = doc.getRange('a2'); /* start at one row down */
  var row = 0;
  while(rs.next()) {
    cell.offset(row, 0).setValue(rs.getString(1));
    cell.offset(row, 1).setValue(rs.getString(2));
    cell.offset(row, 2).setValue(rs.getString(3));
    cell.offset(row, 3).setValue(rs.getString(4));
    
    row++;
  }
  rs.close();
  stmt.close();
  conn.close();
  var end = new Date();
  Logger.log("time took: " + (end.getTime() - start.getTime()));
}
