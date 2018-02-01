package net.janklab.mdbc.colbuf;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Fetches, buffers, and returns as java.lang.Object values.
 * 
 * The fetch is done using getObject() to get the default Object representation.
 */
public class ObjectColumnBuffer extends AbstractColumnBuffer {
  
  private List<Object> buf;
  
  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new ArrayList<>();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    Object val = rs.getObject(colIndex);
    if (rs.wasNull()) {
      buf.add(null);
    } else {
      buf.add(val);
    }
  }
     
  @Override
  public Object[] getBuffer() {
    return buf.toArray(new Object[0]);
  }
  
}
