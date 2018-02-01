package net.janklab.mdbc.colbuf;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Fetches and buffers java.sql.Dates, returning java.sql.Date[]. Dates are 
 * fetched in local time, so toLocalDate() works smoothly.
 */
public class SqlDateColumnBuffer extends AbstractColumnBuffer {
  
  private List<java.sql.Date> buf;
  
  //private final Calendar utcCal;
  
  public SqlDateColumnBuffer() {
    //utcCal = new GregorianCalendar(TimeZone.getTimeZone("UTC"));
  }

  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new ArrayList<>();
  }
  
  @Override
  public void fetchNextValue() throws SQLException {
    java.sql.Date val = rs.getDate(colIndex);
    if (rs.wasNull()) {
      buf.add(null);
    } else {
      buf.add(val);
    }
  }

  @Override
  public Object getBuffer() {
    return buf.toArray(new java.sql.Date[0]);
  }
  
}
