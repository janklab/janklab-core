package net.janklab.mdbc.params;

/**
 * JDBC-specific date/time utilities.
 */
public class JdbcTimeUtil {
    public static final long UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS = 719529;
    public static final int SECONDS_PER_DAY = 24 * 60 * 60;
    public static final int MILLISECONDS_PER_DAY = SECONDS_PER_DAY * 1000;
    public static final long UNIX_TO_DATENUM_EPOCH_OFFSET_SECONDS = UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS * SECONDS_PER_DAY;

    public static long datenum2javaTimeUtc(double datenum) {
      long unixTime = (long) ((datenum - UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS) 
              * MILLISECONDS_PER_DAY);
      return unixTime;
    }
        
    /**
     * Convert a Matlab datenum, interpreted as UTC, to the equivalent java.sql.Date.
     * @param datenum
     * @return 
     */
    public static java.sql.Date datenum2javaSqlDateUtc(double datenum) {
      return new java.sql.Date(datenum2javaTimeUtc(datenum));
    }
  
}
