package net.janklab.time;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.Calendar;
import java.util.Date;

/**
 * Date/time utility methods.
 */
public class TimeUtil {

    /** The offset in days between the Matlab datenum epoch and the Unix epoch.
     * Determined by doing `datenum('1/1/1970')` in Matlab. */
    public static final long UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS = 719529;
    public static final int SECONDS_PER_DAY = 24 * 60 * 60;
    public static final long MILLIS_PER_DAY = SECONDS_PER_DAY * 1000;
    public static final long UNIX_TO_DATENUM_EPOCH_OFFSET_SECONDS = UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS * SECONDS_PER_DAY;
    public static final long UNIX_TO_DATENUM_EPOCH_OFFSET_MILLIS = UNIX_TO_DATENUM_EPOCH_OFFSET_SECONDS * 1000;

    public static double unixEpochSecondsToDatenum(long unixEpochSeconds) {
        return ((double)(unixEpochSeconds + UNIX_TO_DATENUM_EPOCH_OFFSET_SECONDS))
                / ((double) SECONDS_PER_DAY);
    }

    public static double unixEpochSecondsToDatenum(double unixEpochSeconds) {
        return (unixEpochSeconds + UNIX_TO_DATENUM_EPOCH_OFFSET_SECONDS)
                / ((double) SECONDS_PER_DAY);
    }

    public static double unixEpochMillisecondsToDatenum(long unixEpochMillis) {
        return ((double)(unixEpochMillis + UNIX_TO_DATENUM_EPOCH_OFFSET_MILLIS))
                / ((double) MILLIS_PER_DAY);
    }

    @SuppressWarnings("deprecation")
    public static double javaDateToDatenum(Date date) {
        return unixEpochMillisecondsToDatenum(date.getTime() - (date.getTimezoneOffset() * 60 * 1000));
    }

    public static double javaCalendarToDatenum(Calendar calendar) {
        return unixEpochMillisecondsToDatenum(calendar.getTimeInMillis());
    }

    /**
     * Convert a LocalDate to a Matlab datenum.
     * @param d LocalDate to convert
     * @return The equivalent Matlab datenum value, as double
     */
    public static double javaLocalDate2datenum(LocalDate d) {
      long epochDay = d.toEpochDay();
      double datenum = epochDay + UNIX_TO_DATENUM_EPOCH_OFFSET_DAYS;
      return datenum;
    }
    
    /**
     * Convert a java.time.LocalDateTime to a Matlab datenum. This is done without
     * reference to any time zones.
     * @param dt LocalDateTime to convert
     * @return The closest equivalent Matlab datenum value, as a double.
     */
    public static double javaLocalDateTime2datenum(LocalDateTime dt) {
        // Pretend this is UTC so there are no time-zone offsets involved; really this
        // is a zoneless local date.
        double unixEpochSeconds = (double) dt.toEpochSecond(ZoneOffset.UTC);
        unixEpochSeconds += dt.getNano() / 1_000_000_000;
        double datenum = unixEpochSecondsToDatenum(unixEpochSeconds);
        return datenum;
    }
    
    /**
     * Convert java.time.LocalDateTimes to Matlab datenums. This is done without
     * reference to any time zones.
     * @param dates LocalDateTimes to convert
     * @return The closest equivalent Matlab datenum values, as doubles.
     */
    public static double[] javaLocalDateTime2datenum(LocalDateTime[] dates) {
        double[] out = new double[dates.length];
        for (int i = 0; i < dates.length; i++) {
            out[i] = javaLocalDateTime2datenum(dates[i]);
        }
        return out;
    }
}
