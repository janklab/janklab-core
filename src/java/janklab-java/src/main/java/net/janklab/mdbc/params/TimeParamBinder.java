package net.janklab.mdbc.params;

import java.sql.SQLException;
import java.util.Calendar;
import java.util.GregorianCalendar;
import static java.util.Objects.requireNonNull;
import java.util.TimeZone;
import net.janklab.mdbc.ParamBinder;

/**
 * A binder that takes milliseconds-of-day and binds them to SQL TIMEs. The 
 * time values are passed in as doubles so NULLs can be represented in-band as
 * NaNs.
 */
public class TimeParamBinder extends ParamBinder {
  
  private double[] buf;
  // Reuse a single time object for performance
  private final java.sql.Time time = new java.sql.Time(0);
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
      stmt.setNull(paramIndex, java.sql.Types.TIME);
    } else {
      long unixTime = (long) buf[index];
      time.setTime(unixTime);
      stmt.setTime(paramIndex, time, UTC);
    }
  }
}
