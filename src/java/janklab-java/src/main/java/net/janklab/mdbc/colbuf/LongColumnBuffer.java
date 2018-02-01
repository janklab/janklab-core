package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.longs.LongArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;
import net.janklab.mdbc.ColumnBuffer;

/**
 * A ColumnBuffer which fetches and buffers values as longs, corresponding to 
 * the SQL BIGINT type.
 * 
 * This does not have a way to handle SQL NULLs. It just passes along whatever
 * value was fetched.
 */
public class LongColumnBuffer implements ColumnBuffer {
  private ResultSet rs;
  private int colIndex;
  private LongArrayList buf;

  @Override
  public void attach(ResultSet rs, int colIndex) {
    this.rs = rs;
    this.colIndex = colIndex;
    buf = new LongArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    long val = rs.getLong(colIndex);
    buf.add(val);
  }

  @Override
  public long[] getBuffer() {
    return buf.toArray(new long[0]);
  }
  
  
}
