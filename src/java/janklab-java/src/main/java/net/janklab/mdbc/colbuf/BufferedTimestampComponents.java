package net.janklab.mdbc.colbuf;

/**
 * A holder for broken-down timestamp component values.
 */
public class BufferedTimestampComponents {
  
  public final double[] datenums;
  public final long[] nanosOfDays;

  public BufferedTimestampComponents(double[] datenums, long[] nanosOfDays) {
    this.datenums = datenums;
    this.nanosOfDays = nanosOfDays;
  }
  
}
