package net.janklab.mdbc.colbuf;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * A ColumnBuffer which fetches character data, buffers as Strings, and returns
 * it as java.lang.String[]. This is the basic generic char/string data buffer.
 */
public class StringColumnBuffer extends AbstractColumnBuffer {
  private List<String> buf;

  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new ArrayList<>();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    buf.add(rs.getString(colIndex));
  }

  /**
   * Get the accumulated buffer, converting to String[].
   * @return String[] containing the buffered strings
   */
  @Override
  public Object getBuffer() {
    return buf.toArray(new String[0]);
  }
  
}
