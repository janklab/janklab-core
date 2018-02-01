package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.floats.FloatArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * A ColumnBuffer which fetches values as float, and buffers and returns them 
 * as float[].
 * @author janke
 */
public class FloatColumnBuffer extends AbstractColumnBuffer {
  private FloatArrayList buf;

  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new FloatArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    float val = rs.getFloat(colIndex);
    if (rs.wasNull()) {
      buf.add(Float.NaN);
    } else {
      buf.add(val);
    }
  }

  @Override
  public float[] getBuffer() {
    return buf.toArray(new float[0]);
  }
  
}
