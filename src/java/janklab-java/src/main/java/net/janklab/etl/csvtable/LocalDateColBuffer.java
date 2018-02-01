package net.janklab.etl.csvtable;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.format.FormatStyle;
import java.util.ArrayList;
import java.util.Objects;

/**
 *
 */
public class LocalDateColBuffer extends ColBuffer {
    /** The buffered data. */
    private final ArrayList<LocalDate> buf = new ArrayList<>();
    /** Date format specified by the caller. */
    DateTimeFormatter specifiedDateFormat;
    /** Date format being used for this column. */
    DateTimeFormatter dateFormat;
    /** All date formats supported by this buffer type. */
    private static final DateTimeFormatter[] validFormats = {
        DateTimeFormatter.ISO_LOCAL_DATE,
        DateTimeFormatter.BASIC_ISO_DATE,
        DateTimeFormatter.ofLocalizedDate(FormatStyle.FULL),
        DateTimeFormatter.ofLocalizedDate(FormatStyle.LONG),
        DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM),
        DateTimeFormatter.ofLocalizedDate(FormatStyle.SHORT)
    };
    
    // Caching optimization
    /** Last-seen cell contents. */
    private String lastSeenCellValue = null;
    /** Last-seen parsed date value. */
    private LocalDate lastSeenDateValue = null;

    LocalDateColBuffer(DateTimeFormatter specifiedDateFormat) {
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
                throw new IllegalArgumentException("Failed detecting date format for column; could not parse '"
                        + cellValue + "' as a date");
            }
        }
        // Parse and buffer value, using caching optimization
        if (lastSeenCellValue != null && cellValue.equals(lastSeenCellValue)) {
            buf.add(lastSeenDateValue);
            return;
        }
        LocalDate date = LocalDate.parse(cellValue, dateFormat);
        buf.add(date);
        lastSeenCellValue = cellValue;
        lastSeenDateValue = date;
    }

    @Override
    public LocalDate[] getValues() {
        return buf.toArray(new LocalDate[0]);
    }
}
