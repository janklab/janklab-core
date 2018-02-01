package net.janklab.mdbc;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLWarning;

/**
 * Handles fetching and buffering the contents of a ResultSet, converting it to 
 * Matlab-friendly types.
 */
public class ResultSetBuffer {
  private final ResultSet rs;
  int nColumns;
  private final ColumnBuffer[] columnBuffers;
  
  public ResultSetBuffer(ResultSet rs) throws SQLException {
    this.rs = rs;
    nColumns = rs.getMetaData().getColumnCount();
    this.columnBuffers = new ColumnBuffer[nColumns];
  }
  
  /**
   * Sets the column buffer object to use for a given column.
   * @param colIndex The column index, 1-indexed
   * @param columnBuffer The buffer object to use for that column
   */
  public void setColumnBuffer(int colIndex, ColumnBuffer columnBuffer) {
    columnBuffers[colIndex-1] = columnBuffer;
  }
  
  public ResultSetFetchResult fetch(int maxRows) throws SQLException {
    boolean isFinished = false;
    for (int iCol = 0; iCol < nColumns; iCol++) {
      columnBuffers[iCol].attach(rs, iCol+1);
    }
    int iRow = 0;
    while (iRow < maxRows) {
      if (!rs.next()) {
        isFinished = true;
        break;
      }
      iRow++;
      for (int iCol = 0; iCol < nColumns; iCol++) {
        columnBuffers[iCol].fetchNextValue();
      }
      // HACK/TODO: This warning code is a hack; it should be replaced by a real 
      // warning handler
      // that sends warnings to the log via SLF4J, or accumulates them on the
      // ResultSetFetchResult object.
      // TODO: Find a test case that produces per-row SqlWarnings and test this.
      SQLWarning warning = rs.getWarnings();
      if (warning != null) {
        System.err.println("WARNING: SQL Warning on row " + iRow + ": " + warning);
      }
    }
    Object[] bufferedData = new Object[nColumns];
    for (int iCol = 0; iCol < nColumns; iCol++) {
      bufferedData[iCol] = columnBuffers[iCol].getBuffer();
    }
    return new ResultSetFetchResult(bufferedData, isFinished);
  }
}
