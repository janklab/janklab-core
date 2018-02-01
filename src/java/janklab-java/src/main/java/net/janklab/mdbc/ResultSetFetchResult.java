package net.janklab.mdbc;

/**
 * The result of fetching some data from a result set.
 */
public class ResultSetFetchResult {
  /** True if the end of the ResultSet was hit during this fetch. */
  public final boolean isFinished;
  /** Buffered column data for each column, in Matlab handoff format. */
  public final Object[] bufferedColumnData;
  
  public ResultSetFetchResult(Object[] bufferedColumnData, boolean isFinished) {
    this.bufferedColumnData = bufferedColumnData;
    this.isFinished = isFinished;
  }
}
