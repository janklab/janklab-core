package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.doubles.DoubleArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import net.janklab.time.TimeUtil;

/**
 * Fetches java.sql.Dates, buffers and returns the datenum representation
 * of a jl.time.localdate. This is used for buffering SQL DATEs and
 * converting them to jl.time.localdate.
 */
public class SqlDateToLocaldatenumColumnBuffer extends AbstractColumnBuffer {
  
  private DoubleArrayList buf;
  
  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new DoubleArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    java.sql.Date sqlDate = rs.getDate(colIndex);
    if (rs.wasNull()) {
      buf.add(Double.NaN);
    } else {
      LocalDate localDate = sqlDate.toLocalDate();
      double datenum = TimeUtil.javaLocalDate2datenum(localDate);
      buf.add(datenum);
    }
  }
     
  @Override
  public double[] getBuffer() {
    return buf.toArray(new double[0]);
  }
  
}
