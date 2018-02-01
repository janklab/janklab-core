package net.janklab.mdbc.colbuf;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Buffers BLOBs, retrieving their byte data and storing it as byte[] arrays.
 */
public class BlobToBytesColumnBuffer extends AbstractColumnBuffer {
  
  private List<byte[]> buf;
  
  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new ArrayList<>();
  }
  
  @Override
  public void fetchNextValue() throws SQLException {
    java.sql.Blob blob = rs.getBlob(colIndex);
    if (rs.wasNull()) {
      buf.add(null);
    } else {
      long length = blob.length();
      if (length > Integer.MAX_VALUE) {
        // This limitation seems fine: that's a limit of 2 GB, which will be
        // too large to fit in the Java heap anyway.
        throw new SQLException("BLOB size exceeds MDBC maximum length");
      }
      byte[] val = blob.getBytes(1, (int) length);
      buf.add(val);
      blob.free();
    }
  }

  @Override
  public Object getBuffer() {
    return buf.toArray(new byte[0][]);
  }
  
}
