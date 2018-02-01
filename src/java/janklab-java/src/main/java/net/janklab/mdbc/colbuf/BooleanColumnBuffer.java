package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.booleans.BooleanArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Fetches and buffers values as boolean, returns boolean[].
 */
public class BooleanColumnBuffer extends AbstractColumnBuffer {
  private BooleanArrayList buf;

  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new BooleanArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    boolean val = rs.getBoolean(colIndex);
    if (rs.wasNull()) {
      buf.add(false);
    } else {
      buf.add(val);
    }
  }

  @Override
  public boolean[] getBuffer() {
    return buf.toArray(new boolean[0]);
  }
    
}
