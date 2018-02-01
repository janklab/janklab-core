package net.janklab.mdbc.colbuf;

import java.sql.ResultSet;
import java.sql.SQLException;
import net.janklab.mdbc.ColumnBuffer;

/**
 *
 */
public abstract class AbstractColumnBuffer implements ColumnBuffer {
  
  protected int colIndex;
  protected ResultSet rs;
  protected String colLabel;
  
  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    this.rs = rs;
    this.colIndex = colIndex;
    this.colLabel = rs.getMetaData().getColumnLabel(colIndex);
  }
}
