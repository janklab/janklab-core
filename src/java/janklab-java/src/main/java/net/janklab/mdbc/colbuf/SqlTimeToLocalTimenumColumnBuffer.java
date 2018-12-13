package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.doubles.DoubleArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Fetches java.sql.Time values, buffers and returns them as microseconds-of-day.
 * The micros-of-day values are stored as doubles instead of longs so that NULLs
 * can be represented in-band as NaNs.
 */
public class SqlTimeToLocalTimenumColumnBuffer extends AbstractColumnBuffer {
  
  private DoubleArrayList buf;

  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new DoubleArrayList();
  }

  @Override
  @SuppressWarnings("deprecation")
  public void fetchNextValue() throws SQLException {
    java.sql.Time sqlTime = rs.getTime(colIndex);
    if (rs.wasNull()) {
      buf.add(Double.NaN);
      return;
    }
    // Even though DBMSes like PostgreSQL have time values precise to the microsecond,
    // JDBC only exposes milliseconds. We'll just use the milliseconds for now.
    // Later, we may be able to get microsecond support by using vendor extensions.
    long utcMillis = sqlTime.getTime();
    long offsetMillis = sqlTime.getTimezoneOffset() * 60L * 1000L;
    long localMillis = utcMillis - offsetMillis;
    double localMicros = localMillis * 1000;
    buf.add(localMicros);
  }

  @Override
  public Object getBuffer() {
    return buf.toArray(new double[0]);
  }
  
}
