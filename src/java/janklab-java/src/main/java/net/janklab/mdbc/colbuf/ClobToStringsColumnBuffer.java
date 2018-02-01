package net.janklab.mdbc.colbuf;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Fetches CLOBs, buffering and returning them as Strings.
 */
public class ClobToStringsColumnBuffer extends AbstractColumnBuffer {
  
  private List<String> buf;
  
  /** If true, will fetch NCLOBs instead of CLOBs. */
  public boolean useNClob;
  
  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new ArrayList<>();
  }
  
  @Override
  public void fetchNextValue() throws SQLException {
    java.sql.Clob clob = useNClob? rs.getNClob(colIndex) : rs.getClob(colIndex);
    if (rs.wasNull()) {
      buf.add(null);
    } else {
      long length = clob.length();
      if (length > Integer.MAX_VALUE) {
        // This limitation seems fine: that's a limit of 2 GB, which will be
        // too large to fit in the Java heap anyway.
        throw new SQLException("CLOB size exceeds MDBC maximum length");
      }
      String val = clob.getSubString(1, (int) length);
      buf.add(val);
      clob.free();
    }
  }

  @Override
  public Object getBuffer() {
    return buf.toArray(new String[0]);
  }
  
}