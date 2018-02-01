package net.janklab.mdbc;

import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Class for binding parameter values to placeholder parameters. This implements
 * the Java side of a parameter type conversion & binding.
 */
public abstract class ParamBinder {
  
  protected PreparedStatement stmt;
  protected int paramIndex;
  protected boolean isAttached = false;
  
  public void attach(PreparedStatement stmt, int paramIndex) {
    this.stmt = stmt;
    this.paramIndex = paramIndex;
    this.isAttached = true;
  }
  
  protected void requireAttached() throws SQLException {
    if (!isAttached) {
      throw new SQLException("This ParamBinder is not attached to a statement.");
    }
  }
  
  public abstract void bindParam(int index) throws SQLException;
}
