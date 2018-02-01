package net.janklab.etl.csvtable;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.format.FormatStyle;
import java.util.ArrayList;
import java.util.Objects;

/**
 *
 */
public class LocalDateTimeColBuffer extends ColBuffer {
    /** The buffered data. */
    private final ArrayList<LocalDateTime> buf = new ArrayList<>();
    /** Date format specified by the caller. */
    DateTimeFormatter specifiedDateFormat;
    /** Date format being used for this column. */
    DateTimeFormatter dateFormat;
    /** All date formats supported by this buffer type. */
    private static final DateTimeFormatter[] VALID_FORMATS = {
        DateTimeFormatter.ISO_LOCAL_DATE_TIME,
        DateTimeFormatter.ofLocalizedDateTime(FormatStyle.FULL),
        DateTimeFormatter.ofLocalizedDateTime(FormatStyle.LONG),
        DateTimeFormatter.ofLocalizedDateTime(FormatStyle.MEDIUM),
        DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT)
    };
    
    LocalDateTimeColBuffer(DateTimeFormatter specifiedDateFormat) {
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
                for (int iFormat = 0; iFormat < VALID_FORMATS.length; iFormat++) {
                    DateTimeFormatter fmt = VALID_FORMATS[iFormat];
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
                throw new IllegalArgumentException("Failed detecting datetime format for column; could not parse '"
                        + cellValue + "' as a datetime");
            }
        }
        // Parse and buffer value
        LocalDateTime datetime = LocalDateTime.parse(cellValue, dateFormat);
        buf.add(datetime);
    }

    @Override
    public LocalDateTime[] getValues() {
        return buf.toArray(new LocalDateTime[0]);
    }
}
