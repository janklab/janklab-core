package net.janklab.mdbc.params;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import static java.util.Objects.requireNonNull;
import java.util.TimeZone;
import net.janklab.mdbc.ParamBinder;
import net.janklab.mdbc.colbuf.BufferedTimestampComponents;

/**
 *
 */
public class TimestampParamBinder  extends ParamBinder {

  BufferedTimestampComponents buf;
  boolean mapNaNsToNulls = true;
  // Reuse a single object for performance
  java.sql.Timestamp sqlDate = new java.sql.Timestamp(0);
  // The UTC Timezone, as a calendar
  private static final Calendar UTC = new GregorianCalendar(TimeZone.getTimeZone("GMT"));
  
  public static final long UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS = 719529;
  public static final int MILLIS_PER_DAY = 24 * 60 * 60 * 1000;

  public void setBuffer(BufferedTimestampComponents buf) {
    requireNonNull(buf);
    this.buf = buf;
  }

  @Override
  public void bindParam(int index) throws SQLException {
    requireAttached();
    if (Double.isNaN(buf.datenums[index])) {
      stmt.setNull(paramIndex, java.sql.Types.TIMESTAMP);
    } else {
      double datenum = buf.datenums[index];
      long nanosOfDay = buf.nanosOfDays[index];
      long unixDay = (long) ((datenum - UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS) 
              * MILLIS_PER_DAY);
      long millisOfDayToSecond = (nanosOfDay / 1000000000) * 1000;
      int nanosOfSecond = (int) (nanosOfDay - (millisOfDayToSecond * 1000000));
      long unixTime = unixDay + millisOfDayToSecond;
      sqlDate.setTime(unixTime);
      sqlDate.setNanos(nanosOfSecond);
      stmt.setTimestamp(paramIndex, sqlDate, UTC);
    }
  }
  
}