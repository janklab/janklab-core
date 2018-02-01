package net.janklab.time;

import java.time.LocalDateTime;
import java.time.ZoneOffset;

/**
 * Date/time utility methods.
 */
public class TimeUtil {

    /** The offset in days between the Matlab datenum epoch and the Unix epoch.
     * Determined by doing `datenum('1/1/1970')` in Matlab. */
    public static final long unixToDatenumEpochOffsetDays = 719529;
    public static final int secondsPerDay = 24 * 60 * 60;
    public static final long unixToDatenumEpochOffsetSeconds = unixToDatenumEpochOffsetDays * secondsPerDay;
    
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
        double datenum = (((double) unixEpochSeconds) + unixToDatenumEpochOffsetSeconds)
                / ((double) secondsPerDay);
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
