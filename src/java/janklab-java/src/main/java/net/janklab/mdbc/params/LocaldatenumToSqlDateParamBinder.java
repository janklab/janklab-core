package net.janklab.mdbc.params;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import static java.util.Objects.requireNonNull;
import java.util.TimeZone;
import net.janklab.mdbc.ParamBinder;

/**
 * A binder that takes datenums and binds them to SQL DATEs. Does not do
 * anything with time zones; it assumes that the incoming datenums are local
 * dates.
 */
public class LocaldatenumToSqlDateParamBinder extends ParamBinder {
  
  private double[] buf;
  // Reuse a single date object for performance
  private final java.sql.Date date = new java.sql.Date(0);
  // The UTC Timezone, as a calendar
  private static final Calendar UTC = new GregorianCalendar(TimeZone.getTimeZone("GMT"));
  
  public void setBuffer(double[] buf) {
    requireNonNull(buf);
    this.buf = buf;
  }
  
  @Override
  public void bindParam(int index) throws SQLException {  
    requireAttached();
    if (Double.isNaN(buf[index])) {
      stmt.setNull(paramIndex, java.sql.Types.DATE);
    } else {
      long unixTime = JdbcTimeUtil.datenum2javaTimeUtc(buf[index]);
      date.setTime(unixTime);
      stmt.setDate(paramIndex, date, UTC);
    }
  }
}
