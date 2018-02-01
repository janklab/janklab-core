package net.janklab.mdbc.colbuf;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Fetches and buffers BINARY/VARBINARY data as byte[]s.
 */
public class BinaryColumnBuffer extends AbstractColumnBuffer {
  
  private List<byte[]> buf;
  
  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new ArrayList<>();
  }
  
  @Override
  public void fetchNextValue() throws SQLException {
    byte[] val = rs.getBytes(colIndex);
    if (rs.wasNull()) {
      buf.add(null);
    } else {
      buf.add(val);
    }
  }

  @Override
  public Object getBuffer() {
    return buf.toArray(new byte[0][]);
  }
  
}

