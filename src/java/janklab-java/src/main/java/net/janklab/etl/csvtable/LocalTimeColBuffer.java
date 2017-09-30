package net.janklab.etl.csvtable;

import org.threeten.bp.LocalTime;
import org.threeten.bp.format.DateTimeFormatter;
import org.threeten.bp.format.DateTimeParseException;
import org.threeten.bp.format.FormatStyle;
import java.util.ArrayList;
import java.util.Objects;

/**
 *
 */
public class LocalTimeColBuffer extends ColBuffer {
    /** The buffered data. */
    private final ArrayList<LocalTime> buf = new ArrayList<>();
    /** Date format specified by the caller. */
    DateTimeFormatter specifiedDateFormat;
    /** Date format being used for this column. */
    DateTimeFormatter dateFormat;
    /** All date formats supported by this buffer type. */
    private static final DateTimeFormatter[] validFormats = {
        DateTimeFormatter.ISO_LOCAL_TIME,
        DateTimeFormatter.ofLocalizedTime(FormatStyle.FULL),
        DateTimeFormatter.ofLocalizedTime(FormatStyle.LONG),
        DateTimeFormatter.ofLocalizedTime(FormatStyle.MEDIUM),
        DateTimeFormatter.ofLocalizedTime(FormatStyle.SHORT)
    };
    
    LocalTimeColBuffer(DateTimeFormatter specifiedDateFormat) {
        this.specifiedDateFormat = specifiedDateFormat;
    }
    
    @Override
    public void addValue(String cellValue) throws IllegalArgumentException {
        Objects.requireNonNull(cellValue);
        // On first cell, detect date format
        if (buf.isEmpty()) {
            // Prefer format explicitly specified by caller
            if (specifiedDateFormat != null) {
                dateFormat = specifiedDateFormat;
            }
            // Otherwise, autodetect format from cell contents
            if (dateFormat == null) {
                for (int iFormat = 0; iFormat < validFormats.length; iFormat++) {
                    DateTimeFormatter fmt = validFormats[iFormat];
                    try {
                        fmt.parse(cellValue);
                        dateFormat = fmt;
                        break;
                    } catch (DateTimeParseException dtpe) {
                        // quash and try next formatter
                    }
                }
            }
            if (dateFormat == null) {
                // All formats failed
                throw new IllegalArgumentException("Failed detecting time format for column; could not parse '"
                        + cellValue + "' as a time");
            }
        }
        LocalTime time = LocalTime.parse(cellValue, dateFormat);
        buf.add(time);
    }

    @Override
    public LocalTime[] getValues() {
        return buf.toArray(new LocalTime[0]);
    }
}
