package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.doubles.DoubleArrayList;
import it.unimi.dsi.fastutil.longs.LongArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Fetches java.sql.Timestamps, buffers them as day and nanosecond components,
 * for coversion to a jl.time.timestamp.
 */
public class TimestampColumnBuffer extends AbstractColumnBuffer {
  private DoubleArrayList datenumBuf;
  private LongArrayList nanosOfDayBuf;
  
  public static final long UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS = 719529;
  public static final int MILLIS_PER_DAY = 24 * 60 * 60 * 1000;
  
  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    datenumBuf = new DoubleArrayList();
    nanosOfDayBuf = new LongArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    java.sql.Timestamp sqlDate = rs.getTimestamp(colIndex);
    if (rs.wasNull()) {
      datenumBuf.add(Double.NaN);
      nanosOfDayBuf.add(0);
    } else {
      long time = sqlDate.getTime();
      // Work around time zone offset to get back to database's local value
      time = time - sqlDate.getTimezoneOffset() * 60 * 1000;
      long nanosField = sqlDate.getNanos();
      long unixDays = time / MILLIS_PER_DAY;
      double datenum = unixDays + UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS;
      long millisOfDay = (int) (time - (unixDays * MILLIS_PER_DAY));
      // Avoid double-counting nanos that appear in milliseconds
      long extraNanos = nanosField % 1000000;
      long nanosOfDay = (millisOfDay * 1000000) + extraNanos;
      // Buffer
      datenumBuf.add(datenum);
      nanosOfDayBuf.add(nanosOfDay);
    }
  }
  
  @Override
  public BufferedTimestampComponents getBuffer() {
    return new BufferedTimestampComponents(datenumBuf.toArray(new double[0]), 
            nanosOfDayBuf.toArray(new long[0]));
  }

}
