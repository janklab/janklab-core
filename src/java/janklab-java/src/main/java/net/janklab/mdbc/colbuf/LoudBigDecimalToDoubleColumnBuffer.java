package net.janklab.mdbc.colbuf;

import it.unimi.dsi.fastutil.doubles.DoubleArrayList;
import java.math.BigDecimal;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Fetches BigDecimals, converts to doubles, and warns upon roundoff.
 *
 * This is a ColumnBuffer that handles converting SQL DECIMAL values to doubles,
 * with notification on roundoff/overflow errors. This fetches values as
 * BigDecimals/doubles, converts them to doubles for buffering, and detects
 * roundoff/overflow errors, issuing a warning when they happen.
 *
 * Roundoff error detection is not exact: because BigDecimal is decimal, and
 * double is binary, there's always potential for some roundoff. This class
 * detects roundoff and overflow errors due to the magnitude of the values being
 * passed around. So it's more like just overflow detection. The roundoff
 * detection isn't exact roundoff detection; it's more like, if you
 * round-tripped this value from BigDecimal to double and back, would there be
 * errors within the original scale of the initial value, not whether they'd be
 * exactly the same value.
 *
 * This is not the fastest class in the world, because it spends a lot of
 * processing power on error detection.
 */
public class LoudBigDecimalToDoubleColumnBuffer extends AbstractColumnBuffer {

  private DoubleArrayList buf;

  /**
   * The threshold at which integer values of BigDecimals are subject to
   * roundoff error when converted to doubles (IEEE doubles). Integer values
   * smaller than this can be represented exactly by IEEE doubles.
   */
  public static final BigDecimal DOUBLE_INT_ROUNDOFF_THRESHOLD
          = new BigDecimal(9007199254740991L);

  @Override
  public void attach(ResultSet rs, int colIndex) throws SQLException {
    super.attach(rs, colIndex);
    buf = new DoubleArrayList();
  }

  @Override
  public void fetchNextValue() throws SQLException {
    // Value for buffering
    double doubleVal = rs.getDouble(colIndex);
    if (rs.wasNull()) {
      buf.add(Double.NaN);
      return;
    }
    // Value for overflow detection
    BigDecimal val = rs.getBigDecimal(colIndex);

    // Detect and warn on roundoff
    if (val.scale() <= 0) {
      // Integer case: warn on any roundoff
      if (val.abs().compareTo(DOUBLE_INT_ROUNDOFF_THRESHOLD) > 0) {
        BigDecimal reconverted = BigDecimal.valueOf(doubleVal);
        BigDecimal error = val.subtract(reconverted);
        if (error.compareTo(val) != 0) {
          roundoffWarning(val, doubleVal);
        }
      }
    } else {
      // Fractional case: warn when exceeding double precision
      // Quick test: we know the precision of a double is about 16 decimal digits.
      // Just check for that. This won't catch all roundoff errors at values
      // near epsilon, but is fast to do, and should catch most errors.
      // This may also raise false positives when the actual BigDecimal values 
      // have trailing zeroes.
      int precision = val.precision();
      if (precision > 16) {
        roundoffWarning(val, doubleVal);
      }
    }

    buf.add(doubleVal);
  }
  
  private void roundoffWarning(BigDecimal originalVal, 
          double roundedVal) {
    BigDecimal reconverted = BigDecimal.valueOf(roundedVal);
    BigDecimal error = originalVal.subtract(reconverted);
    String str = String.format("WARNING: Column %d (\"%s\", BigDecimal to double): "
            + "Roundoff error: original value %s, rounded value %s, error %s",
            colIndex, colLabel, 
            originalVal.toPlainString(), ""+roundedVal, error.toPlainString());
    System.err.println(str);
  }

  @Override
  public double[] getBuffer() {
    return buf.toArray(new double[0]);
  }

}
