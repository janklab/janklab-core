package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.ints.IntArrayList;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * A ColumnBuffer which fetches character data, buffers as Strings, and returns
 * it as java.lang.String[]. This is the basic generic char/string data buffer.
 */
public class SymbolColumnBuffer extends AbstractColumnBuffer {
  private IntArrayList buf;

  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new IntArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    String str = rs.getString(colIndex);
    int symbolVal = net.janklab.util.Symbol.encodeString(str);
    buf.add(symbolVal);
  }

  /**
   * Get the accumulated buffer, converting to String[].
   * @return String[] containing the buffered strings
   */
  @Override
  public int[] getBuffer() {
    return buf.toArray(new int[0]);
  }
  
}
