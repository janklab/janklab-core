package net.janklab.mdbc.params;

import java.sql.SQLException;
import static java.util.Objects.requireNonNull;
import net.janklab.mdbc.ParamBinder;
import net.janklab.util.Symbol;
import org.apache.commons.lang.StringUtils;

/**
 *
 */
public class SymbolParamBinder extends ParamBinder {
  
  int[] buf;
  boolean mapEmptysToNulls = false;
  
  public void setBuffer(int[] buf) {
    requireNonNull(buf);
    this.buf = buf;
  }
  
  @Override
  public void bindParam(int index) throws SQLException {
    requireAttached();
    String val = Symbol.decodeSymbol(buf[index]);
    if (mapEmptysToNulls && StringUtils.isEmpty(val)) {
      stmt.setNull(paramIndex, java.sql.Types.CHAR);
    } else {
      stmt.setString(paramIndex, val);
    }
  }
}
