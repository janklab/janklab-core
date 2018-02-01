package net.janklab.mdbc.params;

import java.sql.SQLException;
import static java.util.Objects.requireNonNull;
import net.janklab.mdbc.ParamBinder;

public class StringParamBinder extends ParamBinder {

  private String[] buf;
  
  public void setBuffer(String[] buf) {
    requireNonNull(buf);
    this.buf = buf;
  }

  @Override
  public void bindParam(int index) throws SQLException {
    requireAttached();
    if (buf[index] == null) {
      stmt.setNull(paramIndex, java.sql.Types.CHAR);
    } else {
      stmt.setString(paramIndex, buf[index]);
    }
  }
}