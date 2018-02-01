package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.doubles.DoubleArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import net.janklab.time.TimeUtil;

/**
 * Fetches java.sql.Timestamps, buffers and returns the datenum representation
 * of a zoneless datetime. This is a lossy conversion, since the precision of
 * LocalDateTime is less than that of java.sql.Timestamp.
 */
public class TimestampToLocaldatenumColumnBuffer extends AbstractColumnBuffer {
  
  private DoubleArrayList buf;
  
  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new DoubleArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    java.sql.Timestamp sqlDate = rs.getTimestamp(colIndex);
    if (rs.wasNull()) {
      buf.add(Double.NaN);
    } else {
      LocalDateTime localDateTime = sqlDate.toLocalDateTime();
      double datenum = TimeUtil.javaLocalDateTime2datenum(localDateTime);
      buf.add(datenum);
    }
  }
     
  @Override
  public double[] getBuffer() {
    return buf.toArray(new double[0]);
  }
  
  
}
