package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.doubles.DoubleArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 * A ColumnBuffer that fetches values as longs and buffers them as doubles,
 * raising a warning when overflow error occurs.
 */
public class LoudBigintToDoubleColumnBuffer extends AbstractColumnBuffer {
  private DoubleArrayList buf;
  
  public static final long ROUNDOFF_THRESHOLD = 9007199254740991L;

  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new DoubleArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    long val = rs.getLong(colIndex);
    long absVal = Math.abs(val);
    double doubleVal = absVal;
    if (absVal > ROUNDOFF_THRESHOLD) {
        roundoffWarning(val, doubleVal);
    }
    buf.add(doubleVal);
  }
  
  private void roundoffWarning(long originalVal, 
          double roundedVal) {
    String str = String.format("WARNING: Column %d (\"%s\", Bigint to double): "
            + "Roundoff error: original value %s, rounded value %s",
            colIndex, colLabel, ""+originalVal, ""+roundedVal);
    System.err.println(str);
  }

  @Override
  public double[] getBuffer() {
    return buf.toArray(new double[0]);
  }

}
