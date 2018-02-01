package net.janklab.mdbc;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import static java.util.Objects.requireNonNull;

/**
 * A wrapper for PreparedStatement that provides batch-update and other
 * functionality needed by MDBC.
 */
public class JLPreparedStatement {
  
  public final PreparedStatement jdbcStatement;
  public final List<ParamBinder> binders = new ArrayList<>();
  
  public JLPreparedStatement(PreparedStatement jdbcStatement) {
    requireNonNull(jdbcStatement);
    this.jdbcStatement = jdbcStatement;
  }
  
  public void addBinder(ParamBinder binder) {
    requireNonNull(binder);
    binders.add(binder);
  }
  
  public void bindBatch(int batchSize) throws SQLException {
    for (int i = 0; i < batchSize; i++) {
      for (int iParam = 0; iParam < binders.size(); iParam++) {
        binders.get(iParam).bindParam(i);
      }
      jdbcStatement.addBatch();
    }
  }
  
  public void bindSingle() throws SQLException {
      for (int iParam = 0; iParam < binders.size(); iParam++) {
        binders.get(iParam).bindParam(0);
      }    
  }
}
