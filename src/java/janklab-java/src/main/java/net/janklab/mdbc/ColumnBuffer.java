package net.janklab.mdbc;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * A buffer used for fetching a single column of results from a ResultSet. A 
 * ColumnBuffer class is responsible for choosing which getXxx() method to use
 * when fetching results, converting it to the internal buffer type, buffering
 * the fetched values, and converting the buffered values to a Matlab handoff
 * type. Basically, it handles the Java side of the fetched-data data flow.
 */
public interface ColumnBuffer {
  /** Attach to a ResultSet, preparing to fetch values from the given column. This
   * should clear the buffered values and reset the object's state.
   * @param rs
   * @param colIndex 
   * @throws java.sql.SQLException If something goes wrong
   */
  public void attach(ResultSet rs, int colIndex) throws SQLException;
  /** Fetch the next value for the attached column from the ResultSet and buffer it.
   * @throws java.sql.SQLException */
  public void fetchNextValue() throws SQLException;
  /** Get the accumulated buffer, converted to the Matlab handoff type.
   * @return The converted accumulated buffer. */
  public Object getBuffer();
}
