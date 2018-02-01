package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.doubles.DoubleArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * A ColumnBuffer which fetches values as double, and buffers and returns them 
 * as double[]. This is the most commonly used general-purpose numeric data
 * buffer for MDBC, since Matlab's main numeric type is double.
 * 
 * NOTE: Because this fetches values using getDouble(), it is subject to silent
 * roundoff error.
 */
public class DoubleColumnBuffer extends AbstractColumnBuffer {
  private DoubleArrayList buf;

  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new DoubleArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    double val = rs.getDouble(colIndex);
    if (rs.wasNull()) {
      buf.add(Double.NaN);
    } else {
      buf.add(val);
    }
  }

  @Override
  public double[] getBuffer() {
    return buf.toArray(new double[0]);
  }
  
}
