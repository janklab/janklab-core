package net.janklab.mdbc.params;

import java.sql.SQLException;
import static java.util.Objects.requireNonNull;
import net.janklab.mdbc.ParamBinder;

/**
 *
 */
public class DoubleParamBinder extends ParamBinder {

  double[] buf;
  boolean mapNaNsToNulls = true;
  
  public void setBuffer(double[] buf) {
    requireNonNull(buf);
    this.buf = buf;
  }

  @Override
  public void bindParam(int index) throws SQLException {
    requireAttached();
    if (Double.isNaN(buf[index]) && mapNaNsToNulls) {
      stmt.setNull(paramIndex, java.sql.Types.DOUBLE);
    } else {
      stmt.setDouble(paramIndex, buf[index]);
    }
  }
}
